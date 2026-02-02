# ============================================
# ARM64 Homebrew - MUST BE FIRST
# ============================================
eval "$(/opt/homebrew/bin/brew shellenv)"

# Remove Intel Homebrew from PATH to avoid Rosetta-era /usr/local conflicts.
PATH="$(echo "$PATH" | tr ':' '\n' | grep -v '^/usr/local/bin$' | paste -sd ':' -)"
export PATH

export PATH="$HOME/.composer/vendor/bin:$PATH"

# Add Atuin to the path
export PATH="$HOME/.atuin/bin:$PATH";

# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH";

# Add pyenv to PATH so that you can reference python (not python3)
export PATH="$HOME/.pyenv/shims:$PATH";

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don't want to commit.
for file in ~/.{path,bash_prompt,bash_completion,exports,aliases,functions,extra}; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
  shopt -s "$option" 2> /dev/null;
done;

# Add tab completion for many Bash commands
if which brew > /dev/null && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
  source "$(brew --prefix)/share/bash-completion/bash_completion";
elif [ -f /etc/bash_completion ]; then
  source /etc/bash_completion;
fi;

# source .bash_completion
source ~/.bash_completion

# Enable tab completion for `g` by marking it as an alias for `git`
# FIXED: Use brew --prefix instead of hardcoded /usr/local
if type _git &> /dev/null && [ -f "$(brew --prefix)/etc/bash_completion.d/git-completion.bash" ]; then
  complete -o default -o nospace -F _git g;
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults;

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall;

# Herd injected PHP binary.
export PATH="/Users/mwender/Library/Application Support/Herd/bin/":$PATH

# Herd injected PHP 8.2 configuration.
export HERD_PHP_82_INI_SCAN_DIR="/Users/mwender/Library/Application Support/Herd/config/php/82/"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

. "$HOME/.atuin/bin/env"

# REMOVE THIS - conflicts with ARM brew
# export PATH=$PATH:/usr/local/lib/node_modules

. "$HOME/.local/bin/env"
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"