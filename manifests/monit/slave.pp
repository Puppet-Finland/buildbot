#
# == Define: buildbot::monit::slave
#
# This is a define instead of a class because each Twisted instance / buildslave 
# has it's own pid which we need to track.
#
# == Parameters
#
# [*title*]
#   While not strictly a parameter, the resource title is used as an identifier
#   for this buildslave instance.
#
define buildbot::monit::slave {

    include monit::params

    file { "buildbot-${title}-buildslave.monit":
        name => "${::monit::params::fragment_dir}/buildslave-${title}.monit",
        content => template('buildbot/buildslave.monit.erb'),
        owner => root,
        group => root,
        mode => 600,
        require => Class['monit::config'],
        notify => Class['monit::service'],
    }
}

