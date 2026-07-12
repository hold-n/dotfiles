A collection of personal config files.

## Prerequisites

These dotfiles assume certain tools are already installed. The setup script only creates symlinks — it does not install any packages.

### Required

- **zsh** + **[Oh My Zsh](https://ohmyz.sh/)** — install Oh My Zsh *before* running `setup.sh`, otherwise the partial `~/.oh-my-zsh/custom/` directory it creates will cause the Oh My Zsh installer to refuse later
- **git**
- **[Neovim](https://neovim.io/) ≥ 0.10** — the config uses `nvim-treesitter` main branch APIs (`vim.fs.joinpath`, etc.) that aren't available in 0.9.x. Ubuntu/Debian repos ship 0.9.x; install from [GitHub releases](https://github.com/neovim/neovim/releases) or the Neovim PPA instead
- **C compiler** (gcc/clang) — needed by treesitter to compile parsers

### Recommended (from Brewfile)

On macOS, `brew bundle` installs everything. On Linux, install the equivalents manually:

- **bat** — aliased as `cat` in the shell config. On Ubuntu it's packaged as `batcat`; symlink it: `sudo ln -s /usr/bin/batcat /usr/local/bin/bat`
- **fd** — on Ubuntu it's `fdfind`; symlink: `sudo ln -s /usr/bin/fdfind /usr/local/bin/fd`
- **fzf** — also auto-installed by vim-plug into `~/.fzf` on first `PlugInstall`
- **ripgrep** (`rg`)
- **tree-sitter CLI** — needed for treesitter parser compilation. Included in Brewfile as `tree-sitter-cli`; on Linux grab the binary from [releases](https://github.com/tree-sitter/tree-sitter/releases)
- **hunk** — used as the git pager (`core.pager = hunk pager` in `.gitconfig`). If missing, git silently falls back to `less`
- **gh** (GitHub CLI) — used for git credential helpers in `.gitconfig`
- **mise**, **tmux**, **jq**, **htop**, **nnn**, **ranger**, **wget**, **tree**

See the full list in [`Brewfile`](Brewfile).

## Setup

```bash
# 1. Install Oh My Zsh (if not already present)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 2. Clone (submodules are initialized by the setup script)
git clone https://github.com/hold-n/dotfiles.git ~/dotfiles

# 3. Run setup — symlinks everything into $HOME
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

- **`.gitconfig`** includes `~/.gitconfig-local` for machine-specific overrides (missing file is silently ignored)
- **`.zshrc`** sets `ZSH_CUSTOM` to `~/dotfiles/.oh-my-zsh/custom` so plugins/themes are loaded from the repo, not from Oh My Zsh's own custom dir
- **macOS-specific configs** (Karabiner, Ghostty, Homebrew) are harmlessly symlinked on Linux — they just won't be used
