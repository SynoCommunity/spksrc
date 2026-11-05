# Dantami Repo Sync

Targets DSM 7.1+ on x64 NAS devices. Open the app from DSM over HTTPS and
sign in with the independent administrator created on initial installation.
Configure providers and repository pairs in the app. New pairs are disabled
until explicitly enabled. Synchronization never force-pushes, merges divergent
history or propagates deletions. Git LFS objects, issues, pull requests, release
assets and submodule contents are not synchronized.

The UI uses DSM CGI and a private Unix socket, without an additional public TCP
port. Account data and tokens remain in the package private var directory.
DSM administrator authentication is not used.

## Package identity and upgrades

This package retains the upstream ID `DantamiRepoSync`, application ID and data
path. The lowercase name is only the spksrc recipe directory and source name.
The earlier draft with ID `dantami-repo-sync` was never published as a community
release; its data is not imported automatically.

Upgrades do not initialize or reset app accounts. The generic spksrc service
installer manages the foreground daemon with SVC_BACKGROUND=yes and the PID
file written by the app. No custom start-stop-status script is used.

Keeping the package ID does not establish cross-distribution upgrade safety.
The manual SPK and spksrc recipe have different package-user metadata; account
ownership, private data access and DSM CGI execution during a manual-to-community
upgrade require actual NAS validation. Back up app data before testing such an
upgrade. Do not uninstall a working package or run duplicate synchronization
instances as a migration shortcut.

## Testing

Build with `make arch-x64-7.2`. Upstream declares Go 1.26.0 as its minimum;
spksrc native/go 1.26.8 builds the source without packaging patches.
Actual NAS install, upgrade, DSM CGI execution and reboot persistence still
require hardware validation before production publication.

Upstream source and user guide:
https://github.com/momopanda123/dantami-repo-sync
