---
title: Pull Request Guidelines
description: Requirements and best practices for submitting pull requests
tags:
  - contributing
  - pull-requests
  - code-review
---

# Pull Request Guidelines

This guide covers requirements and best practices for submitting pull requests to SynoCommunity.

## PR Requirements

### Title Format

Use a clear, descriptive title following this pattern:

```
{DISPLAY_NAME}: brief description
```

Use the `DISPLAY_NAME` from the package's `spk/*/Makefile` (e.g., "Transmission", "Python 3.12").

**Good titles:**

- `Transmission: Update to v4.0.5`
- `Python 3.12: Fix armv5 wheel building`
- `docs: add troubleshooting guide`

**Avoid:**

- `Update package` (too vague)
- `Fix bug` (no context)
- `WIP changes` (not ready for review)

### Description

Every PR should include:

1. **What** - Brief summary of changes
2. **Why** - Motivation or issue being fixed
3. **How** - Overview of approach (for complex changes)
4. **Testing** - How you verified the changes work

### PR Template

```markdown
## Description
Brief description of what this PR does.

## Changes
- List specific changes made
- Include file/component names
- Note any breaking changes

## Testing
- Hardware tested on (model, architecture)
- DSM version(s) tested
- Specific functionality verified

## Related Issues
Fixes #123
Related to #456

## Checklist
- [ ] Tested on real hardware
- [ ] Updated changelog
- [ ] Incremented SPK_REV
- [ ] Added/updated documentation
```

## Types of PRs

### Version Updates

For updating existing packages:

**Required:**

- Update `PKG_VERS` to new version
- Update `PKG_DIST_NAME` if changed
- Regenerate checksums (`make digests`)
- Increment `SPK_REV`
- Add changelog entry

**Example description:**

```markdown
## Description
Updates Transmission to version 4.0.5.

## Changes
- Updated PKG_VERS to 4.0.5
- Updated checksums
- Incremented SPK_REV

## Upstream Changes
- Fixed security vulnerability CVE-2024-XXXXX
- Added support for BitTorrent v2
- See: https://github.com/transmission/transmission/releases/tag/4.0.5
```

### New Packages

For adding new packages:

**Required:**

- Complete package structure
- Working build for at least one architecture
- Basic service configuration
- Package description and icon

**Recommended:**

- Multi-architecture support
- Installation wizard if configuration needed
- Documentation

**Example description:**

```markdown
## Description
Adds MyApp package - a self-hosted application for X.

## Features
- Web interface on port 8080
- Automatic startup as service
- Data stored in shared folder

## Architecture Support
- x64: Tested ✓
- aarch64: Tested ✓
- armv7: Untested (should work)
- armv5: UNSUPPORTED_ARCHS (requires ARMv7+)

## Testing
- DS920+ (x64) DSM 7.2.1
- DS223 (aarch64) DSM 7.2.1
```

### Bug Fixes

For fixing issues:

**Required:**

- Clear description of the bug
- Explanation of the fix
- Verification that the fix works

**Example description:**

```markdown
## Description
Fixes installation failure on armv5 devices.

## Problem
Package failed to install on DS414slim (armv5) with error:
`Library not found: libfoo.so.1`

## Solution
The LDFLAGS were missing the library path for cross-compiled
dependencies. Added explicit `-L${INSTALL_DIR}/lib` to LDFLAGS.

## Testing
- Reproduced failure on armv5 emulator
- Verified fix on DS414slim DSM 6.2.4
- Tested on x64 to ensure no regression

Fixes #1234
```

## Review Process

### What Reviewers Check

1. **Correctness** - Does the change work as intended?
2. **Completeness** - Are all necessary files included?
3. **Style** - Does it follow existing patterns?
4. **Testing** - Has it been adequately tested?
5. **Documentation** - Are changes documented?

### Common Review Feedback

**Build configuration:**

- Missing `UNSUPPORTED_ARCHS` for incompatible architectures
- Incorrect dependency declarations
- Missing checksums

**Service configuration:**

- Incorrect user/group permissions
- Missing DSM version compatibility
- Port conflicts

**Code quality:**

- Shell script syntax issues
- Inconsistent formatting
- Missing error handling

### Responding to Feedback

- Address all comments before requesting re-review
- If you disagree, explain your reasoning politely
- Ask questions if feedback is unclear
- Mark resolved comments as resolved

## CI/CD Checks

### Automatic Checks

PRs trigger automatic builds:

- **Build Status** - Compiles successfully for all architectures
- **Artifact Upload** - SPK files available for testing

### What to Do When CI Fails

1. Click on the failed check to see logs
2. Find the error message in the build output
3. Common issues:
   - Missing dependency
   - Download URL changed
   - Architecture-specific compilation error
4. Push fixes to your branch (PR updates automatically)

## Merge Policy

### Requirements for Merge

- At least one maintainer approval
- All CI checks passing
- No unresolved review comments
- No merge conflicts

### After Merge

- CI builds and publishes packages
- Packages appear in Package Center within ~1-2 hours
- Branch can be deleted (GitHub offers auto-delete)

## Best Practices

## Squashing Commits

Maintainers may request that you squash your commits before merging to keep the git history clean.

### How to Squash

1. Check how many commits to squash:
   ```bash
   git log --oneline
   ```

2. Soft reset to combine commits (e.g., last 5):
   ```bash
   git reset --soft HEAD~5
   ```

3. Create a single commit:
   ```bash
   git commit -m "package: description of changes"
   ```

4. Force push to update your PR branch:
   ```bash
   git push --force
   ```

!!! warning
    Only force push to your own feature branches, never to shared branches like `master`.

### Do

- Keep PRs focused on a single package/change
- Test on real hardware when possible
- Respond promptly to review feedback
- Update your branch from master if it gets stale

### Don't

- Submit untested changes
- Mix unrelated changes in one PR
- Force push after review has started
- Ignore CI failures

## See Also

- [Development Process](development-process.md)
- [Contributing Overview](index.md)
- [GitHub Actions CI/CD](../developer-guide/publishing/github-actions.md)
