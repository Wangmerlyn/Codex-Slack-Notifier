#!/usr/bin/env bash
set -euo pipefail

# Accept payload either via a file path argument ($1) or stdin.
src="${1:-/dev/stdin}"

# Select the most relevant JSON payload (prefer lines with task keys) and write only that
# to the debug file, then forward it to the notifier.
filter_and_forward() {
  python3 - "$src" <<'PY'
import json, sys, pathlib

source = sys.argv[1]
lines: list[str]
if source != "/dev/stdin" and pathlib.Path(source).exists():
    content = pathlib.Path(source).read_text(encoding="utf-8", errors="ignore")
    lines = content.splitlines()
else:
    content = sys.stdin.read()
    lines = content.splitlines()

def is_relevant(obj: dict) -> bool:
    keys = {"status", "state", "title", "event", "task", "summary", "message", "details"}
    return any(k in obj for k in keys)

last_valid = None
last_relevant = None

for line in lines:
    clean = line.replace("\x00", "").strip()
    if not clean:
        continue
    try:
        obj = json.loads(clean)
    except Exception:
        continue
    last_valid = obj
    if isinstance(obj, dict) and is_relevant(obj):
        last_relevant = obj

chosen = last_relevant or last_valid

if chosen is None:
    sys.exit(0)

out = json.dumps(chosen)
pathlib.Path("/home/wsy0227/codex_payload.json").write_text(out + "\n", encoding="utf-8")
sys.stdout.write(out)
PY
}

filter_and_forward | python3 /home/wsy0227/Codex-Slack-Notifier/scripts/notifier/slack_notify.py --env-file /home/wsy0227/Codex-Slack-Notifier/.env
