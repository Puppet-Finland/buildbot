#
# == Class: buildbot::install::slave
#
# Install a buildslave
#
class buildbot::install::slave inherits buildbot::params {

    package { 'buildbot-buildbot':
        ensure   => installed,
        name     => $::buildbot::params::buildslave_package_name,
        provider => $::buildbot::params::package_provider,
    }
}
