# Just a modified robby russel theme
NEWLINE=$'\n'
PROMPT="%{$fg[cyan]%}%c%{$reset_color%} %(?:%{$fg_bold[green]%}%1{➜%} :%{$fg_bold[green]%}%1{➜%} )"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%})%{$fg[yellow]%}%1{%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

OMZ_NEW_LINE_FORMAT=$'\n'
ZSH_THEME_GIT_PROMPT_SUFFIX+=$OMZ_NEW_LINE_FORMAT
# Uncomment if you want to move the command line to a new line always 
PROMPT+=$OMZ_NEW_LINE_FORMAT
