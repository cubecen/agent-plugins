#!/bin/sh
# Writes this case's repository into the run's empty workspace.
set -e
cat > 'package.json' <<'CUBECEN_EOF'
{
  "name": "shop",
  "private": true,
  "type": "module",
  "scripts": {"dev": "vite dev", "build": "vite build", "preview": "vite preview"},
  "devDependencies": {"@sveltejs/adapter-auto": "^3.2.0", "@sveltejs/kit": "^2.5.0", "svelte": "^4.2.0", "vite": "^5.4.0"}
}
CUBECEN_EOF
cat > 'svelte.config.js' <<'CUBECEN_EOF'
import adapter from "@sveltejs/adapter-auto";
export default { kit: { adapter: adapter() } };
CUBECEN_EOF
mkdir -p 'src/routes'
cat > 'src/routes/+page.svelte' <<'CUBECEN_EOF'
<h1>Acme shop</h1>
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
