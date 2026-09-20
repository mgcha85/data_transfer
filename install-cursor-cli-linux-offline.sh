#!/usr/bin/env bash
# Offline install for Cursor CLI (agent) on Linux x64.
# Run on a machine with no internet after copying this repo.
set -euo pipefail

VERSION="2026.09.18-9a7762b"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ARCHIVE="${SCRIPT_DIR}/cursor-cli-linux-x64-${VERSION}.tar.gz"

if [ ! -f "${ARCHIVE}" ]; then
  echo "Missing package: ${ARCHIVE}" >&2
  exit 1
fi

OS="$(uname -s)"
ARCH="$(uname -m)"
case "${OS}" in
  Linux) ;;
  *)
    echo "This package is for Linux. Detected: ${OS}" >&2
    exit 1
    ;;
esac
case "${ARCH}" in
  x86_64|amd64) ;;
  *)
    echo "This package is linux/x64. Detected: ${ARCH}" >&2
    exit 1
    ;;
esac

SHARE_DIR="${HOME}/.local/share/cursor-agent/versions"
FINAL_DIR="${SHARE_DIR}/${VERSION}"
TEMP_DIR="${SHARE_DIR}/.tmp-${VERSION}-$$"

echo "Installing Cursor CLI ${VERSION} (linux/x64) offline..."
mkdir -p "${TEMP_DIR}" "${HOME}/.local/bin"

tar --strip-components=1 -xzf "${ARCHIVE}" -C "${TEMP_DIR}"
rm -rf "${FINAL_DIR}"
mv "${TEMP_DIR}" "${FINAL_DIR}"

rm -f "${HOME}/.local/bin/agent" "${HOME}/.local/bin/cursor-agent"
ln -s "${FINAL_DIR}/cursor-agent" "${HOME}/.local/bin/agent"
ln -s "${FINAL_DIR}/cursor-agent" "${HOME}/.local/bin/cursor-agent"

chmod +x "${FINAL_DIR}/cursor-agent" "${FINAL_DIR}/cursor-agent-sea" "${FINAL_DIR}/cursor-agent-worker-sea" 2>/dev/null || true

PATH_LINE='export PATH="$HOME/.local/bin:$PATH"'
ensure_path_file() {
  local file="$1"
  [ -f "${file}" ] || touch "${file}"
  if ! grep -qF '.local/bin' "${file}" 2>/dev/null; then
    printf '\n# Cursor CLI (agent)\n%s\n' "${PATH_LINE}" >> "${file}"
    echo "Added ~/.local/bin to PATH in ${file}"
  fi
}

ensure_path_file "${HOME}/.bashrc"
[ -f "${HOME}/.zshrc" ] && ensure_path_file "${HOME}/.zshrc"

export PATH="${HOME}/.local/bin:${PATH}"

echo "Installed:"
"${HOME}/.local/bin/agent" --version || true
echo
echo "This shell can run: agent"
echo "New shells pick up PATH from ~/.bashrc (or ~/.zshrc)."
echo "If agent is missing in a new terminal: source ~/.bashrc"
echo
echo "Note: first use still needs Cursor login when network is available."
echo "Auto-update needs network; skip or ignore update failures while offline."
