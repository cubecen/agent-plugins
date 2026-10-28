#!/bin/sh
# Checks the plugin before a commit: the manifests, the structure of the
# skills and eval cases, and the push hook.
set -e
cd "$(dirname "$0")/.."
claude plugin validate plugins/cubecen | tail -1
claude plugin validate . | tail -1
python3 -I tests/check_repo.py
if [ -f tests/after-push.test.sh ]; then
  sh tests/after-push.test.sh
else
  echo "after-push tests: not written yet"
fi
