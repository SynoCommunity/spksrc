SPKSRC
=====

*SPKSRC is currently in alpha stage. All dependencies do not work correctly.*

SPKSRC is a cross compilation framework intended to compile sfotware for the Synology's NAS.

## Usage
To build an spk, cd to the corresponding folder in spk/, and type make ARCH=<your arch>. The list of supported architecture is found in toolchains/ (note that the syno- prefix shall not be added). 

Files will be downloaded in distrib, and packages will placed in packages.

## Todo
* Add more software
* Do some more clean up in mk/
* Add generic support for DSM integration
* Add support for custom package server upload 
* Add support for download validation (check hash on downloaded files)

## Bugs
If you find a bug please report it or it'll never get fixed. Verify that it hasn't [already been submitted][googleissues] and then [log a new bug][googlenewissue]. Be sure to provide as much information as possible.

## License
When not explicitly set, files are placed under a [3 clause BSD license][bsd3clause].

[bsd3clause][http://www.opensource.org/licenses/BSD-3-Clause]
