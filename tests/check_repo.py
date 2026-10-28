"""Checks the plugin's structure: JSON files, skills, their references and
the eval cases. Run with python3 -I tests/check_repo.py from anywhere."""

import json
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SKIP = {".git", ".superpowers", "results", "node_modules"}
WORDS = 500
# Every case's push guard: a git push or gh repo create in the Bash command
# (not its description), after a separator, a space or an escaped line break.
PUSH_GUARD = (r'"command"\s*:\s*"(?:[^"\\]|\\.)*?(?:(?<![\w-])|(?<=\\[nrt]))'
              r'(?:git(?:\s+(?:-C|-c)\s+\S+|\s+--[\w-]+(?:=\S+)?)*\s+push\b|gh\s+repo\s+create\b)')
PUSHES = ["git push", "git add -A\ngit commit -m x\ngit push", "cd app\ngh repo create acme/shop --private",
          "git --no-pager push origin main", "git -c k=v push", "git -C web push", "git add . && git push origin main",
          "(git push)", "/usr/bin/git push"]
NOT_PUSHES = ["git status", "git pushx", "legit push", "cat .git/config", "git log --oneline"]
problems = []


def walk(top):
    for dirpath, dirnames, filenames in os.walk(top):
        dirnames[:] = [d for d in dirnames if d not in SKIP]
        for name in filenames:
            yield os.path.join(dirpath, name)


def rel(path):
    return os.path.relpath(path, ROOT)


def frontmatter(path):
    """The simple key: value lines between the first two --- lines."""
    with open(path, encoding="utf-8") as f:
        text = f.read()
    m = re.match(r"---\n(.*?)\n---\n(.*)", text, re.S)
    if not m:
        return None, text
    fields = {}
    for line in m.group(1).splitlines():
        key, sep, value = line.partition(":")
        if sep and not line.startswith((" ", "\t", "-")):
            fields[key.strip()] = value.strip()
    return fields, m.group(2)


# Every JSON file parses.
for path in walk(ROOT):
    if path.endswith(".json"):
        try:
            with open(path, encoding="utf-8") as f:
                json.load(f)
        except ValueError as e:
            problems.append(f"{rel(path)}: invalid JSON: {e}")

for plugin in sorted(os.listdir(os.path.join(ROOT, "plugins"))):
    base = os.path.join(ROOT, "plugins", plugin)
    # Skills: name is the directory, a short description, references exist.
    skills = os.path.join(base, "skills")
    for skill in sorted(os.listdir(skills)) if os.path.isdir(skills) else []:
        path = os.path.join(skills, skill, "SKILL.md")
        if not os.path.isfile(path):
            problems.append(f"{rel(os.path.join(skills, skill))}: no SKILL.md")
            continue
        fields, body = frontmatter(path)
        if fields is None:
            problems.append(f"{rel(path)}: no frontmatter")
            continue
        if fields.get("name") != skill:
            problems.append(f"{rel(path)}: name {fields.get('name')!r} is not its directory {skill!r}")
        description = fields.get("description", "")
        if not description or len(description) >= 300:
            problems.append(f"{rel(path)}: description missing or {len(description)} characters (under 300)")
        words = len(body.split())
        if words >= WORDS:
            problems.append(f"{rel(path)}: {words} words (under {WORDS})")
        for ref in sorted(set(re.findall(r"references/[\w.-]+\.md", body))):
            if not os.path.isfile(os.path.join(skills, skill, ref)):
                problems.append(f"{rel(path)}: names {ref}, which does not exist")
    # Evals: cases, graders, scaffolds and mocked tools.
    evals = os.path.join(base, "evals")
    if not os.path.isdir(evals):
        continue
    tools_file = os.path.join(evals, "mocks", "cubecen", "_tools.json")
    tools = set()
    if os.path.isfile(tools_file):
        with open(tools_file, encoding="utf-8") as f:
            tools = {t["name"] for t in json.load(f)["tools"]}
    else:
        problems.append(f"{rel(tools_file)}: missing (scripts/sync-tools.sh)")
    for mock_dir, _, files in os.walk(evals):
        parts = rel(mock_dir).split(os.sep)
        if "mocks" not in parts or "results" in parts or "fixtures" in parts or ".replay" in parts:
            continue
        server = parts[-1]
        if parts[-2] != "mocks":
            continue
        if server != "cubecen":
            problems.append(f"{rel(mock_dir)}: mocks for {server!r}, but the plugin's server is 'cubecen'")
        for name in files:
            if name.startswith("_") or not name.endswith(".md"):
                continue
            if name[:-3] not in tools:
                problems.append(f"{rel(os.path.join(mock_dir, name))}: no tool {name[:-3]!r} in _tools.json")
    for case in sorted(os.listdir(evals)):
        path = os.path.join(evals, case)
        if case in ("mocks", "results") or not os.path.isdir(path):
            continue
        has_prompt = os.path.isfile(os.path.join(path, "prompt.md"))
        case_yaml = os.path.join(path, "case.yaml")
        if not has_prompt and not os.path.isfile(case_yaml):
            problems.append(f"{rel(path)}: neither prompt.md nor case.yaml")
            continue
        graders = os.path.join(path, "graders")
        if not (os.path.isdir(graders) and any(n.endswith(".md") for n in os.listdir(graders))):
            problems.append(f"{rel(path)}: no grader")
        for name in sorted(os.listdir(graders)) if os.path.isdir(graders) else []:
            if name.endswith(".md"):
                arm = (frontmatter(os.path.join(graders, name))[0] or {}).get("arm")
                if arm not in (None, "both", "with-only"):
                    problems.append(f"{rel(os.path.join(graders, name))}: arm {arm!r} (both or with-only)")
        guard = os.path.join(graders, "no-push.md")
        if not os.path.isfile(guard):
            problems.append(f"{rel(path)}: no push guard (graders/no-push.md)")
        else:
            fields, _ = frontmatter(guard)
            if (fields or {}).get("input_match") != "'" + PUSH_GUARD + "'" or (fields or {}).get("max") != "0":
                problems.append(f"{rel(guard)}: not the push guard (PUSH_GUARD, max: 0)")
        if os.path.isfile(case_yaml):
            with open(case_yaml, encoding="utf-8") as f:
                m = re.search(r"scaffold_script:\s*(\S+)", f.read())
            if m:
                script = os.path.join(path, m.group(1))
                if not os.path.isfile(script) or not os.access(script, os.X_OK):
                    problems.append(f"{rel(path)}: scaffold {m.group(1)} missing or not executable")

# The push guard catches each push and nothing else, as the eval reads a
# tool input: its JSON.
guard = re.compile(PUSH_GUARD)
for command in PUSHES:
    if not guard.search(json.dumps({"command": command, "description": "x"})):
        problems.append(f"PUSH_GUARD misses {command!r}")
for command in NOT_PUSHES:
    if guard.search(json.dumps({"command": command, "description": "Check git push state"})):
        problems.append(f"PUSH_GUARD matches {command!r}")

# One version in both manifests.
versions = {}
for manifest in (".claude-plugin/plugin.json", ".codex-plugin/plugin.json"):
    for plugin in sorted(os.listdir(os.path.join(ROOT, "plugins"))):
        path = os.path.join(ROOT, "plugins", plugin, manifest)
        if os.path.isfile(path):
            with open(path, encoding="utf-8") as f:
                versions[rel(path)] = json.load(f).get("version")
if len(set(versions.values())) > 1:
    problems.append(f"manifest versions differ: {versions}")

for p in problems:
    print("FAIL", p)
print(f"check_repo: {len(problems)} problem(s)")
sys.exit(1 if problems else 0)
