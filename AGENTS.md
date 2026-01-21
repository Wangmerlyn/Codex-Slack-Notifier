# Repository Guidelines

## Project Purpose & Layout
- Goal: A convenienent entry point for coding agent to send the user the message of task completion through slack.

## Repository Structure (Modify this part when you have learned enough about this repository)
- `scripts/notifier/`: Slack notifier CLI and example Codex notify script.
- `src/codex_slack_notifier/`: Python package with notifier logic.
- `tests/notifier/`: Pytest suite covering notifier behavior.
- `docs/`: Usage and setup documentation.
- `pyproject.toml`: Project metadata and dependencies.

## Environment & Tooling
- Python: 3.12+.
- Dev env: `conda activate codex_slack_notifier`; install deps via `pip install -e .[dev]`.
- Hooks: run `pre-commit install` in the same env.
- Lint/format: `ruff check .` (CI also runs ruff).

## Tests
- Docs submodule tests are excluded via `norecursedirs`.

## Workflow
- Branching: new feature/fix -> new branch (e.g., `feature/<name>`); avoid working on main.
- Commit cadence: commit after each logical change; keep commits small and focused.
- Push policy: only push when the user explicitly approves; otherwise let the user push.
- PR titles: format `[modules] type: description` (modules comma-separated, single type).

## Coding Style
- Keep it “Linus” simple—concise, readable, and robust; avoid bloat/over-engineering.
- Review with a critical eye for clarity and correctness.
