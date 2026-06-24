# Testing Packages

Strategies for testing spksrc packages.

## Build Testing

```bash
# Primary architecture
make -C spk/<package> arch-x64-7.2

# Multiple architectures
make -C spk/<package> arch-x64-7.2 arch-aarch64-7.2 arch-armv7-7.1

# All architectures
make -C spk/<package> all-supported
```

## Device Testing

1. Install via Package Center > Manual Install (upload SPK from local computer)
3. Check `/var/packages/<pkg>/var/*.log`
4. Verify service starts correctly

## Upgrade Testing

1. Install previous version
2. Configure and add data
3. Upgrade to new version
4. Verify data preserved

## Checklist Before PR

- [ ] Builds for x64-7.2
- [ ] Builds for aarch64-7.2
- [ ] Installs without errors
- [ ] Service starts automatically
- [ ] Core features work
- [ ] Upgrades from previous version
