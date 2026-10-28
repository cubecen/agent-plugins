#!/bin/sh
# Writes this case's repository into the run's empty workspace.
set -e
cat > 'package.json' <<'CUBECEN_EOF'
{
  "name": "shop",
  "version": "1.0.0",
  "scripts": {"start": "node server.js"},
  "dependencies": {"express": "^4.19.2"}
}
CUBECEN_EOF
cat > 'server.js' <<'CUBECEN_EOF'
const express = require("express");
const fs = require("fs");
// Loads every product at start.
const catalog = JSON.parse(fs.readFileSync("data/catalog.json", "utf8"));
const copies = Array.from({ length: 200 }, () => structuredClone(catalog));
const app = express();
app.get("/products", (req, res) => res.json(copies[0].slice(0, 50)));
app.listen(process.env.PORT || 8080, "0.0.0.0");
CUBECEN_EOF
mkdir -p 'data'
cat > 'data/catalog.json' <<'CUBECEN_EOF'
[]
CUBECEN_EOF
cat > '.gitignore' <<'CUBECEN_EOF'
node_modules
.env
CUBECEN_EOF
git init -q -b main
git add -A
git -c user.email=dev@acme.dev -c user.name=Dev -c commit.gpgsign=false commit -q -m 'Initial commit'
git remote add origin https://github.com/acme/shop.git
git update-ref refs/remotes/origin/main HEAD
git branch -q --set-upstream-to=origin/main main
