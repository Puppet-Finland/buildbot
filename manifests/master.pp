#
# == Define: buildbot::master
#
# Create a new buildmaster.
#
# Support for operating systems other than Debian (and possibly Ubuntu) is still 
# partial. Also note that setup of master.cfg is not supported as it contents 
# are probably very site- and project-specific.
#
# == Parameters
#
# [*title*]
#   While not strictly a parameter, the resource title is used as a basename for 
#   the new master's directory. For example, on Debian 'mymaster' will create a 
#   new master with it's base directory at ${::buildbot::params::buildmaster_basedir}/mymaster'.
# [*index*]
#   The index number for this master. This is used in Debian's init scripts and 
#   defaults file to distinguish between settings of different masters.
#
# == Examples
#
#   include buildbot
#   buildbot::master { 'mymaster':
#       index => '1',
#   }
#
define buildbot::master
(
    $index
)
{

    include buildbot::params
    include buildbot::install::master
    include buildbot::config::common
    include buildbot::service::master

    # Run buildbot's create-master command
    exec { "buildbot-create-master-${title}":
        command => "${::buildbot::params::buildmaster_executable} create-master -r ${::buildbot::params::buildmaster_basedir}/${title}",
        creates => "${::buildbot::params::buildmaster_basedir}/${title}",
        user => "${::buildbot::params::buildbot_user}",
        path => [ '/usr/bin' ],
        require => Class['buildbot::install::master'],
    }

    if $osfamily == 'Debian' {
        buildbot::config::master::debian { "${title}":
            index => $index,
        }
    }
}
