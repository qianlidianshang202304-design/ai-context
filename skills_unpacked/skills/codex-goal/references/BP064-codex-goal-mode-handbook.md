# BP064 - Codex Goal Mode Handbook

## Status

stable

## Role

Reusable contract for shaping, launching, steering, and closing Codex Goal mode tasks. Use it when the user asks how to use Goal mode, asks to draft a `/goal`, wants a long-running Codex task contract, or wants a workflow converted into a persistent Goal.

This BP is not a new first-class skill. It lives under `best-practices` because Goal mode is a repeatable execution contract, not a standalone capability entry.

## Trigger

Use this BP when any of these appear:

- User mentions Codex Goal mode, `/goal`, pursue goal, long-running Codex task, goal contract, or persistent objective.
- User wants to turn a fuzzy task into a Goal-ready prompt.
- User wants best practices, examples, or guardrails for multi-step Codex work.
- User asks to run or design a long task that needs repeated validation, pause/resume, or clear completion criteria.

Do not use it for:

- One-sentence Q&A.
- Single-file tiny edits.
- Open-ended brainstorming where the direction is still subjective.
- Tasks that need frequent human aesthetic or strategic decisions before execution.

## Input Contract

Required:

- Desired outcome.
- Scope: files, folders, artifacts, or domains in bounds and out of bounds.
- Completion criteria: tests, evidence table, benchmark, screenshot, review gate, or human acceptance.
- Constraints: architecture, style, safety, budget, time, platform, no-touch areas.

Conditional:

- External memory target for long tasks: cockpit, notes, PLAN, EXPERIMENTS, or equivalent.
- Stop conditions: permissions, spend, public actions, uncertain facts, repeated blockers, or decisions that require 余一.
- Source labels when examples are used: official fact, community sample, community risk feedback, AI余一 product judgment.

Missing handling:

- If the outcome or completion criteria are fuzzy, start with `/plan` or interview the user before drafting the Goal.
- If a stop condition is missing for a risky task, add one conservatively.
- If the task is too broad, split it into sequential Goals.

## Operating Chain

| Step | Action                | Output                                  | Pass Standard                                                   | Failure Fallback                                      |
| ---- | --------------------- | --------------------------------------- | --------------------------------------------------------------- | ----------------------------------------------------- |
| 1    | Suitability check     | Open Goal / do normal task / plan first | Goal only used for long, verifiable work                        | Use ordinary prompt or `/plan`                        |
| 2    | Contract shaping      | Goal five-piece                         | Target, scope, constraints, completion, stop conditions present | Ask up to 3 clarifying questions or draft assumptions |
| 3    | Feedback loop design  | Verification surface                    | Tests, evidence, benchmark, screenshot, or review gate named    | Create a small proxy eval before long run             |
| 4    | External memory setup | Memory target                           | Long tasks have cockpit/notes/PLAN/EXPERIMENTS target           | Require periodic summaries after compaction           |
| 5    | Goal draft            | Copyable `/goal` text                   | Codex can tell whether it has succeeded                         | Rewrite vague verbs into measurable outcomes          |
| 6    | Runtime steering      | Follow-up rules                         | Local steering does not erase the completion contract           | Pause/edit Goal if completion criteria change         |
| 7    | Closure audit         | Completion summary                      | Diff/evidence/tests/risks/remaining work checked                | Do not mark complete; report blocked or partial       |

## Goal Five-Piece

```text
/goal 在 [范围] 内完成 [具体结果]。
必须用 [测试/截图/证据表/benchmark/人工验收] 证明完成。
保持 [约束：不要动哪些文件、风格、兼容性、安全边界]。
执行中把计划、尝试、失败原因和剩余风险记录到 [外部记忆文件/驾驶舱]。
如果遇到 [权限/费用/事实不可验证/连续 3 次同 blocker/需要余一判断]，暂停并输出决策清单。
完成前自审：diff、测试、未完成项、风险、下一步。
```

## Scenario Templates

### Research audit

```text
/goal 完成这篇 AI 产品研究稿的 claim audit。
输出 claim inventory、证据链接、confirmed/support-only/blocked/uncertain 四类表；
不可验证事实暂停，不要硬写结论。
```

### Content production

```text
/goal 基于指定速记完成活动成文初稿。
必须保留嘉宾真实观点，先做素材映射再写稿；
完成前检查事实、标题、导语、金句和余一文风。
```

### System sedimentation

```text
/goal 把本轮成功 workflow 沉淀为 skill/BP/rule 草案。
必须包含触发条件、输入、流程、验收、反例、维护边界；
涉及系统文件修改前暂停。
```

### Engineering repair

```text
/goal 修复 [问题]，保持外部行为不变。
先建立最小复现或失败测试；修复后运行 [测试/类型检查/回归检查]；
若发现接口语义变化或需要大范围重构，暂停并给出方案。
```

### Night guardian

```text
/goal 在夜间窗口静默完成 [任务]。
详细结果写入 meta/异步沟通.md 的需要余一反馈区；
三类红灯写入需要余一决策区；
前台最终只保留休息提醒。
```

## Evidence Labels

When using examples, label their status:

- `[官方事实]`: documented OpenAI behavior or official cookbook example.
- `[社区个案]`: one user's reported practice; useful but not consensus.
- `[社区风险反馈]`: observed failure mode or caution.
- `[AI余一产品判断]`: local design judgment derived from product/technical understanding.

Use "community experience sample" or "transferable practice" instead of overstating "community consensus" unless multiple independent sources establish the same pattern.

## Plain Language Layer

When the audience includes 余一 or external readers who need to **understand first, jargon second**:

- Opening metaphor: **Goal = 工单** — state what to deliver and how to verify completion.
- Each step needs **做什么** + **为什么**.
- Add a **术语白话翻译** block for English terms (blocker, evidence, spec, tunnel vision, budget, claim audit).
- Judgment shortcut: if you would repeatedly say 「继续，直到真的完成」→ open Goal; otherwise use normal chat.

Agent-facing SSOT stays in this BP064 file. `.yuyi/agents/codex-goal-mode-handbook.md` is only a compatibility pointer. Shareable HTML stays in `02aiyuyi/skill分享/codex-goal-mode-handbook.html`.

## Shareable Delivery

Trigger: user asks to share the handbook (`分享`, `给别人`, `HTML`, `看不懂`, `文字不清楚`).

| Layer                 | Path                                               | Use                                        |
| --------------------- | -------------------------------------------------- | ------------------------------------------ |
| Execution BP / SSOT   | this file                                          | Agent drafts Goals, guardrails, acceptance |
| Compatibility pointer | `.yuyi/agents/codex-goal-mode-handbook.md`         | Non-SSOT pointer back to BP064             |
| Share HTML            | `02aiyuyi/skill分享/codex-goal-mode-handbook.html` | Plain-language single file for humans      |

Share HTML hard gates (2026-06-10 余一反馈沉淀):

- Body **≥18px**, line-height **≥1.75**, system sans (`PingFang SC`), not Google Serif/Mono as primary.
- White card on paper background; do not rely on thin mono for Chinese body or code blocks.
- Do **not** default Bauhaus infocard style for long-form tutorial HTML; Bauhaus is for article illustrations and infocards.
- Must include: 何时开/不开对照、七步（做什么+为什么）、可复制模板、术语白话表、常见坑。
- No workspace-internal paths in share version (驾驶舱 / 异步沟通 / `.yuyi`).

Pass: 余一或第三方不放大能读完、能说出「Goal 是什么、何时用、怎么写」。

### PDF export（单页连续）

Script: `02aiyuyi/skill分享/export-handbook-pdf-3x4.py`

| 层         | 要求                                                                  |
| ---------- | --------------------------------------------------------------------- |
| `@page`    | `margin: 0` — 纸色铺满，不要打印机白边                                |
| 画布宽     | **750px**（3:4 宽边）                                                 |
| 内容内边距 | **`--margin-x: 48px`**、**`--margin-y: 44px`** — 页内呼吸，文字不贴边 |
| 分页       | 单页连续，高度随内容                                                  |
| 链接       | 目录锚点 + 官方外链须可点击                                           |

两层分开记：**零页边距 ≠ 零内边距**。

## Runtime Guardrails

| Risk                  | Default guardrail                                                        |
| --------------------- | ------------------------------------------------------------------------ |
| Repeated blocker      | Stop after 3 repeats and output a decision list                          |
| Token or budget drift | Pause, summarize, and ask whether to continue                            |
| Context compaction    | Write an external memory summary before continuing                       |
| Tunnel vision         | Periodically ask "is this still the shortest path to the goal?"          |
| Completion ambiguity  | Do not mark complete without evidence against the completion criteria    |
| Human decision needed | Pause instead of inventing product, spend, public, or protocol decisions |

## Acceptance

The Goal draft or Goal-mode guidance is acceptable only if:

- Codex can tell whether the task is complete.
- The verification surface is explicit.
- In-scope and out-of-scope boundaries are clear.
- Stop conditions cover permissions, spend, public actions, uncertain facts, and repeated blockers when relevant.
- Long tasks have an external memory target.
- Community examples are labeled as samples, not universal best practices.

## References

- [BP064 Shareable HTML](../../../../../02aiyuyi/skill分享/codex-goal-mode-handbook.html) — 白话分享版
- [.yuyi/agents/codex-goal-mode-handbook.md](../../../../agents/codex-goal-mode-handbook.md) — 非 SSOT 兼容指针
- [codex-runtime-adapter.md](../../../../agents/codex-runtime-adapter.md) — Codex 短规则入口
- [2026-06-10 链接收集](../../../../../05外部资料/链接收集/2026-06-10.md)
- [Codex Goal Mode 驾驶舱](../../../../../02aiyuyi/dialogue-records/2026-06-10_codex-goal-mode-practices.md)
- [案例池：分享用手册 HTML 白话版](../../../../../02aiyuyi/案例池/2026-06-10-分享用手册HTML白话版.md)
