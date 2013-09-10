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
    include buildbot::install
}
