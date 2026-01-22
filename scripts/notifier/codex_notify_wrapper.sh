#!/usr/bin/env bash
set -euo pipefail

# Accept payload either via a file path argument ($1) or stdin.
src="${1:-/dev/stdin}"

# If $1 is a readable file, prefer that; otherwise fall back to stdin.
if [[ -n "${1:-}" && -f "$src" ]]; then
  cat "$src"
else
  cat
fi | tee ~/codex_payload.json \
  | python3 /home/wsy0227/Codex-Slack-Notifier/scripts/notifier/slack_notify.py --env-file /home/wsy0227/Codex-Slack-Notifier/.env
