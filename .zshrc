# only mac stuff for xplat -> add to .global-rc

# sourcing univeral aliases
source ~/.config/global-rc/.global-rc
source ~/.config/global-rc/.env
source ~/.config/global-rc/.global-aliases

# setting up cmp
autoload -Uz compinit
compinit

export PATH="/opt/homebrew/bin:$PATH"
# export PATH="/Library/Frameworks/Python.framework/Versions/3.12/bin:$PATH" # in path even when commented out??
# export PATH=/opt/homebrew/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin # idk where this came from keeping just incase

export STARSHIP_CONFIG=~/.config/starship/starship.toml # diff than bash config
export CDPATH=".:/Users/mo/.config" # colon sep list of dirs for 'cd' speed dial like zoxide

eval "$(starship init zsh)"
eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"

# bindkey -r "^[c" # remove default cd bind. must do before 👇🏼
source <(fzf --zsh)
#######################
# opts
#######################

setopt histignorespace

#######################
# aliases
#######################

# dotfiles and stuff
alias restrap="brew bundle dump --file=$DOTFILES/bootstrap/mac/Brewfile --no-vscode --force"


###################
# keybindings
###################

# TODO: add ctrl j/k keymaps
bindkey -v # enable vim bindings

dynamic_prefill() {
  local generated_text
  generated_text=$(git status) 
  
  READLINE_LINE="$generated_text"
  READLINE_POINT=${#READLINE_LINE}
}

# Added by Windsurf
export PATH="/Users/mo/.codeium/windsurf/bin:$PATH"
