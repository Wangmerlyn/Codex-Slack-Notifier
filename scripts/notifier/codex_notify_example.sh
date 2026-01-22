#!/usr/bin/env bash
# Example: configure Codex to call the Slack notifier after tasks complete.
#
# Replace U12345678 with your Slack User ID and adjust the path to this repository.
# Then register the command with Codex:
#   codex config set notify "/home/you/Codex-Slack-Notifier/scripts/notifier/slack_notify.py --user-id U12345678"

python /home/you/Codex-Slack-Notifier/scripts/notifier/slack_notify.py --user-id U12345678 <<'JSON'
{
  "status": "success",
  "title": "Sample Codex run",
  "summary": "Replace this payload with the one Codex supplies."
}
JSON
