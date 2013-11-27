#
# == Class: buildbot::service::master
#
# Enable the buildbot master service on boot
#
class buildbot::service::master {

    service { 'buildbot-master':
        name => "${::buildbot::params::buildmaster_service_name}",
        enable => true,
        require => Class['buildbot::install::master'],
    }    
}
