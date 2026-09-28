#!/usr/bin/env bash
# Installs common CLI tools on Linux. Supports Debian/Ubuntu, Fedora, Arch.
# Edit TOOLS to add/remove. Failures are skipped and reported at the end.
set -u

TOOLS=(ripgrep fd fzf bat jq yq eza git curl wget htop tmux tree gh git-delta zoxide)

# Per-distro package name overrides: "tool:pkgname"
APT_MAP=(fd:fd-find yq:yq)
DNF_MAP=(fd:fd-find)
PAC_MAP=(yq:go-yq gh:github-cli)

map_name() { # $1=tool, rest=map entries
  local t=$1; shift
  for m in "$@"; do [[ ${m%%:*} == "$t" ]] && { echo "${m#*:}"; return; }; done
  echo "$t"
}

SUDO=""; [[ $EUID -ne 0 ]] && command -v sudo >/dev/null && SUDO=sudo

if command -v apt-get >/dev/null; then
  $SUDO apt-get update -y; PM="$SUDO apt-get install -y"; MAP=("${APT_MAP[@]}")
elif command -v dnf >/dev/null; then
  PM="$SUDO dnf install -y"; MAP=("${DNF_MAP[@]}")
elif command -v pacman >/dev/null; then
  $SUDO pacman -Sy --noconfirm; PM="$SUDO pacman -S --needed --noconfirm"; MAP=("${PAC_MAP[@]}")
else
  echo "Unsupported package manager." >&2; exit 1
fi

failed=()
for t in "${TOOLS[@]}"; do
  pkg=$(map_name "$t" "${MAP[@]+"${MAP[@]}"}")
  echo "==> $pkg"
  $PM "$pkg" || failed+=("$pkg")
done

# Debian/Ubuntu ship fd and bat under different binary names
if command -v apt-get >/dev/null; then
  mkdir -p "$HOME/.local/bin"
  command -v fdfind >/dev/null && ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
  command -v batcat >/dev/null && ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
  echo "Note: ensure ~/.local/bin is on your PATH."
fi

echo
if ((${#failed[@]})); then echo "Failed: ${failed[*]}"; else echo "All installed."; fi
