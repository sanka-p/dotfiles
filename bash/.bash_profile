# Load the shell dotfiles
# ~/.path to extend `$PATH`
# ~/.aliases for aliases
# ~/.functions for functions
# ~/.exports for various exports
# ~/.bash_prompt to customize the bash prompt
# ~/.extra for machine-specific config you don’t want to commit
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file
