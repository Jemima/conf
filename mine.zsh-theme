# -*- mode: sh -*-
# Behave differently if we're root or another user (not currently used)
if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="cyan"; fi

function my_pwd() {
    # Given a path like /Users/username/foo/bar/baz/quux
    # we want to format it like ~/.../baz/quux, where quux is bold,
    # and the in between portions are omitted to bring the total length under
    # N characters

    full=$(print -P %~)
    curr=$(print -P %1~)
    if [[ "~" = $full || "/" = $full ]]; then
        # Special case 1: We're in the home or root directory, so just return that char
        echo "%B%~%b"
    elif [[ $curr[0,1] = "/" ]]; then
        # Special case 2: %1~ for /etc returns /etc, while for /etc/bin returns bin,
        # i.e. when in a subfolder of the root, it'll have a leading slash,
        # and then dirname will end with a slash,
        # so just return the basename in bold with a leading slash
        echo "/%B$(basename $curr)%b"
    else
        # Default case, print the dirname then the current directory name in bold
        echo "$(dirname $full)/%B$curr%b"
    fi
}
MODE_INDICATOR="%{$fg_bold[red]%}[N]%{$reset_color%}"

# Use a different colour if the last command failed
local RET_STATUS_COLOUR="%(?:$fg_bold[green]:$fg_bold[red])"
local RET_STATUS="%{$RET_STATUS_COLOUR%} ➤ %{$reset_color%}"
PROMPT='$(my_pwd)$RET_STATUS%'
#PROMPT='%{$fg[$NCOLOR]%}%c ➤ %{$reset_color%}'
RPROMPT='$(vi_mode_prompt_info) %{$fg[magenta]%}$(git_prompt_info)%{$reset_color%} %*'

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}✖%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}✔%{$reset_color%}"

# See http://geoff.greer.fm/lscolors/
export LSCOLORS="gxfxcxdxbxbxbxbxbxbxbx"
export LS_COLORS="di=36;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=31;40:cd=31;40:su=31;40:sg=31;40:tw=31;40:ow=31;40:"

