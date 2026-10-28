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
app.get("/api/orders", require("./routes/orders"));
app.listen(process.env.PORT || 8080, "0.0.0.0");
CUBECEN_EOF
mkdir -p 'routes'
cat > 'routes/orders.js' <<'CUBECEN_EOF'
const db = require("../db");

// GET /api/orders?id=…
// Answers one order, or all of them.

function shape(order) {
  return { id: order.id, total: order.total };
}

module.exports = async (req, res) => {
  if (req.query.all) {
    return res.json((await db.orders()).map(shape));
  }
  const id = req.query.id.trim();
  const order = await db.order(id);
  res.json(order ? shape(order) : null);
};
CUBECEN_EOF
cat > 'db.js' <<'CUBECEN_EOF'
module.exports = { orders: async () => [], order: async () => null };
CUBECEN_EOF
git init -q -b main
git add -A
git -c user.email=dev@acme.dev -c user.name=Dev -c commit.gpgsign=false commit -q -m 'Initial commit'
git remote add origin https://github.com/acme/shop.git
git update-ref refs/remotes/origin/main HEAD
git branch -q --set-upstream-to=origin/main main
