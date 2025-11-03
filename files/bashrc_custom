# Type something then press up key to get most recent commands with the same first characters.
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

# Change sigint to b ctrl q
# Don't know why but I need to disable XON/XOFF flow control first
stty -ixon
stty intr ^q

# Custom prompt
function parse_git_branch {
  git branch 2>/dev/null | grep '\*' | sed 's/* \(.*\)/(\1)/'
}
BOLD="\[\033[1m\]"
RED="\[\033[0;31m\]"
GREEN="\[\033[0;32m\]"
BOLD_GREEN="\[\033[1;32m\]"
BOLD_BLUE="\[\033[1;34m\]"
BLUE="\[\033[0;34m\]"
RESET="\[\033[0m\]"
export PS1="${BOLD_GREEN}\u@\h:${BOLD_BLUE}\W${RED} \$(parse_git_branch)${RESET}\$ "

# Debugpython
alias debugpython="python -m debugpy --listen 51350 --wait-for-client"

# Add fzf key bindings and fuzzy completion
if [[ -f ~/.fzf.bash ]]; then
  source ~/.fzf.bash
fi

# pbcopy
alias pbcopy="xclip -selection clipboard"

# aws
alias aws-ec2-list-instances="aws ec2 describe-instances --query \"Reservations[*].Instances[*].{InstanceId:InstanceId,Name:Tags[?Key=='Name'].Value|[0],State:State.Name}\" --output table"