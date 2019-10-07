#
# == Class: buildbot::params
#
# Defines some variables based on the operating system
#
class buildbot::params {

    # Common variables
    $buildbot_basedir = '/var/lib/buildbot'
    $buildmaster_basedir = "${buildbot_basedir}/masters"
    $buildslave_basedir = "${buildbot_basedir}/slaves"

    # Operating system specific variables
    case $::osfamily {
        'RedHat': {
            $buildmaster_package_name = 'buildbot-master'
            $buildmaster_executable = '/usr/bin/buildbot'
            $buildmaster_service_name = 'buildbot-master'
            $buildslave_package_name = 'buildbot-slave'
            $buildslave_service_name = 'buildbot-slave'
            $buildbot_user = 'root'
            $buildbot_group = 'root'
        }
        'Debian': {
            $buildmaster_package_name = 'buildbot'
            $buildmaster_executable = '/usr/bin/buildbot'
            $buildmaster_service_name = 'buildmaster'
            $buildslave_package_name = 'buildbot-slave'
            $buildslave_service_name = 'buildslave'
            $buildbot_user = 'buildbot'
            $buildbot_group = 'buildbot'
        }
        default: {
            fail("Unsupported operating system: ${::osfamily}")
        }
    }

    # On recent operating systems the distro version of buildbot is too new, so
    # we need to install older buildbot using pip
    case $::lsbdistcodename {
        'bionic': {
            $package_provider = 'pip'
            $buildslave_executable = '/usr/local/bin/buildslave'
        }
        /(TwentyNine|Thirty)/: {
            $package_provider = 'pip'
            $buildslave_executable = '/usr/bin/buildslave'
        }
        default: {
            $package_provider = undef
            $buildslave_executable = '/usr/bin/buildslave'
        }
    }
}
