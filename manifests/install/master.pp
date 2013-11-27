#
# == Class: buildbot::install::master
#
# Install a buildmaster
#
class buildbot::install::master {

    include buildbot::params

    package { 'buildbot-buildbot':
        name => "${::buildbot::params::buildmaster_package_name}",
        ensure => installed,
    }
}
