#!/usr/bin/env bash
set -euo pipefail

copilot "$@"
/path/to/Codex-Slack-Notifier/scripts/notifier/codex_notify_wrapper.sh
