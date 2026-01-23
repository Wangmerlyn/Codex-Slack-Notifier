import { exec } from "node:child_process";

export const SlackNotifierPlugin = () => ({
  event: ({ event }) => {
    if (event?.type === "session.idle") {
      exec("/path/to/Codex-Slack-Notifier/scripts/notifier/codex_notify_wrapper.sh", (error) => {
        if (error) {
          console.error(`Slack notifier script failed: ${error.message}`);
        }
      });
    }
  },
});
