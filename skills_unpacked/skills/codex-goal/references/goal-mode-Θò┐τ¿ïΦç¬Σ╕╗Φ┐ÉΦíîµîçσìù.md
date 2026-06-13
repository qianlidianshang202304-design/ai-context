# Goal 模式长程自主运行指南

> 综合来源:Claude Code 官方 `/goal` 文档、OpenAI Codex "Using Goals in Codex" cookbook(全文,自 openai/openai-cookbook 仓库 `examples/codex/using_goals_in_codex.ipynb` 提取)、三份 deep research 报告(gemini / kimi / openai)。
> 日期:2026-06-10

---

## 1. Goal 模式的本质:从"单轮 prompt"到"目标条件闭环"

两家的设计殊途同归:**把"完成"从自然语言描述变成机器可校验的条件,由一个独立的评估环节决定是否继续跑下一轮**。

### Claude Code `/goal`(需 v2.1.139+)

- 你设定一个完成条件(最长 4000 字符),Claude 每个 turn 结束后,由一个**小型快速模型(evaluator)**检查条件是否满足。
- 不满足 → 自动开始下一个 turn(不把控制权还给你);满足 → goal 自动清除。
- **关键机制限制**:evaluator 只读对话 transcript,**不会自己跑命令、不会自己读文件**。所以条件必须写成"Claude 自己的输出能证明"的形式 —— `npm test` 退出码 0 这种,因为测试结果会落在 transcript 里。
- `/goal` 不带参数 → 查看状态(条件、已运行时长、已评估轮数、token 消耗);`/goal clear` → 手动清除。
- 依赖 hooks 系统:工作区必须通过 trust 对话框;`disableAllHooks` 或 `allowManagedHooksOnly` 设置会禁用它。

### Codex Goal(Codex ≥ 0.128.0)

- Goal 是 **thread 级持久目标(persistent objective)**:定义"什么应该为真、如何验证成功、哪些约束不能破坏"。
- 官方定位:"**不是无边界的后台自主,而是一个有范围、用户可控的完成契约(completion contract)**"。
- 命令面(cookbook 一手确认):

```text
/goal <outcome>   设置 Goal
/goal             查看当前 Goal
/goal pause       暂停
/goal resume      恢复
/goal clear       移除
```

- 状态机:**active / paused / complete / budget-limited** 四态,决定 Codex 是继续、等待用户,还是只总结进度不开新工作。
- **Continuation 是事件驱动,不是简单循环**:只在"安全边界"检查是否继续——turn 已结束、无 pending 工作、无排队的用户输入、thread 空闲。设计上刻意保守:
  - plan-only 的 turn 不触发 continuation;
  - 用户打断 → goal 自动 pause,resume thread 时可恢复目标;
  - 若某次 continuation turn 没有任何工具调用,下一次自动继续会被**抑制**(防空转 spin)。
- **权限不对称**:模型只能 start goal、以及在证据支持时 mark complete;pause / resume / clear / budget-limited 转换归用户或系统控制。
- **预算到达 ≠ 完成**:budget 用尽时 Codex 应停止实质工作,总结进度与 blocker,给出下一个有用步骤。(报告补充:`budget_limit.md` prompt 要求优雅退出;`continuation.md` 每轮注入 `{{ tokens_used }}` / `{{ token_budget }}`)
- 完成前强制 audit:continuation prompt 要求把目标与具体证据对照——改了哪些文件、跑了哪些命令、测试/基准输出、产物。

两种模式的心智模型(cookbook 原文):

```text
Prompt:  ask -> work -> result -> wait
Goal:    work -> check -> continue or complete
```

### 共同核心

适用任务的判别标准:**"下一步取决于过程中学到什么"**(profiling、修 flaky test、迁移、基准测试、证据型调研)——这类任务不需要更大的 prompt,需要的是持久目标。而且只有"done"**外部可检查**时,agent 才变得可靠。

---

## 2. 持续运行机制全景对比

### Claude Code 三种"让会话持续跑"的方式(官方对比表)

| 方式 | 下一轮何时开始 | 何时停止 |
|---|---|---|
| `/goal` | 上一轮结束后立即 | 评估模型确认条件满足 |
| `/loop` | 时间间隔到达 | 你手动停,或 Claude 判断完成 |
| Stop hook | 上一轮结束后立即 | 你自己的脚本/prompt 决定 |

**极重要的澄清(官方文档明确)**:auto mode ≠ 长程自主。auto mode 只是减少一个 turn 内的权限提示,**它本身不会启动下一个 turn**。跨轮持续性来自 `/goal`、`/loop` 或 Stop hook。所以长程自主 = **持续性机制(goal)+ 无人值守机制(auto mode / 权限配置)** 两者叠加。

### Codex 侧机制矩阵

| 机制 | 触发下一轮 | 停止条件 | 跨重启 | 适用 |
|---|---|---|---|---|
| Goal mode | thread 持续朝目标推进 | 用户 pause/clear,或 Codex 判定停止条件满足 | thread 持久化,支持 pause/resume | 长程本地/云端编码任务 |
| `codex exec`(非交互) | 单次调用跑到结束 | 进程退出 | `codex exec resume --last` | CI、脚本化修复循环、批处理 |
| App automations | 定时调度 / heartbeat | 移除调度 | 是 | 重复性无人值守任务(比 thread 级 goal 更适合) |
| Worktrees | 手动/自动 | — | 是 | 并行隔离 |

注:报告确认 Codex **没有**公开的 `/loop` 或 Stop hook 等价物,其自动化主线是 Goal mode + automations + `codex exec` + GitHub Action。

---

## 3. 怎么写出能撑住长程运行的 Goal

### 六字段骨架(OpenAI cookbook 官方推荐,Claude 文档从评估侧印证)

1. **Outcome(终态)** —— 工作完成时什么应该为真
2. **Verification Surface(验证面)** —— 证明它的测试/基准/报告/产物/命令输出/源材料
3. **Constraints(约束)** —— 过程中什么不能回归/破坏
4. **Boundaries(边界)** —— 允许用哪些文件/工具/数据/仓库/资源
5. **Iteration Policy(迭代策略)** —— 每次尝试后如何决定下一步试什么
6. **Blocked Stop Condition(受阻停止条件)** —— 在当前限制下无可辩护路径时,何时停止并报告

生产化再加三个:**Budget(预算)、Reporting(每轮记录)、Rollback(回滚预案)**。

### 官方一句话模式(cookbook 原文,可直接套)

```text
/goal <desired end state> verified by <specific evidence> while preserving <constraints>.
Use <allowed inputs, tools, or boundaries>.
Between iterations, <how Codex should choose the next best action>.
If blocked or no valid paths remain, <what Codex should report and what would unlock progress>.
```

官方完整示例(性能调优,薄版 → 完整操作契约):

```text
# 薄版(workable but thin)
/goal Reduce p95 checkout latency below 120 ms without regressing correctness tests

# 强版
/goal Reduce p95 checkout latency below 120 ms, verified by the checkout benchmark,
while keeping the correctness suite green. Use only the checkout service, benchmark
fixtures, and related tests. Between iterations, record what changed, what the
benchmark showed, and the next best experiment to try. If the benchmark cannot run
or no valid paths remain, stop with the attempted paths, the evidence gathered,
the blocker, and the next input needed.
```

强版给了 Codex"知道何时**不该**停"的依据:p95 从 180ms 降到 135ms → 没完;延迟达标但正确性测试挂了 → 没完;基准跑不起来 → 必须上报 blocker 而不是宣告成功。

### 粒度判断(cookbook 原则)

Goal 要"**窄到可审计,宽到允许 Codex 自选下一步**":
- 太窄:"Fix the failing checkout test"——真因可能在上游依赖;
- 太宽:"Improve the whole system"——没有审计面;
- 合适:"Make the checkout test suite pass on the current branch without changing public API behavior"。

### 让 Codex 帮你写 Goal(官方两步法)

任务清楚但 Goal 不会写时:① 用白话描述工作,让 Codex 起草 Goal;② review 草稿,收紧成功条件、验证面、约束和受阻停止条件后再激活。

```text
Help me turn this into a strong `/goal`: I want Codex to keep working on this
flaky checkout test until we either fix it with evidence or can clearly explain
what is blocking progress.
```

### Claude 官方"有效条件"三要素

- **一个可测量的终态**:测试结果、build 退出码、文件数、空队列
- **一个声明的检查方法**:"`npm test` exits 0"、"`git status` is clean"
- **重要约束**:"过程中不得修改其他测试文件"

### 短模板(直接可用)

```text
Goal: [终态]。
Success is proven by: [命令/测试/产物/指标]。
Constraints: [不能回归什么]。
Boundaries: [允许的文件、工具、系统]。
If blocked: [何时停止并报告]。
Budget: [最大轮数 / 最大时间 / 最大范围]。
```

### 中模板(10 维,适合 3-10 文件的中等任务)

```markdown
## Goal: [一句话目标]

### Outcome
[精确终态,含量化指标,如 P99 < 100ms]

### Verification Surface
1. 单元测试: `pytest tests/... -v` 全部通过(覆盖率 > 90%)
2. 集成测试: `pytest tests/integration/... -v` 全部通过
3. 性能验证: `k6 run ...` 输出 P99 < 100ms
4. 手动检查: [Swagger/界面验证项]

### Constraints
- P0: 现有 [xxx] 行为完全不变
- 类型检查零错误

### Boundaries
ALLOWED: [明确文件清单,标注"新增/仅新增字段"]
FORBIDDEN: [目录、模型文件、"删除任何现有端点或测试"]

### Iteration Policy
- 同类错误最多重试 3 次
- 性能不达标: 先查询优化 → 再缓存 → 最后允许分页降级
- 连续 2 轮约束被破坏 → STOP 并报告

### Stop/Blocked Condition
- [CRITICAL] 现有测试失败且 2 轮内无法修复 → STOP
- [HIGH] 性能连续 3 轮不达标 → STOP,报告瓶颈分析
- [MEDIUM] 超出 10 轮预算 → STOP,报告进展

### Budget
- 轮数 ≤ 10 | 时间 ≤ 45min | Token ≤ 150K in + 80K out | 变更 ≤ 6 文件 / 250 行

### Reporting
每轮: `[Round N] 动作: {X} | 验证: {通过/失败} | 变更: {文件:行范围}`

### Rollback Plan
触发: 约束被破坏 → git revert 到最近绿色 commit
```

### Goal Discovery:8 个问题"聊出"好 Goal(kimi 报告)

| # | 问题 | 字段 | 优先级 |
|---|---|---|---|
| 1 | 完成后期望看到什么具体变化?看哪个指标确认? | success_criteria | P0 |
| 2 | 任务边界在哪?范围之外什么不做? | scope | P0 |
| 3 | 判断"好/足够好"的标准?现在数值多少,期望多少? | acceptance_criteria | P0 |
| 4 | 最大时间/资源预算? | budget | P1 |
| 5 | 已有哪些上下文可复用(日志/代码/文档)? | context | P1 |
| 6 | 首次尝试失败的备选方向?(长程任务首轮成功率 < 40%) | fallback_strategy | P2 |
| 7 | 产出物格式?交付给谁? | deliverable | P1 |
| 8 | 安全红线?(必须硬编码进 Goal,不能依赖 agent"常识") | constraints | P1 |

### 弱 Goal vs 强 Goal

- 弱:"优化这个接口" —— 无终态、无验证面、无边界,agent 无限迭代或提前宣告完成。
- 强:"Migrate `services/billing/**` from SDK v4 to v5 until `npm run build` and `npm test billing` both exit 0"。
- Codex cookbook 研究类范例(复现 Deep Hedging 论文):弱版 `/goal Reproduce Buehler et al., "Deep Hedging"` 欠定义——没说哪部分重要、什么算复现、训练状态缺失怎么办。强版本**命名了证据标准和最终产物**:"尝试每个 headline 结果,验证输出,最终报告分列:已复现机制 / 近似训练结果 / 被阻塞的精确重放 / 剩余不确定性"。agent 的目标从"做出令人印象深刻的复现"变成"在不夸大证据的前提下最小化不确定性"。实际运行中部分声明因缺随机种子/checkpoint 被诚实标记为 blocked——**Goal 让工作在 blocker 出现后继续推进,同时让最终结论保持诚实**。

### 何时不用 Goal(cookbook 官方反例)

- 一行编辑、简单解释、短 code review、一问一答 → 普通 prompt 更好;
- 终点线模糊("Make this better"、"Refactor this code" 不带终态/测试/约束)→ 没有可靠完成条件;
- **不要用 Goal 隐藏不确定性**:数据可能拿不到就写进 Goal;基准可能 flaky 就写明如何处理;允许代理证据就定义如何标注。

Goal 最强的场景同时满足三条:**持久目标 + 证据型终点线 + 路径需要多轮探索**。

---

## 4. 让任务跑得越久越好:工程纪律清单

时间长短不是由模型能力决定,而是由下面这套纪律决定。

### 4.1 验证驱动(防"假完成")

- **证据必须落进 transcript**(Claude evaluator 不跑命令):goal 里写明"每轮修改后运行 `pytest tests/payments -q` 并展示输出"。
- **在 goal 里点名 validator**,给闭环一条机器可见的终点线。
- **生产级门禁用确定性 Stop hook**(shell 脚本跑 `npm test`,失败就阻止"完成"),比 LLM 判断更稳。
- 双重验证面:主证明(测试)+ 次证明(typecheck / lint / 性能基准),防单一指标被"绕过"。

### 4.2 可恢复性(防崩溃归零)

- **原子化 commit**:每次编辑即 commit。批量模式下改 50 个文件中途崩 = 全丢;原子模式前 20 个已落地。RepoMirror 通宵迁移 6 个代码库产出 1100+ commits,"每次编辑后 commit+push"把重启成本降为零。Anthropic 官方也建议如此。
- **可恢复命令**:Claude `--continue` / `--resume`;Codex `codex exec resume --last`;Codex thread 本身持久化(pause/resume)。
- **进度外置**:维护 PROGRESS.md / 队列文件,重启后 agent 从文件而非记忆恢复状态。

### 4.3 上下文管理(防 context rot)

- **主上下文保持干净**:日志挖掘、大文件分析丢给 subagent,只回传摘要。
- 长任务必然触发 compaction —— 把关键状态写进文件(goal 文件、进度文件),而不是依赖对话记忆。
- Codex 用 `continuation.md` 注入 token 消耗,让 agent 自我感知预算。

### 4.4 三重预算(防 runaway 成本)

社区记录:单次 subagent fan-out 失控可烧 $8,000–$47,000。

- **Token 预算**:防 API 费用爆炸(`export CODEX_TOKEN_BUDGET=100000`)
- **轮次上限**:防无限循环(经验值 15–25 轮;Claude 条件里写 `or stop after 20 turns`,Claude 每轮汇报进度,evaluator 据此判断)
- **时间上限**:防挂钟泄漏(经验值 300s/轮 wall-clock timeout)

```bash
# Claude Code:条件内嵌轮次限制
/goal fix TypeScript errors in src/utils, stop after 20 turns

# Goal 文本中明确三重预算
"Fix pagination bug. Budget: max 30 turns, max $10, max 15 minutes"
```

### 4.5 无人值守的权限与安全

- Claude:auto mode(研究预览,降低 turn 内权限提示)或 headless `--permission-mode bypassPermissions` —— **只在容器/沙箱里用**。
- auto-approval 是"范围内的便利",不是信任决策:repo 内编辑可自动,push / migration / prod 操作前必须留人工门。
- 安全红线写进 Goal 本体:"Do not push, delete infra, or run migrations. Stop and report if recovery requires them."(这条来自 Anthropic 真实事故教训:auto 模式曾删远程分支、上传 auth token、试图跑生产 DB 迁移)
- headless 永远跑在一次性沙箱:no secret mounts、no prod credentials、artifact only(OpenHands headless 强制 always-approve,教训同源)。

### 4.6 天然长程的 Goal 形态

最能"越跑越久"的不是单个巨型任务,而是**队列清空型条件**:

- "Working through a labeled issue backlog **until the queue is empty**"(Claude 官方示例)
- "Split `src/inventory/service.ts` into modules **until each is under 400 LOC**"
- "Reconcile ad spend with finance records **until variance < 1%**"

队列型条件每轮都有可验证的增量进展,evaluator 永远有明确的"还没完"信号,不会提前误判完成。

---

## 5. 长程组合架构(按运行时长升级)

### L1 — 单会话数小时:`/goal` + auto mode + subagent + 原子 commit

```bash
claude   # 交互会话内
/goal Migrate services/billing from SDK v4 to v5. Success: `npm run build` and
`npm test billing` both exit 0, run after every change set. Do not modify files
outside services/billing. Commit after each passing change. Or stop after 40 turns.
```
配 auto mode 让每轮无提示执行;大日志分析派 subagent。

### L2 — 通宵级:headless 外层循环(Ralph Loop 模式)

```bash
# Claude headless(在容器内)
echo "Work through PROGRESS.md task queue. After each task: run tests, commit." | \
  claude -p \
    --permission-mode bypassPermissions \
    --output-format json > result.json

# Codex headless + 续跑
codex exec --json "fix failing tests"
codex exec resume --last
```
外层 bash/CI 循环负责:重启崩溃会话、检查预算、读取上轮 commit 判断进度。

### L3 — 数天级:调度层串联(Issue→PR 全自动)

GitHub Actions(`on: issues` + `schedule: cron`)触发 headless agent,跑完用 create-pull-request action 提 PR;或用 Codex App automations 做定时无人值守任务。**人类门禁只留在 PR review / merge / deploy 边界。**

```yaml
# 骨架(报告中的伪命令示例,落地时按当前 CLI 实际参数调整)
on:
  issues: { types: [opened, labeled] }
  schedule: [{ cron: '0 */6 * * *' }]
jobs:
  agent-fix:
    steps:
      - uses: actions/checkout@v4
      - run: claude -p "$GOAL" --permission-mode bypassPermissions ...
      - uses: peter-evans/create-pull-request@v5
```

### L4 — 多 agent 并行:worktree 隔离 + 子目标分解

任务超出单 agent 上下文时:orchestrator 分解任务图,每个 agent 一个 worktree、只写自己的目录,QA agent depends_on 前两者,集成分支收口。四原语:Task Decomposition / Routing / State / Recovery。

### 调度自动化的选品原则

- ✅ 适合:每日 PR/CI 检查、依赖审计、issue backlog 清理、运维简报 —— 有干净 validator 的重复任务
- ❌ 不适合:模糊的产品决策、基础设施变更、面向客户的策略变更 —— 没有干净 validator 的一律不要无人化

---

## 6. 长程运行的风险与对策

| 风险 | 表现 | 对策 |
|---|---|---|
| 质量退化(慢性) | 3 天后:错误处理风格不一致、50 行代码复制粘贴、类型退化成 `any` | 阶段性 checkpoint review;lint/typecheck 进验证面 |
| 幻觉产出 | 30% 引用 404;不存在的 API(`numpy.fft.fast_transform()`);"自信的虚假保证" | 验证面必须是可执行检查,不是 agent 自述 |
| Scope creep | 长程失败首因 | Boundaries 字段明确 FORBIDDEN;"假设只有 2 小时,最核心解决什么?" |
| 成本失控 | $8k–47k 级事故 | 三重预算 + 每轮 Reporting |
| 提前误判完成 | evaluator 被模糊条件骗过 | 一个终态 + 一个检查命令 + 队列型条件 |
| 危险操作 | 删分支/泄 token/生产迁移(Anthropic 实录) | 红线进 Goal;push/merge/prod 强制人工门;沙箱运行 |

---

## 7. 速查

```bash
# Claude Code
/goal <条件,≤4000字符,含验证命令和轮数上限>   # 设置
/goal                                          # 查状态(时长/轮数/token)
/goal clear                                    # 手动清除
claude -p "..." --permission-mode bypassPermissions   # headless(沙箱内)
claude --continue / --resume                   # 恢复会话

# Codex(Goals 需 ≥ 0.128.0,npm i -g @openai/codex@latest)
/goal <outcome>                                # 设置持久目标
/goal                                          # 查看当前 Goal
/goal pause | resume | clear                   # 生命周期管理
codex exec --json "..."                        # 非交互
codex exec resume --last                       # 续跑
export CODEX_TOKEN_BUDGET=100000               # token 预算
```

**一句话总结**:goal 模式长程自主 = 可校验的完成契约(六字段)× 跨轮持续机制(/goal evaluator 循环)× 无人值守权限(auto/bypass,限沙箱)× 可恢复性(原子 commit + resume)× 三重预算护栏。任务能跑多久,取决于验证面多干净、状态外置多彻底,而不是 prompt 写多长。
