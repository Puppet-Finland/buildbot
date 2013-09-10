#
# == Class: buildbot::install
#
# Install buildbot
#
class buildbot::install {

    package { 'buildbot-buildbot':
        name => 'buildbot',
        ensure => installed,
    }
}
