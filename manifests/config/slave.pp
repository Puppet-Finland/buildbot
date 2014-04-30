#
# == Class: buildbot::config::slave
#
# A class for configuring buildslaves
#
define buildbot::config::slave
(
    $buildmaster_address,
    $buildmaster_port,
    $buildslave_remote_name,
    $buildslave_password,
    $buildslave_local_name,
    $run_as_user,
    $admin,
    $email
)
{
    include buildbot::params

    $buildslave_dir = "${::buildbot::params::buildslave_basedir}/${buildslave_local_name}"

    file { "buildbot-${buildslave_local_name}-basedir":
        name => "${::buildbot::params::buildslave_basedir}",
        ensure => directory,
        owner => "${buildbot::params::buildbot_user}",
        group => "${buildbot::params::buildbot_group}",
        mode => 755,
        require => Class['buildbot::config::common'],
    }

    exec { "buildbot-${buildslave_local_name}-create-slave":
        command => "${::buildbot::params::buildslave_executable} create-slave ${buildslave_dir} ${buildmaster_address}:${buildmaster_port} ${buildslave_remote_name} ${buildslave_password}",
        creates => "${buildslave_dir}",
        require => File["buildbot-${buildslave_local_name}-basedir"],
        user => $run_as_user,
    } 

    file { "buildbot-${buildslave_local_name}-admin":
        name => "${buildslave_dir}/info/admin",
        content => "${admin} <${email}>",
        require => Exec["buildbot-${buildslave_local_name}-create-slave"],
    }

    file { "buildbot-${buildslave_local_name}-host":
        name => "${buildslave_dir}/info/host",
        content => template('buildbot/host.erb'),
        require => Exec["buildbot-${buildslave_local_name}-create-slave"],
    }
}
