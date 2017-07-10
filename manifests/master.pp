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
# [*manage*]
#   Manage Buildmasters with Puppet. Valid values are true (default) and false.
# [*manage_monit*]
#   Manage monit rules. Valid values are true (default) and false.
# [*manage_packetfilter*]
#   Manage packet filtering rules. Valid values are true (default) and false.
# [*title*]
#   While not strictly a parameter, the resource title is used as a basename for 
#   the new master's directory. For example, on Debian 'mymaster' will create a 
#   new master with it's base directory at ${::buildbot::params::buildmaster_basedir}/mymaster'.
# [*index*]
#   The index number for this master. This is used in Debian's init scripts and 
#   defaults file to distinguish between settings of different masters.
# [*webui_port*}
#   Port on which the Buildbot webui listens. Currently only affects iptables/ip6tables rules. Defaults to
#   8010.
# [*buildslave_port*]
#   Port to which buildslaves connect. Currently only affects iptables/ip6tables 
#   rules. Defaults to 9989.
# [*webui_allow_address_ipv4*]
#   IPv4 addresses from which to allow connection to the webui. Use special 
#   value 'any' to allow connections from any address. Defaults to '127.0.0.1'.
# [*webui_allow_address_ipv6*]
#   The same as above but for ipv6. Defaults to '::1'.
# [*buildslave_allow_address_ipv4*]
#   The same as above but for ipv4 buildslave connections. Defaults to 
#   '127.0.0.1'.
# [*buildslave_allow_address_ipv6*]
#   The same as above but for ipv6 buildslave connections. Defaults to '::1'.
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
            $index,
    Boolean $manage = true,
    Boolean $manage_monit = true,
    Boolean $manage_packetfilter = true,
            $webui_port = 8010,
            $buildslave_port = 9989,
            $webui_allow_address_ipv4 = '127.0.0.1',
            $webui_allow_address_ipv6 = '::1',
            $buildslave_allow_address_ipv4 = '127.0.0.1',
            $buildslave_allow_address_ipv6 = '::1'
)
{

if $manage {

    include ::buildbot::params
    include ::buildbot::install::master
    include ::buildbot::config::common
    include ::buildbot::service::master

    # Run buildbot's create-master command
    exec { "buildbot-create-master-${title}":
        command => "${::buildbot::params::buildmaster_executable} create-master -r ${::buildbot::params::buildmaster_basedir}/${title}",
        creates => "${::buildbot::params::buildmaster_basedir}/${title}",
        user    => $::buildbot::params::buildbot_user,
        path    => [ '/usr/bin' ],
        require => Class['buildbot::install::master'],
    }

    if $::osfamily == 'Debian' {
        buildbot::config::master::debian { $title:
            index => $index,
        }
    }

    if $manage_monit {
        buildbot::monit { $title:
            type => 'master',
        }
    }

    if $manage_packetfilter {
        class { '::buildbot::master::packetfilter':
            webui_port                    => $webui_port,
            buildslave_port               => $buildslave_port,
            webui_allow_address_ipv4      => $webui_allow_address_ipv4,
            webui_allow_address_ipv6      => $webui_allow_address_ipv6,
            buildslave_allow_address_ipv4 => $buildslave_allow_address_ipv4,
            buildslave_allow_address_ipv6 => $buildslave_allow_address_ipv6,
        }
    }
}
}
