# Publishing Packages

How to publish packages to SynoCommunity.

- [GitHub Actions](github-actions.md) - Automated builds and CI/CD
- [Manual Publishing](manual-publishing.md) - Building and publishing without CI
- [Repository Activation](repository-activation.md) - Activating published packages
- [Update Policy](update-policy.md) - Supported versions and testing checklist
- [Package Server](package-server.md) - Running your own repo

## Process

1. Fork the spksrc repository
2. Create branch for changes
3. Add/update package
4. Test on multiple architectures
5. Submit pull request
6. After merge, CI publishes automatically
7. Activate packages via [repository admin](repository-activation.md)
