#!/bin/sh
# A PostToolUse hook (Claude Code and Codex): after a Bash call that pushed a
# branch to GitHub, it tells the agent which commit went out and how to wait
# for the release of a cube that tracks that branch. Anything else prints
# nothing. POSIX sh, git, sed and grep only; no network.
input=$(cat)

# Only a Bash call that did not fail.
printf '%s' "$input" | grep -q '"tool_name": *"Bash"' || exit 0
printf '%s' "$input" | grep -q -e '\[rejected\]' -e 'fatal:' -e 'error: failed to push' && exit 0

# The command, as the tool input's JSON string (escapes kept); escaped line
# breaks separate commands as ; does.
command=$(printf '%s' "$input" | sed -nE 's/.*"command": *"(([^"\\]|\\.)*)".*/\1/p' | head -n 1 | sed -e 's/\\[nr]/;/g' -e 's/\\t/ /g')
# A git push at the start of the command or after a separator (not inside an
# argument such as a commit message), up to the next separator.
global='( +(-C|-c) +[^ ;&|]+| +--[a-z-]+(=[^ ;&|]+)?)*'
push=$(printf '%s' "$command" | sed -nE "s/(^|.*[;&|(] *)(git$global +push([^;&|)]*)).*/\2/p" | head -n 1)
[ -n "$push" ] || exit 0

dir=$(printf '%s' "$input" | sed -nE 's/.*"cwd": *"(([^"\\]|\\.)*)".*/\1/p' | head -n 1)
[ -n "$dir" ] || dir=$PWD
# cd <dir> right before the push: cd web && git push.
cdir=$(printf '%s' "$command" | sed -nE "s/(^|.*[;&|(] *)cd +([^ ;&|]+) *(&&|;) *git$global +push.*/\2/p" | head -n 1)
if [ -n "$cdir" ]; then
  case $cdir in /*) dir=$cdir ;; *) dir=$dir/$cdir ;; esac
fi

set -f
set -- $push
shift
while [ $# -gt 0 ] && [ "$1" != push ]; do
  case $1 in
    -C) [ $# -ge 2 ] || exit 0; case $2 in /*) dir=$2 ;; *) dir=$dir/$2 ;; esac; shift 2 ;;
    -c) shift 2 || exit 0 ;;
    *) shift ;;
  esac
done
[ "${1:-}" = push ] || exit 0
shift

# The remote and the pushed branch (the local side of the last refspec); a
# dry run or a deletion pushes nothing to build.
remote= branch= skip= tags=
for arg in "$@"; do
  if [ -n "$skip" ]; then skip=; continue; fi
  case $arg in
    --dry-run | --delete | -d | :*) exit 0 ;;
    --tags) tags=1; continue ;;
    -o | --push-option | --repo | --receive-pack | --exec) skip=1; continue ;;
    --*) continue ;;
    -*n*) exit 0 ;;
    -*) continue ;;
    *'>'* | *'<'*) continue ;;
  esac
  if [ -z "$remote" ]; then remote=$arg; continue; fi
  branch=${arg#+}
  branch=${branch%%:*}
done

# Tags alone build nothing.
[ -z "$tags" ] || [ -n "$branch" ] || exit 0

case ${remote:-origin} in
  *://* | *@*:*) url=$remote ;;
  *) url=$(git -C "$dir" remote get-url "${remote:-origin}" 2>/dev/null) || exit 0 ;;
esac
repository=$(printf '%s' "$url" | sed -nE 's#^(https://|ssh://git@|git@)github\.com[:/]([A-Za-z0-9_.-]+)/([A-Za-z0-9_.-]+)$#\2/\3#p' | sed 's/\.git$//')
[ -n "$repository" ] || exit 0

case $branch in
  "" | HEAD) branch=$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null) || exit 0 ;;
  *) git -C "$dir" show-ref --verify -q "refs/heads/$branch" || exit 0 ;;
esac
[ "$branch" != HEAD ] || exit 0
commit=$(git -C "$dir" rev-parse --verify -q "refs/heads/$branch^{commit}" 2>/dev/null) || exit 0

branch=$(printf '%s' "$branch" | sed 's/["\\]/_/g')
printf '{"hookSpecificOutput": {"hookEventName": "PostToolUse", "additionalContext": "A push to github.com/%s (branch %s, commit %s) just went out. A Cubecen cube of this repository that tracks %s (its deploy_branch; empty means the default branch) builds it: find it with list_applications repository %s, then call wait_for_release with the cube and commit %s. If no cube tracks %s, nothing deploys; do not deploy unless the user asks."}}\n' \
  "$repository" "$branch" "$commit" "$branch" "$repository" "$commit" "$branch"
