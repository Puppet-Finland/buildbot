#
# == Define: buildbot::slave
#
# A define for setting up buildslaves.
#
# == Parameters
#
# [*buildmaster_address*]
#   The IP-address of the buildmaster server the slave connects to. No default
#   value.
# [*buildmaster_port*]
#   The port the buildmaster server is listening on. Defaults to 9989.
# [*buildslave_remote_name*]
#   The name of the buildslave. Used for authentication when connecting to the 
#   buildmaster.
# [*buildslave_password*]
#   The password the buildslave uses when connecting to the master.
# [*buildslave_local_name*]
#   The name of the buildslave on the local computer. Used to distinguish it 
#   from other local buildslave instances, which might contact other 
#   buildmasters.
# [*buildbot_user*]
#   Local user the buildbot runs as. Defaults 
#   ${::buildbot::params::buildbot_user}
# [*admin*]
#   The real name of the administrator of this buildslave, which will be shown 
#   in buildslave information. Defaults to $::serveradmin.
# [*email*]
#   Email address of this buildslave's administrator shown in this buildslave's 
#   information. Service notifications (e.g. from monit) will also be sent to 
#   this address. Defaults to $::serveradmin.
# [*index*]
#   The index number for this slave. This is used in Debian's init scripts and 
#   defaults file to distinguish between settings of different slaves. Defaults 
#   to 0.
#
# == Examples
#
# include buildbot
#
# == Authors
#
# Samuli Seppänen <samuli.seppanen@gmail.com>
# Samuli Seppänen <samuli@openvpn.net>
#
# == License
#
# BSD-lisence
# See file LICENSE for details
#
define buildbot::slave
(
    $buildmaster_address,
    $buildmaster_port = 9989,
    $buildslave_remote_name,
    $buildslave_password,
    $buildslave_local_name,
    $buildbot_user = '',
    $admin = $::serveradmin,
    $email = $::serveradmin,
    $index = 0
)
{

# Rationale for this is explained in init.pp of the sshd module
if hiera('manage_buildbot_slave', 'true') != 'false' {

    include buildbot::params

    include buildbot::install::slave
    include buildbot::config::common

    # Check if buildbot should run as a custom user
    if $buildbot_user == '' {
        $run_as_user = "${::buildbot::params::buildbot_user}"
    } else {
        $run_as_user = $buildbot_user
    }

    buildbot::config::slave { "${buildslave_local_name}-config":
        buildmaster_address => $buildmaster_address,
        buildmaster_port => $buildmaster_port,
        buildslave_remote_name => $buildslave_remote_name,
        buildslave_password => $buildslave_password,
        buildslave_local_name => $buildslave_local_name,
        run_as_user => $run_as_user,
        admin => $admin,
        email => $email,
    }

    if $osfamily == 'Debian' {

        # Enable buildbot on boot
        include buildbot::service::slave::debian

        buildbot::config::slave::debian { "${buildslave_local_name}":
            index => $index,
            run_as_user => $run_as_user,
        }
    }

    if tagged('monit') {
        buildbot::monit::slave { "${buildslave_local_name}": }
    }

}
}
