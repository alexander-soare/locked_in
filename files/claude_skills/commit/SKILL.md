---
name: commit
description: Sense check the staged changes then commit them with the provided message.
allowed-tools: Bash(git commit *), Bash(git diff *), Bash(git log *), Bash(git status *)
---

Usage:

/commit "Commit message here"

## Rules

Do not use tools not in the allowed-tools.

## Steps — execute in order, stop if any step fails

1. Check that there are staged changes. If not, stop and let the user know.

2. Sense check the staged changes. This step is mandatory and substantive: read the diff critically, flag dead code, stale references, broken wiring, docstring/code mismatches, and logical errors. Feel free to ask the user questions if needed. DO NOT make your own edits.

3. Commit, using the user provided commit message, ONLY after surfacing concerns and getting the user's explicit go-ahead (or confirming there are no concerns)
