#!/bin/sh
# Writes this case's repository into the run's empty workspace.
set -e
cat > 'Dockerfile' <<'CUBECEN_EOF'
FROM nginx:1.27-alpine
COPY index.html /usr/share/nginx/html/index.html
CUBECEN_EOF
cat > 'index.html' <<'CUBECEN_EOF'
<!doctype html><h1>Acme shop</h1>
CUBECEN_EOF
git init -q -b main
git add -A
git -c user.email=dev@acme.dev -c user.name=Dev -c commit.gpgsign=false commit -q -m 'Initial commit'
git remote add origin https://github.com/acme/shop.git
git update-ref refs/remotes/origin/main HEAD
git branch -q --set-upstream-to=origin/main main
