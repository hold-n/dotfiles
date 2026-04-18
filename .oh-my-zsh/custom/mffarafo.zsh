alias nnn="nnn -d"
alias ll="ls -lh"
alias ipython=ipython3
alias cloudfs="umount ~/cloud 2> /dev/null; sudo sshfs -o follow_symlinks,auto_cache,reconnect,defer_permissions,noappledouble,nolocalcaches,no_readahead,volname=CloudDesk,uid=$(id -u),gid=$(id -g),allow_other,IdentityFile=$HOME/.ssh/id_rsa glados:/home/mffarafo/ ~/cloud"
alias auth="kinit && mwinit -f"
alias rc-edit="nvim \$ZSH_CUSTOM/mffarafo.zsh"
alias drive-start="launchctl load ~/Library/LaunchAgents/sync.drive.plist"
alias drive-stop="launchctl unload ~/Library/LaunchAgents/sync.drive.plist"
alias bws="brazil workspace"
alias list-inodes="sudo find . -xdev -type f | cut -d "/" -f 2 | sort | uniq -c | sort -n"
alias copy-uuid="python -c \"import uuid; print(str(uuid.uuid4()), end='')\" | pbcopy"
alias bb="brazil-build"
alias bbb="brazil-recursive-cmd --allPackages brazil-build"
alias kiro="kiro-cli"
alias pi='AWS_PROFILE=personal-bedrock AWS_REGION=eu-west-1 pi'

eval "$(/opt/homebrew/bin/brew shellenv)"
. $HOMEBREW_PREFIX/etc/profile.d/z.sh

export EDITOR=nvim
export PATH=$HOME/.toolbox/bin:$PATH
export JAVA_TOOLS_OPTIONS="-Dlog4j2.formatMsgNoLookups=true"
export NVM_DIR="$HOME/.nvm"

. "$HOME/.local/bin/env"
. "$HOME/.atuin/bin/env"

autoload zmv

scp-glados()
{
  DIR=$(pwd | cut -d/ -f5-)
  echo Copying from remote $DIR to current directory
  scp -r $USER@glados:/workplace/$USER/$DIR/ ..
}

add-devdsk()
{
  DIR=$(pwd | cut -d/ -f5-)
  git remote add devdsk ssh://mffarafo@glados.aka.corp.amazon.com/workplace/mffarafo/$DIR
}

html-grep()
{
  hxnormalize -l 240 -x 2>/dev/null | hxselect -s '\n' -c $1
}

in-vs()
{
  brazil vs print --vs "$1" | grep "$2"
}

in-live()
{
  brazil vs print --vs live | grep "$1"
}

# cd on quit for nnn
n ()
{
    # Block nesting of nnn in subshells
    if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"
        return
    fi

    # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
    # To cd on quit only on ^G, remove the "export" as in:
    #     NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    # NOTE: NNN_TMPFILE is fixed, should not be modified
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    nnn "$@"

    if [ -f "$NNN_TMPFILE" ]; then
            . "$NNN_TMPFILE"
            rm -f "$NNN_TMPFILE" > /dev/null
    fi
}

ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

[ -f "$HOME/.local/share/mechanic/complete.zsh" ] && source "$HOME/.local/share/mechanic/complete.zsh"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

eval "$(atuin init zsh)"
eval "$(mise activate zsh)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
