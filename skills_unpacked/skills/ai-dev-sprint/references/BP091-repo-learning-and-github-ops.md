# BP091 - Repo learning and GitHub operations

## Status

candidate

## Role

Learn from a GitHub repository or operate a repo without reducing the task to “summary” or “install”. The default output is a transferable learning package: what the repo does, how it works, what can be reused, and one small verified experiment.

Use when:

- 用户说“去 GitHub 学习这个项目 / 仓库 / skill”。
- 用户想借鉴一个 repo 做自己的 demo 或原型。
- Need to inspect, run, patch, test, fork, or prepare GitHub operations.

Do not use when:

- The user only asks a factual question about a repo; use `dev/repo-inspect`.
- The task is only deployment of an already-built local demo; use BP092.
- The repo has no reachable code or docs; produce a blocked note instead of inventing.

## Input Contract

Required:

- Target repo URL or local repo path.
- Learning goal: what capability the user wants to borrow.
- Output shape: learning pack, local experiment, PR/fork operation, or timeboxed demo.
- Stop condition: timebox, permissions, or “minimum useful learning”.

Optional:

- Target project where the learned pattern may be applied.
- Preferred language/framework.
- Whether installation is allowed.

Missing handling:

- If learning goal is vague, default to “extract one reusable capability and prove it with a minimal experiment”.
- If install is blocked, inspect source and examples, then mark experiment as not run.
- If GitHub auth or fork/push is needed, stop before irreversible operations.

## GitHub Learning Package

Formal learning output must include:

1. **Repo map**: README, package/config, source entry, examples, scripts, tests, demo path.
2. **Capability extraction matrix**: what capability exists, where it lives, what dependencies it needs, what is transferable.
3. **Implementation entry mapping**: files/functions/components that matter, with file references.
4. **Minimal experiment**: run an example, change one reversible behavior, or reproduce a tiny slice locally.
5. **Transfer card**: how to apply the learned pattern to the user’s current project or prototype build.
6. **Risk and license note**: unverified assumptions, maintenance status, license/public-use constraints when visible.

Not enough:

- “这个 repo 主要做了 X” summary.
- Star count or README paraphrase only.
- Installation log with no capability extraction.
- Copying code without explaining why it transfers.

## Operating Chain

| Step | Atom / Action                            | Output                    | Pass Standard                            | Failure Fallback                                |
| ---- | ---------------------------------------- | ------------------------- | ---------------------------------------- | ----------------------------------------------- |
| 1    | Source orientation                       | repo map                  | Entry points located                     | If remote unavailable, use provided files only  |
| 2    | `dev/repo-inspect`                       | code evidence             | Claims tied to files                     | Narrow to one subsystem                         |
| 3    | Capability extraction                    | matrix                    | Capability separable from repo branding  | Mark non-transferable dependencies              |
| 4    | Minimal experiment                       | run/change/reproduce note | Evidence exists                          | If cannot run, create read-only experiment plan |
| 5    | `dev/test-run` or `dev/local-run-verify` | verification note         | Command or manual check recorded         | Mark blocked with reason                        |
| 6    | Transfer card                            | next implementation step  | User can use it without rereading repo   | Cut to one pattern                              |
| 7    | GitHub operation if needed               | fork/branch/PR/issue note | User approved irreversible/public action | Stop before push/public action                  |

- 10 min repo map.
- 10 min capability extraction.
- 15 min minimal experiment or read-only reproduction plan.
- 5 min transfer card.

The participant’s demo can be the transfer card plus a tiny local reproduction if full integration is too large.

## GitHub Operation Guardrails

- Check `git status --short` before edits.
- Do not push, fork public, open PR, publish issues, or change repo visibility without explicit approval.
- Do not commit secrets or generated credentials.
- Respect license and public/private boundaries.
- Prefer non-destructive commands and scoped patches.

## Evaluation

- 忠实：不伪造 repo behavior, install state, or GitHub permissions.
- 可迁移：输出说明离开该 repo 仍然有用的能力。
- 可验证：至少一个 source reference or experiment supports the conclusion.
- 可执行：transfer card can feed BP092 or a prototype build.

## Acceptance

- Repo map exists.
- Capability extraction matrix exists.
- At least one implementation entry is linked to source evidence.
- Minimal experiment either ran or has a concrete blocked reason.
- Transfer card names one next action for the user’s project.
- Any GitHub operation requiring auth/public action is either approved or stopped.

## Called By

- BP092 AI build and deploy.
- Dev atoms for repo inspection, test, CI, PR review.
