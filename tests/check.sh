#!/bin/sh
# Checks the plugin before a commit: the manifests, the structure of the
# skills and eval cases, and the push hook. Exits non-zero on the first
# failure.
set -e
cd "$(dirname "$0")/.."
validate() { # validate <path>: prints the verdict; all of the output when it fails
  out=$(claude plugin validate "$1" 2>&1) || { printf '%s\n' "$out"; exit 1; }
  printf '%s\n' "$out" | tail -n 1
}
validate plugins/cubecen
validate .
python3 -I tests/check_repo.py
sh tests/after-push.test.sh
