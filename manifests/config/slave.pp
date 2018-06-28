#
# == Class: buildbot::config::slave
#
# A class for configuring buildslaves
#
define buildbot::config::slave
(
    String  $buildmaster_address,
    Integer $buildmaster_port,
    String  $buildslave_remote_name,
    String  $buildslave_password,
    String  $buildslave_local_name,
    String  $run_as_user,
    String  $admin,
    String  $email
)
{
    include ::buildbot::params

    $buildslave_dir = "${::buildbot::params::buildslave_basedir}/${buildslave_local_name}"

    file { "buildbot-${buildslave_local_name}-basedir":
        ensure  => directory,
        name    => $::buildbot::params::buildslave_basedir,
        owner   => $buildbot::params::buildbot_user,
        group   => $buildbot::params::buildbot_group,
        mode    => '0755',
        require => Class['buildbot::config::common'],
    }

    exec { "buildbot-${buildslave_local_name}-create-slave":
        command => "${::buildbot::params::buildslave_executable} create-slave ${buildslave_dir} ${buildmaster_address}:${buildmaster_port} ${buildslave_remote_name} ${buildslave_password}",
        creates => $buildslave_dir,
        require => File["buildbot-${buildslave_local_name}-basedir"],
        user    => $run_as_user,
    }

    # Ensure that buildbot.tac is updated in case slave parameters change
    $buildbot_tac = "${buildslave_dir}/buildbot.tac"
    $buildbot_tac_params = {'buildmaster_host' => "\'${buildmaster_address}\'",
                            'port'             => $buildmaster_port,
                            'slavename'        => "\'${buildslave_remote_name}\'",
                            'passwd'           => "\'${buildslave_password}\'", }

    # We can only notify the buildbot service on certain operating systems
    $notify_service = $::osfamily ? {
        'Debian' => Class['::buildbot::service::slave::debian'],
        default  => undef,
    }

    # Loop through the defined parameters and change them as necessary
    $buildbot_tac_params.each |$param| {
        file_line { "buildbot-${param[0]}":
            ensure  => 'present',
            line    => "${param[0]} = ${param[1]}",
            match   => "^${param[0]}",
            path    => $buildbot_tac,
            notify  => $notify_service,
            require => Exec["buildbot-${buildslave_local_name}-create-slave"],
        }
    }

    file { "buildbot-${buildslave_local_name}-admin":
        name    => "${buildslave_dir}/info/admin",
        content => "${admin} <${email}>",
        require => Exec["buildbot-${buildslave_local_name}-create-slave"],
    }

    file { "buildbot-${buildslave_local_name}-host":
        name    => "${buildslave_dir}/info/host",
        content => template('buildbot/host.erb'),
        require => Exec["buildbot-${buildslave_local_name}-create-slave"],
    }
}
