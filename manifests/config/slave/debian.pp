#
# == Define: buildbot::config::slave::debian
#
# Debian-specific configuration of a buildslave.
#
define buildbot::config::slave::debian
(
    $index,
    $run_as_user
)
{

    # Make sure the default file is configured to launch all slaves at boot
    $default_file = '/etc/default/buildslave'

    augeas { "buildbot-${title}-${index}-SLAVE_ENABLED":
        context => "/files$default_file",
        changes => "set SLAVE_ENABLED\[$index\] 1",
        lens => 'Shellvars.lns',
        incl => "$default_file",
    }

    augeas { "buildbot-${title}-${index}-SLAVE_NAME":
        context => "/files$default_file",
        changes => "set SLAVE_NAME\[$index\] $title",
        lens => 'Shellvars.lns',
        incl => "$default_file",
    }

    augeas { "buildbot-${title}-${index}-SLAVE_USER":
        context => "/files$default_file",
        changes => "set SLAVE_USER\[$index\] $run_as_user",
        lens => 'Shellvars.lns',
        incl => "$default_file",
    }

    augeas { "buildbot-${title}-${index}-SLAVE_BASEDIR":
        context => "/files$default_file",
        changes => "set SLAVE_BASEDIR\[$index\] ${::buildbot::params::buildslave_basedir}/$title",
        lens => 'Shellvars.lns',
        incl => "$default_file",
    }

    augeas { "buildbot-${title}-${index}-SLAVE_OPTIONS":
        context => "/files$default_file",
        changes => "set SLAVE_OPTIONS\[$index\] \"\"",
        lens => 'Shellvars.lns',
        incl => "$default_file",
    }

    augeas { "buildbot-${title}-${index}-SLAVE_PREFIXCMD":
        context => "/files$default_file",
        changes => "set SLAVE_PREFIXCMD\[$index\] \"\"",
        lens => 'Shellvars.lns',
        incl => "$default_file",
    }
}
