#
# == Define: buildbot::master
#
# Create a new buildmaster. Note that this define is highly Debian-specific at 
# the moment. Setup of master.cfg is not supported as it's likely to be highly 
# site- and project-specific.
#
# == Parameters
#
# [*title*]
#   While not strictly a parameter, the resource title is used as a basename for 
#   the new master's directory. For example, on Debian 'mymaster' will create a 
#   new master with it's base directory at /var/lib/buildbot/masters/mymaster'.
# [*index*]
#   The index number for this master. This is used in Debian's init scripts and 
#   defaults file to distinguish between settings of different masters.
#
# == Examples
#
# include buildbot
# buildbot::master { 'mymaster':
#   index => '1',
# }
#
define buildbot::master
(
    $index
)
{

    # Run buildbot's create-master command
    exec { "$buildbot-create-master-$title":
        command => "buildbot create-master -r /var/lib/buildbot/masters/$title",
        creates => "/var/lib/buildbot/masters/$title",
        user => 'buildbot',
        path => [ '/usr/bin' ],
        require => Class['buildbot::install'],
    }

    # Make sure the default file is configured to launch all masters at boot
    $default_file = '/etc/default/buildmaster'

    augeas { "buildbot-${title}-${index}-MASTER_ENABLED":
        context => "/files$default_file",
        changes => "set MASTER_ENABLED\[$index\] 1",
        lens => 'Shellvars.lns',
        incl => "$default_file",
    }

    augeas { "buildbot-${title}-${index}-MASTER_NAME":
        context => "/files$default_file",
        changes => "set MASTER_NAME\[$index\] $title",
        lens => 'Shellvars.lns',
        incl => "$default_file",
    }

    augeas { "buildbot-${title}-${index}-MASTER_USER":
        context => "/files$default_file",
        changes => "set MASTER_USER\[$index\] buildbot",
        lens => 'Shellvars.lns',
        incl => "$default_file",
    }

    augeas { "buildbot-${title}-${index}-MASTER_BASEDIR":
        context => "/files$default_file",
        changes => "set MASTER_BASEDIR\[$index\] /var/lib/buildbot/masters/$title",
        lens => 'Shellvars.lns',
        incl => "$default_file",
    }

    augeas { "buildbot-${title}-${index}-MASTER_OPTIONS":
        context => "/files$default_file",
        changes => "set MASTER_OPTIONS\[$index\] \"\"",
        lens => 'Shellvars.lns',
        incl => "$default_file",
    }

    augeas { "buildbot-${title}-${index}-MASTER_PREFIXCMD":
        context => "/files$default_file",
        changes => "set MASTER_PREFIXCMD\[$index\] \"\"",
        lens => 'Shellvars.lns',
        incl => "$default_file",
    }
}
