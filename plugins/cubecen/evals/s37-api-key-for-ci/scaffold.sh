#!/bin/sh
# Writes this case's repository into the run's empty workspace.
set -e
mkdir -p '.github/workflows'
cat > '.github/workflows/deploy.yml' <<'CUBECEN_EOF'
name: deploy
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - run: |
          curl -fsS -X POST "https://api.cubecen.com/v1/organizations/acme/projects/shop/applications/web/builds" \
            -H "Authorization: Bearer ${{ secrets.CUBECEN_API_KEY }}" -H 'Content-Type: application/json' -d '{"deploy": true}'
CUBECEN_EOF
cat > 'README.md' <<'CUBECEN_EOF'
# Shop
CUBECEN_EOF
git init -q -b main
git add -A
git -c user.email=dev@acme.dev -c user.name=Dev -c commit.gpgsign=false commit -q -m 'Initial commit'
git remote add origin https://github.com/acme/shop.git
git update-ref refs/remotes/origin/main HEAD
git branch -q --set-upstream-to=origin/main main
