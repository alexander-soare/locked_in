#!/bin/bash
input=$(cat)
model=$(echo "$input" | jq -r '.model.display_name // empty')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
[ -z "$cwd" ] && cwd=$(pwd)
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
effort=$(echo "$input" | jq -r '.effort.level // empty')

branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short -q HEAD 2>/dev/null \
  || git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)

# Project name comes from the origin remote, falling back to the repo directory
project=""
if [ -n "$branch" ]; then
  project=$(git -C "$cwd" --no-optional-locks remote get-url origin 2>/dev/null)
  [ -z "$project" ] && project=$(git -C "$cwd" --no-optional-locks rev-parse --show-toplevel 2>/dev/null)
  project=$(basename "${project%/}" .git)
fi

reset=$'\033[0m'
dim=$'\033[2m'
cyan=$'\033[1;36m'
magenta=$'\033[35m'
green=$'\033[32m'
yellow=$'\033[33m'
red=$'\033[31m'

# Context colour shifts from green to yellow to red as the window fills
if [ -n "$used" ]; then
  pct=$(printf '%.0f' "$used")
  if [ "$pct" -ge 80 ]; then ctx_colour=$red
  elif [ "$pct" -ge 50 ]; then ctx_colour=$yellow
  else ctx_colour=$green
  fi
fi

parts=()
[ -n "$model" ] && parts+=("Model: ${cyan}${model}${reset}")
[ -n "$effort" ] && parts+=("Effort: ${magenta}${effort}${reset}")
[ -n "$used" ] && parts+=("Context: ${ctx_colour}${pct}%${reset}")
[ -n "$branch" ] && parts+=("Project: ${green}${project}@${branch}${reset}")

out=""
for p in "${parts[@]}"; do
  out="${out:+$out ${dim}|${reset} }$p"
done
printf '%s\n' "$out"
