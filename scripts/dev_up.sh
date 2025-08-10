#!/usr/bin/env bash
set -euo pipefail

# Ensure the dev container is up (detached) and healthy.
# Usage:
#   bash scripts/dev_up.sh             # build (if needed) and start detached
#   bash scripts/dev_up.sh --recreate  # remove existing and recreate

CONTAINER_NAME="KSPlayer-dev"
IMAGE_NAME="ds-player-dev"
RECREATE=0

if [[ "${1:-}" == "--recreate" ]]; then
  RECREATE=1
fi

exists_container() {
  docker ps -a --filter "name=${CONTAINER_NAME}$" --format '{{.Names}}' | grep -qx "${CONTAINER_NAME}" || return 1
}

is_running() {
  docker ps --filter "name=${CONTAINER_NAME}$" --filter status=running --format '{{.Names}}' | grep -qx "${CONTAINER_NAME}" || return 1
}

echo "[dev_up] Checking image ${IMAGE_NAME}..."
if ! docker image inspect "${IMAGE_NAME}" >/dev/null 2>&1; then
  echo "[dev_up] Building ${IMAGE_NAME} from docker/Dockerfile.dev..."
  docker build -f docker/Dockerfile.dev -t "${IMAGE_NAME}" .
fi

if [[ ${RECREATE} -eq 1 ]] && exists_container; then
  echo "[dev_up] Removing existing container ${CONTAINER_NAME}..."
  docker rm -f "${CONTAINER_NAME}" >/dev/null || true
fi

if is_running; then
  echo "[dev_up] Container ${CONTAINER_NAME} is already running."
  exit 0
fi

if exists_container; then
  echo "[dev_up] Starting existing container ${CONTAINER_NAME}..."
  docker start "${CONTAINER_NAME}" >/dev/null
else
  echo "[dev_up] Creating and starting ${CONTAINER_NAME} (detached)..."
  docker run --name "${CONTAINER_NAME}" -d --rm -p "3000:3000" \
    -v "$(pwd):/app" -v "$(pwd)/data:/data" \
    "${IMAGE_NAME}" scripts/start_dev.sh >/dev/null
fi

echo "[dev_up] ${CONTAINER_NAME} is running. Attach with: bash scripts/dev_shell.sh"

