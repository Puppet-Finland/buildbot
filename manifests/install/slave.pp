#
# == Class: buildbot::install::slave
#
# Install a buildslave
#
class buildbot::install::slave {

    include buildbot::params

    package { 'buildbot-buildbot':
        name => "${::buildbot::params::buildslave_package_name}",
        ensure => installed,
    }
}
