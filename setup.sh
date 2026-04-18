#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"
SKIP_PATTERNS=('.git' '.gitmodules' 'README.md' 'setup.sh' 'Brewfile')

should_skip() {
  local name="$1"
  for pattern in "${SKIP_PATTERNS[@]}"; do
    [[ "$name" == "$pattern" ]] && return 0
  done
  return 1
}

backup_and_link() {
  local src="$1" dest="$2"

  if [[ -e "$dest" || -L "$dest" ]]; then
    if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
      echo "  skip (already linked): $dest"
      return
    fi
    mkdir -p "$BACKUP_DIR"
    mv "$dest" "$BACKUP_DIR/"
    echo "  backed up: $dest -> $BACKUP_DIR/"
  fi

  mkdir -p "$(dirname "$dest")"
  ln -s "$src" "$dest"
  echo "  linked: $dest -> $src"
}

is_submodule() {
  local path="$1"
  git -C "$DOTFILES_DIR" submodule status "$path" &>/dev/null
}

link_recursive() {
  local rel_dir="$1"
  local src_dir="$DOTFILES_DIR/$rel_dir"

  for entry in "$src_dir"/*  "$src_dir"/.*; do
    local name="$(basename "$entry")"
    [[ "$name" == "." || "$name" == ".." ]] && continue

    local rel_path="${rel_dir:+$rel_dir/}$name"
    should_skip "$name" && continue

    local dest="$HOME/$rel_path"

    if [[ -d "$entry" ]] && ! is_submodule "$rel_path"; then
      link_recursive "$rel_path"
    else
      backup_and_link "$entry" "$dest"
    fi
  done
}

echo "Setting up dotfiles from $DOTFILES_DIR"
echo

git -C "$DOTFILES_DIR" submodule update --init --recursive

link_recursive ""

echo
if [[ -d "$BACKUP_DIR" ]]; then
  echo "Existing files backed up to $BACKUP_DIR"
fi
echo "Done!"
