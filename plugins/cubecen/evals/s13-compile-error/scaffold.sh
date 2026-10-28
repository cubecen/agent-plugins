#!/bin/sh
# Writes this case's repository into the run's empty workspace.
set -e
cat > 'go.mod' <<'CUBECEN_EOF'
module acme/shop

go 1.23
CUBECEN_EOF
cat > 'main.go' <<'CUBECEN_EOF'
package main

import (
	"fmt"
	"net/http"
	"os"
)

func handle(w http.ResponseWriter, r *http.Request) { fmt.Fprintln(w, "Acme shop") }

func main() {
	http.HandleFunc("/", handler)
	http.ListenAndServe("0.0.0.0:"+os.Getenv("PORT"), nil)
}
CUBECEN_EOF
git init -q -b main
git add -A
git -c user.email=dev@acme.dev -c user.name=Dev -c commit.gpgsign=false commit -q -m 'Initial commit'
git remote add origin https://github.com/acme/shop.git
git update-ref refs/remotes/origin/main HEAD
git branch -q --set-upstream-to=origin/main main
