#
# == Define: buildbot::config::master::debian
#
# Debian-specific configuration of a buildmaster.
#
define buildbot::config::master::debian
(
    $index
)
{
    include ::buildbot::params

    # Make sure the default file is configured to launch all masters at boot
    $default_file = '/etc/default/buildmaster'

    augeas { "buildbot-${title}-${index}-MASTER_ENABLED":
        context => "/files${default_file}",
        changes => "set MASTER_ENABLED\[${index}\] 1",
        lens    => 'Shellvars.lns',
        incl    => $default_file,
    }

    augeas { "buildbot-${title}-${index}-MASTER_NAME":
        context => "/files${default_file}",
        changes => "set MASTER_NAME\[${index}\] ${title}",
        lens    => 'Shellvars.lns',
        incl    => $default_file,
    }

    augeas { "buildbot-${title}-${index}-MASTER_USER":
        context => "/files${default_file}",
        changes => "set MASTER_USER\[${index}\] buildbot",
        lens    => 'Shellvars.lns',
        incl    => $default_file,
    }

    augeas { "buildbot-${title}-${index}-MASTER_BASEDIR":
        context => "/files${default_file}",
        changes => "set MASTER_BASEDIR\[${index}\] ${::buildbot::params::buildmaster_basedir}/${title}",
        lens    => 'Shellvars.lns',
        incl    => $default_file,
    }

    augeas { "buildbot-${title}-${index}-MASTER_OPTIONS":
        context => "/files${default_file}",
        changes => "set MASTER_OPTIONS\[${index}\] \"\"",
        lens    => 'Shellvars.lns',
        incl    => $default_file,
    }

    augeas { "buildbot-${title}-${index}-MASTER_PREFIXCMD":
        context => "/files${default_file}",
        changes => "set MASTER_PREFIXCMD\[${index}\] \"\"",
        lens    => 'Shellvars.lns',
        incl    => $default_file,
    }
}
