---
name: codex-goal
description: >
  Use when writing a Codex or Claude Goal, drafting a long-running AI task contract,
  or turning a fuzzy workshop idea into a verifiable Goal. Triggers on
  "写 Goal", "开 Goal", "/goal", "Goal 模式", "可验证目标", "完成契约", "Goal Brief".
---

# Codex Goal · 工坊指针包

执行时读 `references/` 里的 BP 与材料（已随包复制，别人电脑上也能用，不依赖余一工作区），按 BP 执行链走，禁止在本文件重复 BP 正文。

## 必读（按顺序）

1. **`references/BP064-codex-goal-mode-handbook.md`** — SSOT（触发、输入契约、Operating Chain、模板、验收）
2. **`references/goal-mode-长程自主运行指南.md`** — 长程自主运行补充
3. **`references/codex-goal-mode-handbook.html`** 或 **`.pdf`** — 白话操作手册（按需）

## 工坊产出

一张 **Goal Brief**：陈述句终态 + 验证面 + 边界 + 停止条件 + 可粘贴 `/goal` 正文（格式见 BP064 Goal Five-Piece）。

## 工坊衔接

- 上游：`ai-first`（挑出今天要做的活儿切片）。
- 下游：拿到 Goal Brief -> `ai-dev-sprint` 开 build。
- 不知道现在在工坊哪一段 -> `sprint-guide`。

## 验收

按 BP064 Acceptance 节逐条打勾。
