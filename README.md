A collection of personal config files.

## Prerequisites

The setup script only creates symlinks — it does not install any packages.

### Required

- **zsh** + **[Oh My Zsh](https://ohmyz.sh/)**
- **git**
- **[Neovim](https://neovim.io/) ≥ 0.10** — the config uses `nvim-treesitter` main branch which requires APIs added in 0.10 (`vim.fs.joinpath`, etc.). Ubuntu/Debian repos ship 0.9.x; install from [GitHub releases](https://github.com/neovim/neovim/releases) or the Neovim PPA instead
- **C compiler** (gcc/clang) — needed by treesitter to compile parsers

### Recommended (from Brewfile)

On macOS, `brew bundle` installs everything. On Linux, install the equivalents manually:

- **bat** — aliased as `cat` in the shell config. On Ubuntu it's packaged as `batcat`; symlink it: `sudo ln -s /usr/bin/batcat /usr/local/bin/bat`
- **fd** — on Ubuntu it's `fdfind`; symlink: `sudo ln -s /usr/bin/fdfind /usr/local/bin/fd`
- **fzf** — also auto-installed by vim-plug into `~/.fzf` on first `PlugInstall`
- **ripgrep** (`rg`)
- **tree-sitter CLI** — needed for treesitter parser compilation. On Linux, grab the binary from [releases](https://github.com/tree-sitter/tree-sitter/releases)
- **hunk** — used as the git pager (`core.pager` in `.gitconfig`). If missing, git falls back to `less`
- **gh** (GitHub CLI) — used for git credential helpers in `.gitconfig`
- **mise**, **tmux**, **jq**, **htop**, **nnn**, **ranger**, **wget**, **tree**

See the full list in [`Brewfile`](Brewfile).

## Setup

The repo can be cloned anywhere — `.zshrc` resolves the path to `ZSH_CUSTOM` from its own symlink target.

```bash
# 1. Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 2. Clone (~/dotfiles is conventional but not required)
git clone https://github.com/hold-n/dotfiles.git ~/dotfiles

# 3. Symlink everything into $HOME
~/dotfiles/setup.sh

# 4. Install Neovim plugins
nvim --headless +'PlugInstall --sync' +qa
```

The setup script:
- Initializes git submodules (powerlevel10k, fast-syntax-highlighting, zsh-vim-mode)
- Recursively symlinks all files into `$HOME`, mirroring the repo structure
- Backs up any existing files to `~/.dotfiles-backup/<timestamp>/`
- Is idempotent — re-running skips already-correct symlinks

## Manual linking

The repo structure mirrors the home directory. You can also link individual files:

```bash
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.config/ghostty ~/.config/ghostty
```

## Notes

- **`.gitconfig`** includes `~/.gitconfig-local` for machine-specific overrides (missing file is silently ignored by git)
- **`.zshrc`** resolves its own symlink to find the repo and sets `ZSH_CUSTOM` to `<repo>/.oh-my-zsh/custom`, so custom plugins and themes are loaded from the repo rather than from Oh My Zsh's own custom directory. The repo can live anywhere
- **macOS-specific configs** (Karabiner, Ghostty, Homebrew) are harmlessly symlinked on Linux — they just won't be used
