# buildbot

A Puppet module for managing buildbot

# Module usage

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

It should work with minor modifications on any Debian/Ubuntu derivative. Adding 
support for other *NIX-like operating systems would be slightly more challenging 
due to the way how buildmasters and buildslaves are configured on Debian/Ubuntu.

For details see [params.pp](manifests/params.pp).

