#
# == Class: buildbot::config::slave
#
# A class for configuring buildslaves
#
define buildbot::config::slave
(
    $buildmaster_address,
    $buildmaster_port,
    $buildslave_name,
    $buildslave_password,
    $email
)
{
    include buildbot::params

    $buildslave_dir = "${::buildbot::params::buildslave_basedir}/${buildslave_name}"

    file { 'buildbot-buildslave_basedir':
        name => "${::buildbot::params::buildslave_basedir}",
        ensure => directory,
        owner => "${buildbot::params::buildbot_user}",
        group => "${buildbot::params::buildbot_group}",
        mode => 755,
        require => Class['buildbot::config::common'],
    }

    exec { 'buildbot-create-slave':
        command => "${::buildbot::params::buildslave_executable} create-slave ${buildslave_dir} ${buildmaster_address}:${buildmaster_port} ${buildslave_name} ${buildslave_password}",
        creates => "${buildslave_dir}",
        require => File['buildbot-buildslave_basedir'],
        user => root,
    } 
}
