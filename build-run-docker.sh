#!/usr/bin/env bash
# Stop script on docker build failure
OS="$(uname -s)"
docker build -t local-spksrc . || { echo "Erreur: 'docker build' a échoué" >&2; exit 1; }

# Detect the operating system
OS="$(uname -s)"
case "$OS" in
    Linux*)
        docker run -it -v $(pwd):/spksrc -w /spksrc local-spksrc /bin/bash
        ;;
    Darwin*)
        docker run -it -v $(pwd):/spksrc -w /spksrc -e TAR_CMD="fakeroot tar" local-spksrc /bin/bash
        ;;
    *)
        echo "Unsupported OS: $OS"
        exit 1
        ;;
esac
