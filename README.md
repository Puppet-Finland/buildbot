# buildbot

A Puppet module for managing buildbot

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

# Dependencies

See [metadata.json](metadata.json).

# Operating system support

This module has been tested on

* Debian 7
* Ubuntu 12.04
* Ubuntu 14.04
* Ubuntu 16.04
* Fedora 24

Fedora 24 does not have a unit file for starting buildslaves, but you can work 
around that issue by including 
[PuppetFinland/monit](https://github.com/Puppet-Finland/monit):

    classes:
        - monit

It should work with minor modifications on any Debian/Ubuntu derivative. Adding 
support for other *NIX-like operating systems would be slightly more challenging 
due to the way how buildmasters and buildslaves are configured on Debian/Ubuntu.

For details see [params.pp](manifests/params.pp).

