#
# == Define: buildbot::slave
#
# A define for setting up buildslaves.
#
# == Parameters
#
# [*manage*]
#   Whether to manage buildslaves with Puppet or not. Valid values are true
#   (default) and false.
# [*buildmaster_address*]
#   The IP-address of the buildmaster server the slave connects to. Defaults to 
#   $::buildbot::default_buildmaster_address.
# [*buildmaster_port*]
#   The port the buildmaster server is listening on. Defaults to 
#   $::buildbot::default_buildmaster_port, which in turn defaults to 9989.
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
#   in buildslave information. Defaults to $::buildbot::default_admin, which in
#   turn defaults to $::serveradmin.
# [*email*]
#   Email address of this buildslave's administrator shown in this buildslave's 
#   information. Service notifications (e.g. from monit) will also be sent to 
#   this address. Defaults to $::buildbot::default_email, which in turn defaults 
#   to $::serveradmin.
# [*index*]
#   The index number for this slave. This is used in Debian's init scripts and 
#   defaults file to distinguish between settings of different slaves. Defaults 
#   to 0.
#
# == Examples
#
#   include buildbot
#
# == Authors
#
# Samuli Seppänen <samuli.seppanen@gmail.com>
#
# Samuli Seppänen <samuli@openvpn.net>
#
# == License
#
# BSD-license. See file LICENSE for details.
#
define buildbot::slave
(
    $buildslave_remote_name,
    $buildslave_password,
    $buildslave_local_name,
    $manage = true,
    $buildmaster_address = undef,
    $buildmaster_port = undef,
    $buildbot_user = undef,
    $admin = undef,
    $email = undef,
    $index = 0
)
{

if $manage {

    # Get default values from the ::buildbot class
    if $buildmaster_address == undef { $l_buildmaster_address = $::buildbot::default_buildmaster_address } else { $l_buildmaster_address = $buildmaster_address }
    if $buildmaster_port == undef    { $l_buildmaster_port = $::buildbot::default_buildmaster_port       } else { $l_buildmaster_port = $buildmaster_port }
    if $admin == undef               { $l_admin = $::buildbot::default_admin                             } else { $l_admin = $admin }
    if $email == undef               { $l_email = $::buildbot::default_email                             } else { $l_email = $email }

    include ::buildbot::params
    include ::buildbot::install::slave
    include ::buildbot::config::common

    # Check if buildbot should run as a custom user
    if $buildbot_user {
        $run_as_user = $buildbot_user
    } else {
        $run_as_user = $::buildbot::params::buildbot_user
    }

    buildbot::config::slave { "${buildslave_local_name}-config":
        buildmaster_address    => $l_buildmaster_address,
        buildmaster_port       => $l_buildmaster_port,
        buildslave_remote_name => $buildslave_remote_name,
        buildslave_password    => $buildslave_password,
        buildslave_local_name  => $buildslave_local_name,
        run_as_user            => $run_as_user,
        admin                  => $l_admin,
        email                  => $l_email,
    }

    if $::osfamily == 'Debian' {

        # Enable buildbot on boot
        include ::buildbot::service::slave::debian

        buildbot::config::slave::debian { $buildslave_local_name:
            index       => $index,
            run_as_user => $run_as_user,
        }
    }

    if tagged('monit') {
        buildbot::monit::slave { $buildslave_local_name: }
    }

}
}
