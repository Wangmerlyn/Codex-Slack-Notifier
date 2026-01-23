# Integrating Other Coding Agents with the Slack Notifier

Many coding-agent CLIs expose hooks or plugin points that can run shell commands on lifecycle events. Point those hooks at `scripts/notifier/codex_notify_wrapper.sh` (or `slack_notify.py` directly) to deliver Slack DMs when long tasks finish.

## General pattern
- Ensure `SLACK_BOT_TOKEN` and `SLACK_USER_ID` are available (via `.env` or exported env vars).
- Use the wrapper for robustness across stdin/file/inline payloads:
  ```
  /path/to/Codex-Slack-Notifier/scripts/notifier/codex_notify_wrapper.sh
  ```
- Optionally capture the payload for debugging:
  ```
  DEBUG_CODEX_PAYLOAD=/tmp/codex_payload.json
  ```
- If your tool provides a payload file path, pass it as the first argument; if it pipes JSON, no args are needed.

## Claude Code
- Supports a hook system; add a hook on events like `Stop` / `SessionEnd`.
- Example `.claude/settings.json` snippet:
  ```json
  {
    "hooks": {
      "Stop": [
        {
          "matcher": "*",
          "hooks": [
            { "type": "command", "command": "/path/to/Codex-Slack-Notifier/scripts/notifier/codex_notify_wrapper.sh" }
          ]
        }
      ]
    }
  }
  ```
  See `docs/examples/claude/settings.json`.

## Gemini CLI
- Similar hook support; configure in `.gemini/settings.json`.
  ```json
  {
    "hooks": {
      "Stop": [
        {
          "type": "command",
          "command": "/path/to/Codex-Slack-Notifier/scripts/notifier/codex_notify_wrapper.sh"
        }
      ]
    }
  }
  ```
  See `docs/examples/gemini/hooks.json`.

## OpenCode
- Use its plugin/hook extensibility to invoke the notifier on relevant events (e.g., session complete).
- Skeleton plugin example (`.opencode/plugins/slackNotifier.js`):
  ```js
  import { exec } from "node:child_process";

  export const SlackNotifierPlugin = async () => ({
    event: async ({ event }) => {
      if (event?.type === "session.idle") {
        exec("/path/to/Codex-Slack-Notifier/scripts/notifier/codex_notify_wrapper.sh");
      }
    },
  });
  ```
  See `docs/examples/opencode/slackNotifier.js`.

## Copilot CLI & Cursor
- No native hooks today. Workaround: wrap the CLI call and invoke the notifier afterward:
  ```bash
  copilot "$@"
  /path/to/Codex-Slack-Notifier/scripts/notifier/codex_notify_wrapper.sh
  ```
  See `docs/examples/copilot_wrapper.sh` for a minimal wrapper.

## Tips
- Keep the notify command short and use absolute paths.
- If the tool supplies a payload file path as `$1`, the wrapper will read it; if not, it reads stdin or inline JSON.
- Set `LOGLEVEL=WARNING` (or use `--log-level WARNING`) when calling `slack_notify.py` directly to avoid chatty stdout/stderr in host tools.
