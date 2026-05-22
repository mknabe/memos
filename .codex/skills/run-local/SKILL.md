---
name: run-local
description: Start this Memos repository locally for development and open it in the Codex in-app browser. Use when the user asks to run, start, preview, test locally, open localhost:5230, rebuild the frontend, or verify UI changes in the local Memos app.
---

# Run Local

## Workflow

1. Work from the repository root.
2. Run `scripts/run-local.sh` from this skill directory.
3. Keep the server session running.
4. Open or reload `http://localhost:5230` in the Codex in-app browser using the Browser skill.

The script:

- Activates `nvm` Node 24 when available.
- Runs `pnpm install` when `web/node_modules` is missing.
- Runs `pnpm release` to build the frontend into `server/router/frontend/dist`.
- Starts `go run ./cmd/memos --data ./dev-data --port 5230`.

## Commands

From the repo root:

```bash
.codex/skills/run-local/scripts/run-local.sh
```

Use a different port when `5230` is already occupied:

```bash
.codex/skills/run-local/scripts/run-local.sh --port 5231
```

Skip the frontend rebuild only when the existing embedded frontend is already current:

```bash
.codex/skills/run-local/scripts/run-local.sh --skip-build
```

## Browser

After the server prints that Memos started, use the Codex in-app browser and navigate to:

```text
http://localhost:5230
```

If the browser is already open on that URL, reload after rebuilding or restarting the app.
