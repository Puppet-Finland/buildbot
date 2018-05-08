# buildbot

A Puppet module for managing buildbot

Tested operating systems are listed in metadata.json, but it is likely that more 
recent Debian and Fedora versions work as well or with minor modifications. Note 
that Fedora 24 does not have a unit file for starting buildslaves, but you 
can work around that issue by simply including the 
[Puppet-Finland/monit](https://github.com/Puppet-Finland/puppet-monit) class 
which will ensure that buildbot is always running.

# Module usage

Setting up buildslaves is fairly easy using Hiera. First setup some sane
defaults (e.g. in common.yaml):

    buildbot::default_buildmaster_address: '10.10.50.50'
    buildbot::default_email: 'john.doe@domain.com'
    buildbot::default_admin: 'John Doe'

Then create a buildslave:

    classes:
        - buildbot
    
    buildbot::slaves:
        myproject:
            buildslave_remote_name: 'slave-ubuntu-1604-amd64'
            buildslave_password: 'secret-password'
            buildslave_local_name: 'myproject'
            buildbot_user: 'root'
            index: 1

The index parameter is only needed on Debian/Ubuntu. For further details see 
these classes and defines:

* [Class: buildbot](manifests/init.pp)
* [Define: buildbot::master](manifests/master.pp)
* [Define: buildbot::slave](manifests/slave.pp)
