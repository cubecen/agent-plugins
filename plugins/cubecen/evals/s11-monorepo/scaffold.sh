#!/bin/sh
# Writes this case's repository into the run's empty workspace.
set -e
mkdir -p 'api'
cat > 'api/package.json' <<'CUBECEN_EOF'
{
  "name": "api",
  "scripts": {"start": "node index.js"},
  "dependencies": {"express": "^4.19.2", "cors": "^2.8.5"}
}
CUBECEN_EOF
mkdir -p 'api'
cat > 'api/index.js' <<'CUBECEN_EOF'
const express = require("express");
const cors = require("cors");
const app = express();
app.use(cors({ origin: process.env.FRONTEND_URL }));
app.get("/v1/products", (req, res) => res.json([]));
app.listen(process.env.PORT || 8080, "0.0.0.0");
CUBECEN_EOF
mkdir -p 'web'
cat > 'web/package.json' <<'CUBECEN_EOF'
{
  "name": "web",
  "private": true,
  "type": "module",
  "scripts": {"build": "vite build"},
  "devDependencies": {"vite": "^5.4.0"}
}
CUBECEN_EOF
mkdir -p 'web'
cat > 'web/index.html' <<'CUBECEN_EOF'
<!doctype html><html><body><script type="module" src="/main.js"></script></body></html>
CUBECEN_EOF
mkdir -p 'web'
cat > 'web/main.js' <<'CUBECEN_EOF'
fetch(import.meta.env.VITE_API_URL + "/v1/products").then((r) => r.json()).then(console.log);
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
