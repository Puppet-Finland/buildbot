#
# == Class: buildbot
#
# Install and configure buildbot
#
# == Parameters
#
# None at the moment
#
# == Examples
#
# include buildbot
#
# == Authors
#
# Samuli Seppänen <samuli@openvpn.net>
#
# == License
#
# BSD-lisence
# See file LICENSE for details
#
class buildbot {

# Rationale for this is explained in init.pp of the sshd module
if hiera('manage_buildbot') != 'false' {

    include buildbot::install
}
}
