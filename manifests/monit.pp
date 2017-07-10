#
# == Define: buildbot::monit
#
# This is a define instead of a class because each Twisted instance has it's own 
# pid which we need to track.
#
# == Parameters
#
# [*title*]
#   While not strictly a parameter, the resource title is used as an identifier
#   for this buildbot instance.
# [*type*]
#   Buildbot instance type. Either 'master' or 'slave' (default).
#
define buildbot::monit
(
    Enum['master','slave'] $type = 'slave'
)
{
    include ::monit::params
    include ::buildbot::params

    if $type == 'slave' {
        $buildbot_basedir = $::buildbot::params::buildslave_basedir
        $buildbot_executable = $::buildbot::params::buildslave_executable
    } else {
        $buildbot_basedir = $::buildbot::params::buildmaster_basedir
        $buildbot_executable = $::buildbot::params::buildmaster_executable
    }

    # Remove obsolete buildslave monit fragment, if any
    file { "buildbot-${title}-buildslave.monit":
        ensure => 'absent',
        name   => "${::monit::params::fragment_dir}/buildslave-${title}.monit",
    }

    # Add monit fragment for this buildbot instance
    file { "buildbot-${title}-buildbot.monit":
        ensure  => 'present',
        name    => "${::monit::params::fragment_dir}/buildbot-${title}.monit",
        content => template('buildbot/buildbot.monit.erb'),
        owner   => $::os::params::adminuser,
        group   => $::os::params::admingroup,
        mode    => '0600',
        require => Class['monit::config'],
        notify  => Class['monit::service'],
    }
}
