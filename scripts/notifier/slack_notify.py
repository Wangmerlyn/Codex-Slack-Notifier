#!/usr/bin/env python
"""CLI entrypoint for sending Codex notifications as Slack DMs."""

from codex_slack_notifier.notifier import main


if __name__ == "__main__":
    raise SystemExit(main())
