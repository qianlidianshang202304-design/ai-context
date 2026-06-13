# BP092 - AI build and deploy

## Status

candidate

## Role

Build, verify, and lightly deploy small AI-assisted prototypes during fast product experiments or timeboxed builds.

Use this BP when a task asks:

- 做一个可运行 demo / 网页 / 小工具。
- 帮我开发并部署。
- 把本地 demo 发成一个可访问链接。

Do not use it for:

- Large production systems with security, data migration, payments, or compliance risk.
- Pure GitHub learning with no build/deploy output; route to BP091.
- HTML PPT decks; route to BP031 unless the deck itself is embedded in an app.

## Input Contract

Required:

- Demo goal and user flow.
- Runtime: static HTML, React/Vite, Next.js, Python app, or unknown.
- Output directory.
- Verification surface: browser screenshot, local command, smoke test, or user walkthrough.

Conditional:

- Deployment target: local only, Vercel, GitHub Pages, static file, or existing hosting.
- Account/permission status for deployment.
- Public/private boundary.

Missing handling:

- If deployment target is unknown, default to local runnable demo and a deployment plan.
- If public deployment needs login, token, payment, domain, or irreversible public action, stop and ask.

## Operating Chain

| Step | Atom / Action                        | Output                                     | Pass Standard                                | Failure Fallback                        |
| ---- | ------------------------------------ | ------------------------------------------ | -------------------------------------------- | --------------------------------------- |
| 1    | `dev/repo-inspect` or project intake | Existing structure or blank-start decision | Uses local evidence                          | Blank static demo if no repo            |
| 2    | `dev/build-plan`                     | Minimal build plan                         | Scope fits timebox                           | Cut to one user flow                    |
| 3    | Implement                            | Code or static artifact                    | Runs locally                                 | Reduce framework complexity             |
| 4    | `dev/local-run-verify`               | Local verification note                    | Command/browser evidence exists              | Manual open-file check for static HTML  |
| 5    | Deploy decision                      | local / static / Vercel / GitHub Pages     | Permission and public boundary clear         | Keep local and produce deploy checklist |
| 6    | Deploy if safe                       | URL or deployment record                   | No secret committed, no paid/public surprise | Stop before risky action                |
| 7    | Handoff                              | Open path, test result, next step          | Participant can demo without agent context   | Write fallback demo script              |

## Build Defaults

- Prefer the simplest runtime that can demonstrate the core flow.
- Static HTML is acceptable for quick demos when interactivity is small.
- React/Vite is acceptable for richer interaction.
- Next.js is acceptable only when the repo already uses it or deployment needs it.
- Do not add auth, database, payments, or complex backend unless it is the core demo.

## Deployment Guardrails

- Never hardcode secrets.
- Do not publish publicly without explicit user approval.
- Do not buy domains, enable paid services, or change production settings.
- If using Vercel/GitHub Pages, verify account state and target repo before pushing.
- If deployment is blocked, deliver local runnable instructions and a deploy checklist.

## Acceptance

- The demo runs locally or the blocked reason is explicit.
- The user knows exactly how to open it.
- Verification evidence exists: command output, browser check, screenshot, or manual walkthrough.
- Public deployment, if done, has explicit permission and no secret leakage.
- Handoff includes next best 72-hour action.

## Called By

- BP091 when repo learning produces a prototype.
- Dev atoms when a small deployment plan is enough.
