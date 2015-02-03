#
# == Class: buildbot
#
# Setup buildbot
#
# == Parameters
#
# [*masters*]
#   A hash of buildbot::master resources to realize.
# [*slaves*]
#   A hash of buildbot::slave resources to realize.
#
class buildbot
(
    $masters = {},
    $slaves = {}
)
{
    # Create buildmaster and buildslave instances
    create_resources('buildbot::master', $masters)
    create_resources('buildbot::slave', $slaves)

}
