Contributing
============

You can contribute to spksrc and SynoCommunity in several ways. Apart from reporting bugs, adding suggestions or requesting new packages, you can open Pull Requests to add new packages or to improve existing packages. If you're good at writing, help out with adding and updating documentation. Lastly, donations towards maintaining the SynoCommunity repository infrastructure are much appreciated.
For other suggestions, open an issue so it can be discussed.


Issues
------
If you have questions, suggestions or you believe you have found a bug, we'd like to hear about it. Before you open a new issue, follow the recommendations below.

Do:

* Check the [FAQ](https://github.com/SynoCommunity/spksrc/wiki/Frequently-Asked-Questions);
* Search the [bug tracker](https://github.com/SynoCommunity/spksrc/issues) to see if the issue has not already been reported;
* Check if the package has specific documentation related to it via the [Package Documentation Index](https://github.com/SynoCommunity/spksrc/wiki/Package-Documentation-Index);
* if you're reporting a bug, make sure you include sufficient information. See [Issue Content](https://github.com/SynoCommunity/spksrc/blob/master/CONTRIBUTING.md#issue-content).

Don't:

* Don't ask questions or report bugs in a closed issue;
* Don't post a question in an open issue if your question is not directly related to it. If you're not sure, open a new issue.

Issue content
-------------

When you open a new issue to ask a question about a package, or want to report a bug, be sure to provide as much details as possible for someone else to reproduce what you experienced.

Include at least the following information or use [this link](https://github.com/SynoCommunity/spksrc/issues/new?title=[package]%3A%20Description%20&body=Issue%20description%3A%0AModel%3A%0AArchitecture%3A%0ADSM%20version%3A%0ALog%20file%3A) as a starting point.

Title:

[package name] Short description of question or bug

Content:

* In the issue body, describe what you did, what you expected to happen and what actually happened;
* Model and arch of your NAS. See [Architecture per Synology model](https://github.com/SynoCommunity/spksrc/wiki/Architecture-per-Synology-model);
* DSM version;
* Provide log files if available. Sometimes a log is shown in Package Center for that package. There might be a log available at `/usr/local/{package}/var/`;
* Wrap larger logs between triple backticks (```). Log files over ten lines should be placed on gist.github.com, Pastebin etc., and linked in the issue;
* If the package doesn't start, try to start the package via the command line: `/var/packages/{package}/scripts/start-stop-status start`, and provide the output.


Package Requests
----------------
You can request new packages via a Package Request.

Note that opening a request does not mean it will be honored, so please do not ask for ETA's. SynoCommunity is a community effort where anyone can contribute, even you!
You can show your support with a +1, or by adding a bounty via Bountysource.

Before opening a Package Request, make sure that there are no existing requests for the same software.
As part of your request, some basic information should be included. Contributors use that information as a starting point for packaging. Use the format below, or use the following link to open a request: [New Package Request](https://github.com/SynoCommunity/spksrc/issues/new?title=[request]%20&body=Description%3A%0AWebsite%3A%0ADocumentation%3A%0ABuild%2FInstallation%20documentation%3A%0ASource Code%3A%0ALicense%3A) and fill out the fields.

Title:

[request] Name of software

Content:

* Website: http://www.software.com
* Description: Provide a description of the software
* Documentation: Link to general documentation
* Build/Installation documentation:  Link to build instructions, prerequisites etc.
* Source code: Link to source code
* License: GPL, Apache, etc.


Pull requests
----------
Pull requests to add packages to the [SynoCommunity repository](https://synocommunity.com) are always welcome, as are improvements to the spksrc framework or existing packages.

You'll first need to set up a development environment as outlined in the [README](https://github.com/SynoCommunity/spksrc/blob/master/README.rst#setup-development-environment). After that:
* Fork and clone spksrc: ``git clone https://You@github.com/You/spksrc.git``
* Create a new topic branch: `git checkout -b newfeature master`;
* After completing and testing your changes, submit a pull request.

A general approach on how to develop packages is outlined in the [spksrc example wiki page](https://github.com/SynoCommunity/spksrc/wiki/spksrc-example).
