# Homebrew (Apple Silicon) — must come first so brew-installed binaries
# are on PATH for everything below (starship, atuin, carapace, etc.)
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

# Synchronous compinit so external completion sources (carapace, zoxide,
# atuin, pay-respects) can call `compdef` at source time. The zinit turbo
# block below also runs `zicompinit` to pick up plugin-added fpath entries —
# both passes use -C (skip security check) to keep the cost low.
ZINIT[COMPINIT_OPTS]=-C
autoload -Uz compinit
compinit -C

# Turbo plugin block — deferred ~5ms after first prompt (lucid = silent).
# Order is meaningful:
#   1. zsh-completions   — blockf prevents fpath pollution; creinstall registers
#   2. autosuggestions   — atload triggers its precmd hook (! escapes quoting)
#   3. fast-syntax-highlighting — MUST be last; atinit runs zicompinit + zicdreplay
#                                 so plugin completions get registered after the
#                                 sync compinit above.
# Pattern from official wiki:
#   https://zdharma-continuum.github.io/zinit/wiki/Example-Minimal-Setup/
zinit wait lucid light-mode for \
    blockf atpull'zinit creinstall -q .' \
        zsh-users/zsh-completions \
    atload"!_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions \
    atinit"zicompinit; zicdreplay" \
        zdharma-continuum/fast-syntax-highlighting

# OMZ snippets (also turbo)
zinit wait lucid for \
    OMZP::git \
    OMZP::sudo

# History — atuin handles search via Ctrl-R; this only governs the
# native zsh history file that atuin can fall back on.
HISTSIZE=50000
HISTFILE=~/.zhistory
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt sharehistory          # also implies append behavior
setopt hist_ignore_space
setopt hist_ignore_all_dups  # subsumes hist_ignore_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

# Shell ergonomics
setopt extended_glob          # enables ^ ~ # in glob patterns (e.g. ls ^*.tmp)
setopt interactive_comments   # allow `# foo` comments in interactive shells
unsetopt beep                 # stop the terminal bell on every error

# Word boundaries — default WORDCHARS includes /,.- so Ctrl-W deletes the
# whole path. Empty WORDCHARS makes word ops stop at non-alphanumerics,
# so Ctrl-W deletes just the last path component.
WORDCHARS=''

# Aliases and custom keybinds
source "$HOME/.aliases"
source "$HOME/.keybinds"

# Private env vars (API keys, tokens). chmod 600 ~/.secrets
[[ -f "$HOME/.secrets" ]] && source "$HOME/.secrets"

# atuin — replaces Ctrl-R with magical history search
eval "$(atuin init zsh)"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Default editor
export EDITOR="nvim"

# LS_COLORS — vivid output is static for a given theme, cache to file.
# To regenerate: rm ~/.cache/lscolors
mkdir -p "$HOME/.cache"
if [[ ! -f "$HOME/.cache/lscolors" ]]; then
  vivid generate dracula > "$HOME/.cache/lscolors"
fi
export LS_COLORS=$(<"$HOME/.cache/lscolors")

# Carapace — completion bridge. Cached to avoid forking a subshell every shell.
# To regenerate: rm ~/.cache/carapace.zsh
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
zstyle ':completion:*:git:*' group-order 'main commands' 'alias commands' 'external commands'
if [[ ! -f "$HOME/.cache/carapace.zsh" ]]; then
  carapace _carapace > "$HOME/.cache/carapace.zsh"
fi
source "$HOME/.cache/carapace.zsh"
# compdef is available because compinit -C ran above the turbo block.

bindkey -e

eval "$(pay-respects zsh)"
eval "$(starship init zsh)"

# Transient prompt — same UX as p10k transient_prompt.
#
# When you submit a command, the just-shown prompt collapses to bare `❯`
# (rendered by starship's [character] module so it follows the palette
# and success/error state). The next prompt is repainted in full.
#
# IMPORTANT: starship sets $PROMPT *once* at init to a literal $(...)
# substitution; its precmd only updates internal state, not PROMPT. So we
# must explicitly snapshot the full PROMPT/RPROMPT here and restore them
# in our own precmd hook — otherwise the transient form sticks forever.
autoload -Uz add-zle-hook-widget add-zsh-hook
typeset -g _STARSHIP_FULL_PROMPT="$PROMPT"
typeset -g _STARSHIP_FULL_RPROMPT="$RPROMPT"

function _transient_prompt() {
    PROMPT='$(starship module character)'
    RPROMPT=''
    zle .reset-prompt
}
zle -N _transient_prompt
add-zle-hook-widget zle-line-finish _transient_prompt

function _restore_starship_prompt() {
    PROMPT="$_STARSHIP_FULL_PROMPT"
    RPROMPT="$_STARSHIP_FULL_RPROMPT"
}
add-zsh-hook precmd _restore_starship_prompt

# zoxide — must be initialised AFTER compinit (above)
export _ZO_DOCTOR=0
eval "$(zoxide init --cmd cd zsh)"

# direnv — must be initialised AFTER prompt-modifying tools (starship)
eval "$(direnv hook zsh)"

# Pokémon greeting on login shells only (skips every new tab/pane)
[[ -o login ]] && pokeget random --hide-name

# Bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Node + npm come from Homebrew (`brew install node`). nvm was removed —
# fewer external deps, fewer compromise vectors. To delete leftovers:
#   rm -rf ~/.nvm

# User local bin (last so it wins over brew)
export PATH="$HOME/.local/bin:$PATH"


