# Testing Packages

Strategies for testing spksrc packages.

## Regression Checks

If the issue being fixed was reported for a previous version, reproduce the
original problem first, then verify the fix resolves it with an appropriate
test case before submitting.

## Build Testing

```bash
# Primary architecture
make -C spk/<package> arch-x64-7.2

# Multiple architectures
make -C spk/<package> arch-x64-7.2 arch-aarch64-7.2 arch-armv7-7.1

# All architectures
make -C spk/<package> all-supported
```

Build at least the primary architecture plus one representative per CPU family
(e.g. x64, aarch64, armv7) — ideally matching what CI runs.

## Package Features

- [ ] Description translations are correct
- [ ] Wizard pages and process work for both install and upgrade
- [ ] Wizard translations are complete

## Service Operation

- [ ] Service starts from Package Center; confirm with `ps`
- [ ] Service stops from Package Center; confirm with `ps`
- [ ] "View log" in Package Center works
- [ ] Log files exist in the package data directory
      (`/var/packages/<package>/var/` on DSM < 7, `/volume1/@appdata/<package>/`
      on DSM 7)
- [ ] DSM shortcut opens the interface
- [ ] Application port is declared in Firewall Services

## Command Line Tools

- [ ] Expected binaries appear in PATH (via `/usr/local/bin` links)
- [ ] Run binaries with version and verbose options (`--version`, `-v`)

## Device Testing

1. Install via Package Center > Manual Install (upload SPK from local computer)
2. Check the package log in the data directory
   (`/var/packages/<pkg>/var/` on DSM < 7, `/volume1/@appdata/<pkg>/` on DSM 7)
3. Verify service starts correctly
4. For a fresh install, confirm the service account is created and config is
   initialized in the package data directory

## Upgrade Testing

1. Install previous version
2. Configure and add data
3. Upgrade to new version
4. Verify data preserved
5. Verify the service account and permissions are unchanged after upgrade

## Uninstall Testing

- [ ] Package removes cleanly from `/var/packages/<package>/`
- [ ] On DSM < 7: service account is removed from `/etc/passwd`
- [ ] On DSM 7: confirm the package data directory is removed when "delete
  data" is selected in the uninstall wizard

!!! note
    On DSM 5/6 the installer explicitly removes the service account
    (`syno_remove_user`). On DSM 7 the account is managed by the DSM package
    framework (via `conf/privilege`) and **persists after uninstall** — the
    installer no longer removes it.

## Checklist Before PR

- [ ] Builds for x64-7.2
- [ ] Builds for aarch64-7.2
- [ ] Installs without errors
- [ ] Service starts automatically
- [ ] Core features work
- [ ] Upgrades from previous version
- [ ] Uninstalls cleanly

## See Also

- [Update Policy and Process](../publishing/update-policy.md) - The testing
  checklist used before publishing, including supported DSM versions
