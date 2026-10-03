# Dantami Repo Sync

Targets DSM 7.1+ on x64 NAS devices. Open the app from DSM over HTTPS and
sign in with the independent administrator created in the installation wizard.
Configure providers and repository pairs in the app. New pairs are disabled
until explicitly enabled. Synchronization never force-pushes, merges divergent
history or propagates deletions. Git LFS objects, issues, pull requests, release
assets and submodule contents are not synchronized.

The UI uses DSM CGI and a private Unix socket, without an additional public TCP
port. Account data and tokens remain in the package private var directory.
DSM administrator authentication is not used.

## Existing manual package

The upstream manual SPK has ID `DantamiRepoSync`. This community package uses
`dantami-repo-sync` following repository conventions. It is a separate install,
not an in-place upgrade; existing configuration is not imported automatically.
Keep the existing installation until the new package is verified. Stop its
synchronization before enabling the same pairs here. Never run both packages
against the same repository pairs. This recipe removes no existing package
or user data.

## Testing

Build with `make arch-x64-7.2`. The source Go minimum is patched to 1.26 for
spksrc native/go; the package-name patch isolates paths from the manual SPK.
Actual NAS install, upgrade, DSM CGI execution and reboot persistence still
require hardware validation before production publication.

Upstream source and user guide:
https://github.com/momopanda123/dantami-repo-sync
