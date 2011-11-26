SPKSRC
======

*SPKSRC is currently in alpha stage. All dependencies do not work correctly.*

SPKSRC is a cross compilation framework intended to compile and package softwares for the Synology's NAS.

Usage
-----

### Choose your ARCH
You can list all available archs with `ls toolchains`. Remove the prefix `syno-` to have the actual ARCH.

### Build a SPK
You can list all available SPKs with `ls spk`.

* `make ARCH=yourarch yourspk-clean` to clean previous builds
* `make ARCH=yourarch yourspk` to make the SPK
* in your spk directory : `make all-archs` to make the spk for all available archs

Required files for cross-compilation are downloaded in `distrib` directory.
Built SPKs are stored in `packages` directory.


TODO
----

* Add more software
* Do some more clean up in mk/
* Add generic support for DSM integration
* Add support for custom package server upload 
* Add support for download validation (check hash on downloaded files)

Bugs
----
If you find a bug please report it in the [issue tracker][issuetracker] if it has not already been reported. Be sure to provide as much information as possible.

## License
When not explicitly set, files are placed under a [3 clause BSD license][bsd3clause].

[bsd3clause]: http://www.opensource.org/licenses/BSD-3-Clause
[issuetracker]: https://github.com/SynoCommunity/spksrc/issues
