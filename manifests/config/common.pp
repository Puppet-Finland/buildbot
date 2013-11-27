#
# == Class: buildbot::config::common
#
# Configure things common to buildslaves and buildmasters
#
class buildbot::config::common {

    include buildbot::params

    file { 'buildbot-basedir':
        name => "${::buildbot::params::buildbot_basedir}",
        ensure => directory,
        owner => "${::buildbot::params::buildbot_user}",
        group => "${::buildbot::params::buildbot_group}",
        mode => 755,
    }
}
