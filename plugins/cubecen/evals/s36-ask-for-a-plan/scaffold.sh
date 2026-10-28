#!/bin/sh
# Writes this case's repository into the run's empty workspace.
set -e
mkdir -p 'web'
cat > 'web/package.json' <<'CUBECEN_EOF'
{"name":"storefront","scripts":{"build":"next build","start":"next start"},"dependencies":{"next":"14.2.5","react":"18.3.1"}}
CUBECEN_EOF
mkdir -p 'api'
cat > 'api/go.mod' <<'CUBECEN_EOF'
module github.com/acme/shop/api

go 1.23
CUBECEN_EOF
mkdir -p 'api'
cat > 'api/main.go' <<'CUBECEN_EOF'
package main

import "net/http"

func main() { http.ListenAndServe(":8080", nil) }
CUBECEN_EOF
cat > 'README.md' <<'CUBECEN_EOF'
# Shop

A Next.js storefront (web/) and its Go API (api/).
CUBECEN_EOF
git init -q -b main
git add -A
git -c user.email=dev@acme.dev -c user.name=Dev -c commit.gpgsign=false commit -q -m 'Initial commit'
git remote add origin https://github.com/acme/shop.git
git update-ref refs/remotes/origin/main HEAD
git branch -q --set-upstream-to=origin/main main
