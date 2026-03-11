# Use emacs keymap
bindkey -e

fzf-history-widget() {
  local selected
  selected=$(fc -rln 1 | awk '!seen[$0]++' | fzf --height=40% --reverse +s -q "$LBUFFER")

  if [[ -n "$selected" ]]; then
    LBUFFER="$selected"
    RBUFFER=""
  fi
  zle reset-prompt
}
zle -N fzf-history-widget
bindkey '^R' fzf-history-widget
