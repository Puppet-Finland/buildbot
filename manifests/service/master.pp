#
# == Class: buildbot::service::master
#
# Enable the buildbot master service on boot
#
class buildbot::service::master {

    service { 'buildmaster':
        name => 'buildmaster',
        enable => true,
        require => Class['buildbot::install'],
    }    
}
