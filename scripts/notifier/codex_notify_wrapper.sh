#!/usr/bin/env bash
set -euo pipefail

# Accept payload either via a file path argument ($1) or stdin.
src="${1:-/dev/stdin}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="${ENV_FILE:-"$SCRIPT_DIR/../../.env"}"

# If DEBUG_CODEX_PAYLOAD is set to a filepath, the selected payload will be written there.
filter_and_forward() {
  python3 - "$src" <<'PY'
import json, sys, pathlib, os

source = sys.argv[1]
debug_path = os.environ.get("DEBUG_CODEX_PAYLOAD")

def read_lines():
    if source != "/dev/stdin" and pathlib.Path(source).exists():
        return pathlib.Path(source).read_text(encoding="utf-8", errors="ignore").splitlines()
    return sys.stdin.read().splitlines()

def is_relevant(obj: dict) -> bool:
    keys = {"status", "state", "title", "event", "task", "summary", "message", "details"}
    return any(k in obj for k in keys)

last_valid = None
last_relevant = None

for line in read_lines():
    clean = line.replace("\x00", "").strip()
    if not clean:
        continue
    try:
        obj = json.loads(clean)
    except json.JSONDecodeError:
        continue
    last_valid = obj
    if isinstance(obj, dict) and is_relevant(obj):
        last_relevant = obj

chosen = last_relevant or last_valid
if chosen is None:
    sys.exit(0)

out = json.dumps(chosen)
if debug_path:
    pathlib.Path(debug_path).write_text(out + "\n", encoding="utf-8")
sys.stdout.write(out)
PY
}

if ! filter_and_forward | python3 "$SCRIPT_DIR/slack_notify.py" --env-file "$ENV_FILE"; then
  echo "Notifier failed to send message" >&2
  exit 1
fi
