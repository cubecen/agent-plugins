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
cat > '.gitignore' <<'CUBECEN_EOF'
node_modules
.env
CUBECEN_EOF
cat > 'server.js' <<'CUBECEN_EOF'
const express = require("express");
const app = express();
app.get("/api/report", require("./routes/report"));
app.listen(process.env.PORT || 8080, "0.0.0.0");
CUBECEN_EOF
mkdir -p 'routes'
cat > 'routes/report.js' <<'CUBECEN_EOF'
// Counts primes for the report, on every request.
function primes(n) {
  let count = 0;
  for (let i = 2; i < n; i++) {
    let prime = true;
    for (let j = 2; j * j <= i; j++) if (i % j === 0) { prime = false; break; }
    if (prime) count++;
  }
  return count;
}

module.exports = (req, res) => res.json({ primes: primes(5_000_000) });
CUBECEN_EOF
git init -q -b main
git add -A
git -c user.email=dev@acme.dev -c user.name=Dev -c commit.gpgsign=false commit -q -m 'Initial commit'
git remote add origin https://github.com/acme/shop.git
git update-ref refs/remotes/origin/main HEAD
git branch -q --set-upstream-to=origin/main main
