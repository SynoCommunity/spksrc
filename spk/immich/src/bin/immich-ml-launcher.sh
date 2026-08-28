#!/bin/sh

IMMICH_ML_DIR=/var/packages/immich/target/share/immich/immich-ml
VENV_DIR=/var/packages/immich/target/env-ml
PATH="${VENV_DIR}/bin:${PATH}"

export PYTHONPATH="${IMMICH_ML_DIR}:${PYTHONPATH}"
export IMMICH_HOST=127.0.0.1
export IMMICH_PORT=3003

exec "${VENV_DIR}/bin/python3" -m immich_ml
