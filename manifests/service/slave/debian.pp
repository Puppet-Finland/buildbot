#
# == Class: buildbot::service::slave::debian
#
# Enable the buildbot slaves at boot time. This concept only works on operating 
# systems that have a single wrapper script used to launches all buildslaves at 
# once (like Debian).
#
class buildbot::service::slave::debian inherits buildbot::params {

    service { 'buildbot-slave':
        name    => $::buildbot::params::buildslave_service_name,
        enable  => true,
        require => Class['buildbot::install::slave'],
    }
}
