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

Title:

[package name] Short description of question or bug

Content:

* Describe what you did, what you expected to happen and what actually happened;
* Which steps to perform to reproduce what happened;
* Model, arch and DSM version of your NAS. See [Architecture per Synology model](https://github.com/SynoCommunity/spksrc/wiki/Architecture-per-Synology-model);
* Provide log files if available. Sometimes a log is shown in Package Center for that package. There might be a log available at `/usr/local/{package}/var/`;
* Wrap larger logs between triple backticks (```). Log files over ten lines should be placed on gist.github.com, Pastebin etc., and linked in the issue;
* If the package doesn't start, try to start the package [via the command line](https://github.com/SynoCommunity/spksrc/wiki/Frequently-Asked-Questions#how-to-query-package-status-or-start-from-command-line)  and provide the output.


Package Requests
----------------
You can request new packages via a Package Request.

Note that opening a request does not mean it will be honored, so please do not ask for ETA's. SynoCommunity is a community effort where anyone can contribute, even you!
You can show your support with a +1, or by adding a bounty via Bountysource.

Before opening a Package Request, make sure that there are no existing requests for the same software.
As part of your request, some basic information should be included. Contributors use that information as a starting point for packaging. Use the format as shown below or use the following link: [Package Request](https://github.com/SynoCommunity/spksrc/issues/new?title=[Package%20Request]%20&body=Name%3A%0ADescription%3A%0AWebsite%3A%0ASoftware%20documentation%3A%0ABuild%2FInstallation%20documentation%3A%0ASource%20Code%3A%0ALicense%3A)

Title:

[Package Request] Name of software

Content:
* Name: Software name
* Description: Provide a short description of the software
* Website: http://www.software.com
* Software documentation: Link to general documentation, usage
* Build/Installation documentation: Link to build instructions, prerequisites etc.
* Source code: Link to source code
* License: GPL, Apache, etc., or link to license (e.g. LICENSE or COPYING)


Pull requests
----------
Pull requests to add packages to the [SynoCommunity repository](https://synocommunity.com) are always welcome, as are improvements to the spksrc framework or existing packages.

Once you have a development environment set up, you can start building packages, create new ones, or improve upon existing packages while making your changes available to other people. See the [Developers HOW-TO](https://github.com/SynoCommunity/spksrc/wiki/Developers-HOW-TO) for information on how to use spksrc.
