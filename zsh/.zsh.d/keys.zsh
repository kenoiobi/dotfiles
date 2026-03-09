fzf-history-widget() {
  local output key selected query
  output=$(fc -rln 1 | awk '!seen[$0]++' | fzf --print-query --expect=alt-enter --height=40% --reverse --tac +s -q "$LBUFFER")
  query=$(echo "$output" | sed -n '1p')
  key=$(echo "$output" | sed -n '2p')
  selected=$(echo "$output" | sed -n '3p')

  if [[ "$key" == "alt-enter" && -n "$selected" ]]; then
    LBUFFER="$selected"
    RBUFFER=""
  elif [[ -n "$query" ]]; then
    LBUFFER="$query"
    RBUFFER=""
  fi
  zle reset-prompt
}
zle -N fzf-history-widget
bindkey '^R' fzf-history-widget
