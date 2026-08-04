if [ -f ~/.bash_profile ]; then
  . ~/.bash_profile
fi
. "$HOME/.cargo/env"

# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
# End Nix

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

export PATH=$PATH:/home/sanka/.spicetify

if [ -z "$SSH_AUTH_SOCK" ] || ! ssh-add -l &>/dev/null; then
  eval $(ssh-agent -s) >/dev/null
  ssh-add ~/.ssh/id_github 2>/dev/null
fi
