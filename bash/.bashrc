if [ -f ~/.bash_profile ]; then
  . ~/.bash_profile
fi

if [ -z "$SSH_AUTH_SOCK" ] || ! ssh-add -l &>/dev/null; then
  eval $(ssh-agent -s) >/dev/null
  ssh-add ~/.ssh/id_github 2>/dev/null
fi
