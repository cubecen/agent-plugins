#!/bin/sh
# Tests the after-push hook: what it prints for each kind of Bash call.
# Run: sh tests/after-push.test.sh (HOOK_SHELL=dash runs the hook with dash)
set -u
hook="$(cd "$(dirname "$0")/.." && pwd)/plugins/cubecen/hooks/after-push.sh"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
fails=0

repo() { # repo <dir> <origin or "">: a repository with one commit on main
  mkdir -p "$1" && git -C "$1" init -q -b main && git -C "$1" -c user.email=t@t -c user.name=t -c commit.gpgsign=false commit -q --allow-empty -m first
  [ -n "$2" ] && git -C "$1" remote add origin "$2"
  return 0
}

run() { # run <cwd> <command> [tool_response] [tool_name]: the hook's stdout
  name=${4:-Bash}
  printf '{"session_id":"s","hook_event_name":"PostToolUse","tool_name":"%s","tool_input":{"command":"%s"},"tool_response":{"stdout":"%s","stderr":""},"cwd":"%s"}' \
    "$name" "$2" "${3:-}" "$1" | ${HOOK_SHELL:-sh} "$hook"
}

expect() { # expect <case> <output> <substring>...: printed, valid JSON, holds each substring
  label=$1 out=$2
  shift 2
  if [ -z "$out" ]; then echo "FAIL $label: no output"; fails=$((fails + 1)); return; fi
  printf '%s' "$out" | python3 -I -c 'import json, sys; json.load(sys.stdin)' 2>/dev/null || { echo "FAIL $label: not JSON: $out"; fails=$((fails + 1)); }
  for want in "$@"; do
    case $out in *"$want"*) ;; *) echo "FAIL $label: lacks $want in $out"; fails=$((fails + 1)) ;; esac
  done
}

lacks() { # lacks <case> <output> <substring>: the output does not hold it
  case $2 in *"$3"*) echo "FAIL $1: holds $3 in $2"; fails=$((fails + 1)) ;; esac
}

silent() { # silent <case> <output>
  if [ -n "$2" ]; then echo "FAIL $1: printed $2"; fails=$((fails + 1)); fi
}

repo "$tmp/shop" https://github.com/acme/shop.git
sha=$(git -C "$tmp/shop" rev-parse HEAD)
out=$(run "$tmp/shop" "git push origin main")
expect "push" "$out" '"hookEventName": "PostToolUse"' "github.com/acme/shop" "branch main" "$sha" "wait_for_release" "list_applications repository acme/shop"
expect "git -C" "$(run "$tmp" "git -C $tmp/shop push")" "github.com/acme/shop" "$sha"
repo "$tmp/ssh" git@github.com:acme/shop.git
expect "ssh remote" "$(run "$tmp/ssh" "git push")" "github.com/acme/shop"
silent "dry run" "$(run "$tmp/shop" "git push --dry-run origin main")"
silent "-n" "$(run "$tmp/shop" "git push -n")"
silent "status" "$(run "$tmp/shop" "git status")"
silent "commit message" "$(run "$tmp/shop" "git commit -m \\\"git push later\\\"")"
repo "$tmp/lab" https://gitlab.com/acme/shop.git
silent "gitlab" "$(run "$tmp/lab" "git push")"
repo "$tmp/none" ""
silent "no origin" "$(run "$tmp/none" "git push")"
silent "rejected" "$(run "$tmp/shop" "git push" " ! [rejected]        main -> main (fetch first)")"
silent "fatal" "$(run "$tmp/shop" "git push" "fatal: unable to access")"
silent "failed to push" "$(run "$tmp/shop" "git push" "error: failed to push some refs")"
silent "not Bash" "$(run "$tmp/shop" "git push" "" Write)"

# A branch with its own commit, while main stays checked out.
git -C "$tmp/shop" branch -q feature
git -C "$tmp/shop" -c user.email=t@t -c user.name=t -c commit.gpgsign=false commit -q --allow-empty -m second
feature=$(git -C "$tmp/shop" rev-parse feature)
main=$(git -C "$tmp/shop" rev-parse main)
expect "untracked branch wording" "$(run "$tmp/shop" "git push origin main")" "tracks main" "do not deploy unless the user asks"
expect "redirect and pipe" "$(run "$tmp/shop" "git push origin feature 2>&1 | tail -5")" "branch feature" "$feature"
expect "redirect only" "$(run "$tmp/shop" "git push -u origin feature 2>&1")" "branch feature" "$feature"
expect "push then echo" "$(run "$tmp/shop" "git push origin main && echo done")" "branch main" "$main"
expect "push then status" "$(run "$tmp/shop" "git push origin main; git status")" "branch main" "$main"
expect "multi-line" "$(run "$tmp/shop" "git add -A\\ngit push origin feature")" "branch feature" "$feature"
out=$(run "$tmp/shop" "git push origin feature && git checkout main")
expect "push then checkout" "$out" "branch feature" "$feature"
lacks "push then checkout" "$out" "$main"
expect "force" "$(run "$tmp/shop" "git push origin +feature")" "branch feature" "$feature"
expect "refspec" "$(run "$tmp/shop" "git push origin feature:release")" "branch feature" "$feature"
expect "HEAD" "$(run "$tmp/shop" "git push -u origin HEAD")" "branch main" "$main"
expect "git -c" "$(run "$tmp/shop" "git -c push.default=current push origin feature")" "branch feature" "$feature"
expect "--no-pager" "$(run "$tmp/shop" "git --no-pager push origin feature")" "branch feature" "$feature"
expect "push option" "$(run "$tmp/shop" "git push -o ci.skip origin feature")" "branch feature" "$feature"
expect "cd then push" "$(run "$tmp" "cd $tmp/shop && git push origin feature")" "github.com/acme/shop" "$feature"
expect "subshell" "$(run "$tmp/shop" "(git push origin feature)")" "branch feature" "$feature"
silent "tags only" "$(run "$tmp/shop" "git push --tags")"
expect "branch and tags" "$(run "$tmp/shop" "git push origin feature --tags")" "branch feature" "$feature"
silent "delete :ref" "$(run "$tmp/shop" "git push origin :feature")"
silent "delete --delete" "$(run "$tmp/shop" "git push origin --delete feature")"
silent "delete -d" "$(run "$tmp/shop" "git push -d origin feature")"
silent "-nv" "$(run "$tmp/shop" "git push -nv origin main")"
silent "commit message with ;" "$(run "$tmp/shop" "git commit -m \\\"wip; git push later\\\"")"
git -C "$tmp/shop" remote add upstream https://github.com/acme/fork.git
git -C "$tmp/shop" remote add mirror https://gitlab.com/acme/shop.git
expect "named remote" "$(run "$tmp/shop" "git push upstream feature")" "github.com/acme/fork" "$feature"
silent "named remote not GitHub" "$(run "$tmp/shop" "git push mirror main")"
repo "$tmp/odd" 'https://github.com/acme/sh"op.git'
silent "quote in origin" "$(run "$tmp/odd" "git push")"
repo "$tmp/inject" 'https://github.com/acme/shop.git;echo'
silent "separator in origin" "$(run "$tmp/inject" "git push")"

if [ "$fails" -gt 0 ]; then echo "after-push: $fails failure(s)"; exit 1; fi
echo "after-push: all cases pass"
