#
# == Define: buildbot::master
#
# Create a new buildmaster. Note that this define is highly Debian-specific at 
# the moment, and is a bit incomplete: you need to activate the new master by 
# editing /etc/default/buildmaster manually for now.
#
# == Parameters
#
# [*title*]
#   This is used as a basename for the new master's directory. For example, on 
#   Debian 'mymaster' will create a new master with it's base directory at 
#   /var/lib/buildbot/masters/mymaster'.
#
# == Examples
#
# include buildbot
# buildbot::master { 'mymaster': }
#
define buildbot::master {

    # Run buildbot's create-master command
    exec { "$buildbot-create-master-$title":
        command => "buildbot create-master -r /var/lib/buildbot/masters/$title",
        creates => "/var/lib/buildbot/masters/$title",
        user => 'buildbot',
        path => [ '/usr/bin' ],
        require => Class['buildbot::install'],
    }

}
