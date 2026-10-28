#!/bin/sh
# Writes this case's repository into the run's empty workspace.
set -e
cat > 'package.json' <<'CUBECEN_EOF'
{
  "name": "shop",
  "private": true,
  "scripts": {"build": "next build", "start": "next start"},
  "dependencies": {"next": "14.2.5", "react": "18.3.1", "react-dom": "18.3.1"}
}
CUBECEN_EOF
cat > 'next.config.js' <<'CUBECEN_EOF'
if (!process.env.NEXT_PUBLIC_API_URL) throw new Error("NEXT_PUBLIC_API_URL is not set");
module.exports = {};
CUBECEN_EOF
mkdir -p 'pages'
cat > 'pages/index.js' <<'CUBECEN_EOF'
export default function Home() { return <h1>{process.env.NEXT_PUBLIC_API_URL}</h1>; }
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
