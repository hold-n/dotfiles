A collection of personal config files.

## Setup

This repo includes submodules for third-party pluginsm, so make sure to clone with `--recursive`.

```bash
git clone --recursive https://github.com/hold-n/dotfiles.git ~/dotfiles
~/dotfiles/setup.sh
```

The setup script symlinks all files into `$HOME`, initializes submodules, and backs up any existing files to `~/.dotfiles-backup/`.

## Manual linking

The repo structure mirrors the home directory. You can also link individual files:

```bash
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.config/ghostty ~/.config/ghostty
```
