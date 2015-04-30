#
# == Class: buildbot::config::common
#
# Configure things common to buildslaves and buildmasters
#
class buildbot::config::common inherits buildbot::params {

    file { 'buildbot-basedir':
        ensure => directory,
        name   => $::buildbot::params::buildbot_basedir,
        owner  => $::buildbot::params::buildbot_user,
        group  => $::buildbot::params::buildbot_group,
        mode   => '0755',
    }
}
