#!/bin/sh
# Writes this case's repository into the run's empty workspace.
set -e
cat > 'package.json' <<'CUBECEN_EOF'
{
  "name": "shop",
  "private": true,
  "type": "module",
  "scripts": {"dev": "vite", "build": "vite build", "start": "vite preview"},
  "dependencies": {"react": "^18.3.1", "react-dom": "^18.3.1"},
  "devDependencies": {"vite": "^5.4.0", "@vitejs/plugin-react": "^4.3.1"}
}
CUBECEN_EOF
cat > 'vite.config.js' <<'CUBECEN_EOF'
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
export default defineConfig({ plugins: [react()] });
CUBECEN_EOF
cat > 'index.html' <<'CUBECEN_EOF'
<!doctype html><html><body><div id="root"></div><script type="module" src="/src/main.jsx"></script></body></html>
CUBECEN_EOF
mkdir -p 'src'
cat > 'src/main.jsx' <<'CUBECEN_EOF'
import { createRoot } from "react-dom/client";
createRoot(document.getElementById("root")).render(<h1>Acme shop</h1>);
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
