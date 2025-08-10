#!/usr/bin/env bash
set -euo pipefail

# yt-dlp installer script based on CPU architecture (x86_64/aarch64/armv7l)
# Usage:
#   ./scripts/install_yt_dlp.sh [DEST_DIR]
# - DEST_DIR (optional): installation directory (defaults to /usr/local/bin if writable, otherwise ./bin)
# - Env vars:
#     YT_DLP_VERSION=latest  # or a specific version, e.g., 2025.01.01
#
# This script downloads the static binary from yt-dlp GitHub releases.

YT_DLP_VERSION="${YT_DLP_VERSION:-latest}"
REQUESTED_DEST_DIR="${1:-}" # optional argument
DEFAULT_DEST_DIR="/usr/local/bin"
FALLBACK_DEST_DIR="$(pwd)/bin"

arch="$(uname -m)"
case "$arch" in
  x86_64|amd64)
    asset="yt-dlp" # Linux x86_64 binary is usually named 'yt-dlp'
    ;;
  aarch64|arm64)
    asset="yt-dlp_linux_aarch64"
    ;;
  armv7l)
    asset="yt-dlp_linux_armv7l"
    ;;
  *)
    echo "[ERROR] Unsupported architecture: $arch" >&2
    echo "Supported architectures: x86_64, aarch64, armv7l" >&2
    exit 1
    ;;
 esac

base_url="https://github.com/yt-dlp/yt-dlp/releases"
if [[ "$YT_DLP_VERSION" == "latest" ]]; then
  url="$base_url/latest/download/$asset"
else
  url="$base_url/download/$YT_DLP_VERSION/$asset"
fi

# Determine destination directory
choose_dest_dir() {
  local preferred="$1"
  if [[ -n "$preferred" ]]; then
    echo "$preferred"
    return 0
  fi
  # if /usr/local/bin is writable
  if [[ -d "$DEFAULT_DEST_DIR" && -w "$DEFAULT_DEST_DIR" ]]; then
    echo "$DEFAULT_DEST_DIR"
  else
    echo "$FALLBACK_DEST_DIR"
  fi
}

DEST_DIR="$(choose_dest_dir "$REQUESTED_DEST_DIR")"
mkdir -p "$DEST_DIR"
outfile="$DEST_DIR/yt-dlp"

echo "[INFO] Detected architecture: $arch"
echo "[INFO] Downloading from: $url"

tmpfile="$(mktemp)"
cleanup() { rm -f "$tmpfile" 2>/dev/null || true; }
trap cleanup EXIT

# Download
if command -v curl >/dev/null 2>&1; then
  curl -L --fail -o "$tmpfile" "$url"
elif command -v wget >/dev/null 2>&1; then
  wget -O "$tmpfile" "$url"
else
  echo "[ERROR] curl or wget is required to download yt-dlp." >&2
  exit 1
fi

# Install
mv "$tmpfile" "$outfile"
chmod +x "$outfile"

# Verification
if "$outfile" --version >/dev/null 2>&1; then
  echo "[SUCCESS] yt-dlp installed at: $outfile"
  "$outfile" --version
else
  echo "[WARNING] Installation finished but execution failed. Please check your system." >&2
fi

# Usage notes
if [[ "$DEST_DIR" == "$FALLBACK_DEST_DIR" ]]; then
  echo "[NOTE] Add $DEST_DIR to your PATH to use 'yt-dlp' globally."
  echo "       Example: export PATH=\"$DEST_DIR:$PATH\""
fi
