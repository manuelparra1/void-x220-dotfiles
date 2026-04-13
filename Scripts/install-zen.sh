#!/bin/bash
# install-zen.sh — Install or update Zen Browser (portable) on Void Linux
# Uses the GitHub "latest" release redirect; no hardcoded version.
set -euo pipefail

# ── Config ────────────────────────────────────────────────────────────────────
APPS_DIR="${HOME}/Applications"
INSTALL_DIR="${APPS_DIR}/zen"
DOWNLOAD_URL="https://github.com/zen-browser/desktop/releases/latest/download/zen.linux-x86_64.tar.xz"
DESKTOP_DIR="${HOME}/.local/share/applications"
DESKTOP_FILE="${DESKTOP_DIR}/zen.desktop"
BIN_DIR="${HOME}/.bin"
BIN_LINK="${BIN_DIR}/zen"
VERSION_FILE="${INSTALL_DIR}/.installed_version"
FORCE=false

# ── Args ──────────────────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    -f|--force) FORCE=true ;;
    -h|--help)
      echo "Usage: $(basename "$0") [-f|--force]"
      echo "  -f, --force   Re-download and reinstall even if already up to date"
      exit 0
      ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
  shift
done

# ── Helpers ───────────────────────────────────────────────────────────────────
die()  { echo "✗ $*" >&2; exit 1; }
info() { echo "→ $*"; }
ok()   { echo "✓ $*"; }

# ── Resolve latest version via redirect ───────────────────────────────────────
# GitHub redirects /releases/latest/download/... to the actual versioned path.
# We follow that redirect silently and extract the version from the final URL.
info "Resolving latest version..."

RESOLVED_URL=$(curl -fsSL \
  -A "Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0" \
  -w "%{url_effective}" \
  -o /dev/null \
  "$DOWNLOAD_URL")

# URL looks like: .../releases/download/1.8.1b/zen.linux-x86_64.tar.xz
LATEST_VERSION=$(echo "$RESOLVED_URL" \
  | grep -oE '/releases/download/[^/]+/' \
  | grep -oE '[^/]+' \
  | tail -1)

[[ -n "$LATEST_VERSION" ]] \
  || die "Could not determine version from resolved URL: ${RESOLVED_URL}"

info "Latest version: ${LATEST_VERSION}"

# ── Check installed version ───────────────────────────────────────────────────
if [[ -f "$VERSION_FILE" ]]; then
  INSTALLED_VERSION=$(cat "$VERSION_FILE")
  if [[ "$INSTALLED_VERSION" == "$LATEST_VERSION" ]] && [[ "$FORCE" == false ]]; then
    ok "Already up to date (${LATEST_VERSION}). Use -f to force reinstall."
    exit 0
  fi
  info "Upgrading: ${INSTALLED_VERSION} → ${LATEST_VERSION}"
else
  info "No existing installation found; performing fresh install."
fi

# ── Download ──────────────────────────────────────────────────────────────────
TMP_DIR=$(mktemp -d /tmp/zen-install-XXXXXX)
trap 'rm -rf "$TMP_DIR"' EXIT

TARBALL="${TMP_DIR}/zen.linux-x86_64.tar.xz"

info "Downloading Zen Browser ${LATEST_VERSION}..."
curl -L --progress-bar \
  -A "Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0" \
  "$DOWNLOAD_URL" \
  -o "$TARBALL" \
  || die "Download failed."

# ── Extract ───────────────────────────────────────────────────────────────────
info "Extracting..."
tar -xJf "$TARBALL" -C "$TMP_DIR" \
  || die "Extraction failed."

# Tarball always extracts to a top-level zen/ directory
EXTRACTED_DIR="${TMP_DIR}/zen"
[[ -d "$EXTRACTED_DIR" ]] || die "Expected extracted directory 'zen/' not found — tarball structure may have changed."

# ── Install ───────────────────────────────────────────────────────────────────
info "Installing to ${INSTALL_DIR}..."
rm -rf "$INSTALL_DIR"
mv "$EXTRACTED_DIR" "$INSTALL_DIR"

# Make sure the binary is executable
chmod +x "${INSTALL_DIR}/zen"

# ── Write version stamp ───────────────────────────────────────────────────────
echo "$LATEST_VERSION" > "$VERSION_FILE"

# ── Symlink into ~/.bin/ for PATH/CLI access ──────────────────────────────────
info "Linking binary → ${BIN_LINK}..."
mkdir -p "$BIN_DIR"
ln -sf "${INSTALL_DIR}/zen" "$BIN_LINK"

# ── Resolve icon path ─────────────────────────────────────────────────────────
# Zen (Firefox-based) ships icons under browser/chrome/icons/default/
# Fall back to a lower resolution if 128px isn't present.
ICON_PATH=""
for candidate in \
  "${INSTALL_DIR}/browser/chrome/icons/default/default128.png" \
  "${INSTALL_DIR}/browser/chrome/icons/default/default64.png" \
  "${INSTALL_DIR}/browser/chrome/icons/default/default48.png"
do
  if [[ -f "$candidate" ]]; then
    ICON_PATH="$candidate"
    break
  fi
done

# Last resort: use the app name and let the system icon theme handle it
[[ -n "$ICON_PATH" ]] || ICON_PATH="zen"

# ── Write .desktop entry ──────────────────────────────────────────────────────
info "Writing .desktop entry → ${DESKTOP_FILE}..."
mkdir -p "$DESKTOP_DIR"

cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Zen Browser
GenericName=Web Browser
Comment=Experience tranquil browsing with Zen Browser
Exec=${INSTALL_DIR}/zen %u
Icon=${ICON_PATH}
Terminal=false
StartupNotify=true
StartupWMClass=zen-alpha
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;application/xml;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/ftp;
Keywords=browser;web;internet;
EOF

chmod +x "$DESKTOP_FILE"

# Refresh desktop database so rofi picks up the new entry immediately
if command -v update-desktop-database &>/dev/null; then
  update-desktop-database "$DESKTOP_DIR" 2>/dev/null || true
fi

# ── Done ──────────────────────────────────────────────────────────────────────
ok "Zen Browser ${LATEST_VERSION} installed → ${INSTALL_DIR}"
ok "Symlink → ${BIN_LINK}"
ok ".desktop entry → ${DESKTOP_FILE}"
ok "Icon → ${ICON_PATH}"
