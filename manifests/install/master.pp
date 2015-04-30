#
# == Class: buildbot::install::master
#
# Install a buildmaster
#
class buildbot::install::master inherits buildbot::params {

    package { 'buildbot-buildbot':
        ensure => installed,
        name   => $::buildbot::params::buildmaster_package_name,
    }
}
