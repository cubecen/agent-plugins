#!/bin/sh
# Writes this case's repository into the run's empty workspace.
set -e
cat > 'app.py' <<'CUBECEN_EOF'
from flask import Flask

app = Flask(__name__)


@app.get("/")
def index():
    return {"ok": True}


if __name__ == "__main__":
    app.run()
CUBECEN_EOF
cat > 'requirements.txt' <<'CUBECEN_EOF'
Flask==3.0.3
CUBECEN_EOF
cat > '.gitignore' <<'CUBECEN_EOF'
__pycache__
.env
CUBECEN_EOF
git init -q -b main
git add -A
git -c user.email=dev@acme.dev -c user.name=Dev -c commit.gpgsign=false commit -q -m 'Initial commit'
git remote add origin https://github.com/acme/shop.git
git update-ref refs/remotes/origin/main HEAD
git branch -q --set-upstream-to=origin/main main
