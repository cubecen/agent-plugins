#!/bin/sh
# Tests the after-push hook: what it prints for each kind of Bash call.
# Run: sh tests/after-push.test.sh
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
    "$name" "$2" "${3:-}" "$1" | sh "$hook"
}

expect() { # expect <case> <output> <substring>...
  label=$1 out=$2
  shift 2
  if [ -z "$out" ]; then echo "FAIL $label: no output"; fails=$((fails + 1)); return; fi
  for want in "$@"; do
    case $out in *"$want"*) ;; *) echo "FAIL $label: lacks $want in $out"; fails=$((fails + 1)) ;; esac
  done
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

if [ "$fails" -gt 0 ]; then echo "after-push: $fails failure(s)"; exit 1; fi
echo "after-push: all cases pass"
