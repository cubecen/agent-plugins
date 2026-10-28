#!/bin/sh
# A PostToolUse hook (Claude Code and Codex): after a Bash call that pushed a
# branch to GitHub, it tells the agent that the push started the cube's
# release and how to wait for it. Anything else prints nothing. POSIX sh,
# git, sed and grep only; no network.
input=$(cat)

# Only a Bash call that did not fail.
printf '%s' "$input" | grep -q '"tool_name": *"Bash"' || exit 0
printf '%s' "$input" | grep -q -e '\[rejected\]' -e 'fatal:' -e 'error: failed to push' && exit 0

# The command, as the tool input's JSON string (escapes kept).
command=$(printf '%s' "$input" | sed -nE 's/.*"command": *"(([^"\\]|\\.)*)".*/\1/p' | head -n 1)
# A git push at the start of the command or after a separator, not inside
# an argument such as a commit message; not a dry run.
push=$(printf '%s' "$command" | sed -nE 's/(^|.*[;&|] *)(git( +-C +[^ ;&|]+)? +push([^;&|]*))/\2/p' | head -n 1)
[ -n "$push" ] || exit 0
case " $push " in *" --dry-run "* | *" -n "*) exit 0 ;; esac

dir=$(printf '%s' "$input" | sed -nE 's/.*"cwd": *"(([^"\\]|\\.)*)".*/\1/p' | head -n 1)
[ -n "$dir" ] || dir=$PWD
other=$(printf '%s' "$push" | sed -nE 's/^git +-C +([^ ]+) +push.*/\1/p')
if [ -n "$other" ]; then
  case $other in /*) dir=$other ;; *) dir=$dir/$other ;; esac
fi

origin=$(git -C "$dir" remote get-url origin 2>/dev/null) || exit 0
repository=$(printf '%s' "$origin" | sed -nE 's#^(https://|ssh://git@|git@)github\.com[:/]([^/]+)/([^/]+)$#\2/\3#p' | sed 's/\.git$//')
[ -n "$repository" ] || exit 0

# The pushed branch: the push's last plain argument after the remote (its
# local side), else the current branch.
set -f
set -- $(printf '%s' "$push" | sed -E 's/^git( +-C +[^ ]+)? +push//')
branch=
remote_seen=
for arg in "$@"; do
  case $arg in -*) continue ;; esac
  if [ -z "$remote_seen" ]; then remote_seen=1; continue; fi
  branch=${arg%%:*}
done
[ -n "$branch" ] && [ "$branch" != HEAD ] || branch=$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null)
commit=$(git -C "$dir" rev-parse --verify -q "$branch^{commit}" 2>/dev/null) || exit 0

branch=$(printf '%s' "$branch" | sed 's/["\\]/_/g')
printf '{"hookSpecificOutput": {"hookEventName": "PostToolUse", "additionalContext": "A push to github.com/%s (branch %s, commit %s) just went out. If this repository has a Cubecen cube, the push started its release: call wait_for_release with the cube and commit %s; find the cube with list_applications repository %s."}}\n' \
  "$repository" "$branch" "$commit" "$commit" "$repository"
