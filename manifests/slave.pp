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
# [*buildslave_name*]
#   The name of the buildslave. Used when connecting to the buildmaster as well 
#   for distinguish it from other buildslaves running on the same computers.
# [*buildslave_password*]
#   The password the buildslave uses when connecting to the master.
# [*email*]
#   Email address of this buildslave's administrator shown in this buildslave's 
#   information. Service notifications (e.g. from monit) will also be sent to 
#   this address. Defaults to $::serveradmin.
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
    $buildslave_name,
    $buildslave_password,
    $email = $::serveradmin
)
{

# Rationale for this is explained in init.pp of the sshd module
if hiera('manage_buildbot_slave', 'true') != 'false' {

    include buildbot::install::slave
    include buildbot::config::common

    buildbot::config::slave { "${buildslave_name}-config":
        buildmaster_address => $buildmaster_address,
        buildmaster_port => $buildmaster_port,
        buildslave_name => $buildslave_name,
        buildslave_password => $buildslave_password,
        email => $email,
    }
}
}
