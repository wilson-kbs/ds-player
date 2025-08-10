#!/usr/bin/env bash
set -euo pipefail

# Open an interactive shell or run a command inside the dev container.
# Usage:
#   bash scripts/dev_shell.sh                # open bash
#   bash scripts/dev_shell.sh npm test       # run a command
#   bash scripts/dev_shell.sh --auto-start   # auto start container if missing

CONTAINER_NAME="KSPlayer-dev"
IMAGE_NAME="ds-player-dev"
AUTO_START=0

if [[ "${1:-}" == "--auto-start" ]]; then
  AUTO_START=1
  shift || true
fi

is_running() {
  docker ps --filter "name=${CONTAINER_NAME}$" --filter status=running --format '{{.Names}}' | grep -qx "${CONTAINER_NAME}" || return 1
}

exists_container() {
  docker ps -a --filter "name=${CONTAINER_NAME}$" --format '{{.Names}}' | grep -qx "${CONTAINER_NAME}" || return 1
}

ensure_running() {
  if is_running; then
    return 0
  fi
  if exists_container; then
    echo "[dev_shell] Starting existing container ${CONTAINER_NAME}..."
    docker start "${CONTAINER_NAME}" >/dev/null
    return 0
  fi
  if [[ ${AUTO_START} -eq 1 ]]; then
    echo "[dev_shell] Container not found. Auto-creating in background..."
    # Build image if needed
    if ! docker image inspect "${IMAGE_NAME}" >/dev/null 2>&1; then
      echo "[dev_shell] Building image ${IMAGE_NAME} (docker/Dockerfile.dev)..."
      docker build -f docker/Dockerfile.dev -t "${IMAGE_NAME}" .
    fi
    # Run detached so this script returns control to the user
    docker run --name "${CONTAINER_NAME}" -d --rm -p "3000:3000" \
      -v "$(pwd):/app" -v "$(pwd)/data:/data" \
      "${IMAGE_NAME}" scripts/start_dev.sh >/dev/null
    echo "[dev_shell] Started ${CONTAINER_NAME}."
    return 0
  fi
  echo "[dev_shell] Dev container not running. In another terminal, run: make dev" >&2
  exit 1
}

ensure_running

# Choose TTY flags based on environment: use -it only if stdout is a TTY
DOCKER_EXEC_FLAGS="-i"
if [ -t 1 ]; then
  DOCKER_EXEC_FLAGS="-it"
fi

if [[ $# -gt 0 ]]; then
  # Run the provided command inside the container
  docker exec ${DOCKER_EXEC_FLAGS} "${CONTAINER_NAME}" "$@"
else
  # Default to interactive bash
  docker exec ${DOCKER_EXEC_FLAGS} "${CONTAINER_NAME}" bash
fi
