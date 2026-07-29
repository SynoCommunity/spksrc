---
title: Git
description: Distributed version control system
tags:
  - development
  - vcs
---

# Git

Git is a free and open source distributed version control system.

## Package Information

| Property | Value |
|----------|-------|
| Package Name | git |
| Upstream | [git-scm.com](https://git-scm.com/) |
| License | GPL-2.0 |

## Installation

1. Install Git from Package Center
2. Git is added to system PATH

## Configuration

### Basic Setup

```bash
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

### SSH Keys

Generate SSH key for Git hosting:

```bash
ssh-keygen -t ed25519 -C "your@email.com"
cat ~/.ssh/id_ed25519.pub
# Add to GitHub/GitLab/Gitea
```

## Usage

### Clone Repository

```bash
git clone https://github.com/user/repo.git
git clone git@github.com:user/repo.git
```

### Basic Workflow

```bash
# Check status
git status

# Stage changes
git add .

# Commit
git commit -m "Commit message"

# Push
git push
```

### Branches

```bash
# Create branch
git checkout -b feature-branch

# Switch branches
git checkout main

# Merge
git merge feature-branch
```

## Related Packages

- Gitea - Self-hosted Git service (package not currently available)
- [SynoCli Development Tools](synocli-devel.md) - Build tools
