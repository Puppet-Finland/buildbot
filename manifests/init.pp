#
# == Class: buildbot
#
# Setup buildbot
#
# == Parameters
#
# [*default_buildmaster_address*]
# [*default_buildmaster_port*]
# [*default_admin*]
# [*default_email*]
#   Default settings for ::buildbot::slave instances.
# [*masters*]
#   A hash of buildbot::master resources to realize.
# [*slaves*]
#   A hash of buildbot::slave resources to realize.
#
class buildbot
(
    Optional[String]  $default_buildmaster_address,
    Optional[Integer] $default_buildmaster_port = 9989,
    Optional[String]  $default_admin = $::serveradmin,
    Optional[String]  $default_email = $::serveradmin,
    Hash              $masters = {},
    Hash              $slaves = {}
)
{
    # Create buildmaster and buildslave instances
    create_resources('buildbot::master', $masters)
    create_resources('buildbot::slave', $slaves)

}
