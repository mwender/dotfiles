# ============================================
# Bash Login Profile
# - ARM Homebrew first
# - Remove Intel /usr/local/bin from PATH
# - Keep tool paths tidy (Composer, Atuin, pyenv, Volta, Bun, Herd)
# ============================================

# --------------------------------------------
# ARM64 Homebrew (MUST BE FIRST)
# --------------------------------------------
eval "$(/opt/homebrew/bin/brew shellenv)"

# Remove Intel Homebrew (/usr/local/bin) from PATH to avoid Rosetta-era conflicts.
# (We do NOT touch Apple's cryptex bootstrap usr/local path.)
PATH="$(echo "$PATH" | tr ':' '\n' | grep -v '^/usr/local/bin$' | paste -sd ':' -)"
export PATH

# --------------------------------------------
# Base PATH additions (prepend so they win)
# --------------------------------------------

# Composer global binaries (Valet, etc.)
export PATH="$HOME/.composer/vendor/bin:$PATH"

# Herd injected PHP binary (if you use Herd PHP tooling).
export PATH="$HOME/Library/Application Support/Herd/bin:$PATH"

# Atuin
export PATH="$HOME/.atuin/bin:$PATH"

# Personal bin
export PATH="$HOME/bin:$PATH"

# Local bin (often used by pipx/other tools)
export PATH="$HOME/.local/bin:$PATH"

# pyenv shims
export PATH="$HOME/.pyenv/shims:$PATH"

# Volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# RVM bin (keep available for scripting)
export PATH="$PATH:$HOME/.rvm/bin"

# --------------------------------------------
# Load supporting dotfiles (if present)
# ~/.path can be used to extend PATH.
# ~/.extra can be used for other local settings.
# --------------------------------------------
for file in ~/.{path,bash_prompt,bash_completion,exports,aliases,functions,extra}; do
  if [ -r "$file" ] && [ -f "$file" ]; then
    source "$file"
  fi
done
unset file

# --------------------------------------------
# Shell options
# --------------------------------------------

# Case-insensitive globbing (pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Enable some Bash 4 features when possible
for option in autocd globstar; do
  shopt -s "$option" 2> /dev/null
done

# --------------------------------------------
# Bash completion
# --------------------------------------------

if command -v brew > /dev/null 2>&1 && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
  source "$(brew --prefix)/share/bash-completion/bash_completion"
elif [ -f /etc/bash_completion ]; then
  source /etc/bash_completion
fi

# Load your custom completion file if it exists
if [ -f "$HOME/.bash_completion" ]; then
  source "$HOME/.bash_completion"
fi

# Enable tab completion for `g` (git alias) when git completion is available
if type _git > /dev/null 2>&1 && [ -f "$(brew --prefix)/etc/bash_completion.d/git-completion.bash" ]; then
  complete -o default -o nospace -F _git g
fi

# SSH hostname completion from ~/.ssh/config (ignoring wildcards)
if [ -f "$HOME/.ssh/config" ]; then
  complete -o default -o nospace \
    -W "$(grep "^Host" "$HOME/.ssh/config" | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" \
    scp sftp ssh
fi

# defaults read|write NSGlobalDomain completion
complete -W "NSGlobalDomain" defaults

# killall completion for common apps
complete -o nospace -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall

# --------------------------------------------
# Herd env vars (keep if you use Herd)
# --------------------------------------------

# Herd injected PHP 8.2 configuration.
export HERD_PHP_82_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/82/"

# --------------------------------------------
# RVM initialization (functions, gemsets, etc.)
# --------------------------------------------
if [ -s "$HOME/.rvm/scripts/rvm" ]; then
  source "$HOME/.rvm/scripts/rvm"
fi

# --------------------------------------------
# Atuin env
# --------------------------------------------
if [ -f "$HOME/.atuin/bin/env" ]; then
  . "$HOME/.atuin/bin/env"
fi

# --------------------------------------------
# Local env scripts (if present)
# --------------------------------------------
if [ -f "$HOME/.local/bin/env" ]; then
  . "$HOME/.local/bin/env"
fi

# NOTE:
# Removed legacy Intel node modules PATH line:
# export PATH="$PATH:/usr/local/lib/node_modules"
 
# De-duplicate PATH entries while preserving order.
PATH="$(printf '%s' "$PATH" | awk -v RS=':' '!a[$0]++ { if (NR==1) printf "%s", $0; else printf ":%s", $0 }')"
export PATH

