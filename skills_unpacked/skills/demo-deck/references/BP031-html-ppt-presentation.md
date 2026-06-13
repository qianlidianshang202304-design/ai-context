# BP031 - Universal HTML PPT

## Status

stable-candidate

## Role

BP031 is the universal entry and SSOT for HTML PPT work.

Any task that asks for HTML PPT, HTML deck, browser-rendered slides, report-to-deck, event deck, share deck, or presentation surface must read BP031 first, unless it matches the locked AI跃迁者 body-slide exception in [BP033](BP033-ai-yueqianzhe-body-slide.md).

BP031 owns deck-level narrative, page structure, visual system inheritance, HTML slide implementation, browser rendering checks, screenshot/export packaging, and the HTML PPT quality floor.

## 适用判断

Use BP031 when the user needs any browser-rendered slide deck:

- HTML PPT / HTML deck / presentation surface.
- Report, whitepaper, article, transcript, or workshop material adapted into slides.
- Event deck, share deck, internal briefing deck, or webpage-embedded deck.
- Deck screenshots or slide PNG exports as final assets.
- Audio/TTS or web-video later layered on top of an HTML PPT.
- Review, audit, repair, or polish of an existing HTML PPT.

Do not use BP031 when:

- The task is a single HTML card, poster, infocard, or article illustration with no deck behavior. Route to BP030 or BP032.
- The task is only judging visual quality. Route to principles.
- The task is a one-off tool operation. Route to atoms.
- The task is `AI跃迁者调研` series body slides or配图 PPT. Route to [BP033](BP033-ai-yueqianzhe-body-slide.md).

## 分支路由

| Branch | Trigger | Route Decision | Output |
|---|---|---|---|
| `deck-from-material` | Raw material, outline, transcript, workshop notes, or article needs an HTML PPT | BP031 main chain | Single HTML deck + screenshots |
| `presentation-from-report` | Published report or whitepaper needs a narrative deck for sharing, speaking, or webpage embed | BP031 main chain; inherit report visual tokens first | Single HTML deck, usually 15-25 pages |
| `event-deck` | Post-event or activity materials need a same-style HTML PPT | BP031 when the deliverable is a deck | Same-style HTML deck |
| `screenshot-export-deck` | User wants slide PNGs exported from a deck | BP031 build/check/export chain | HTML deck + PNGs + screenshot record |
| `audio-or-video-deck` | User wants narrated HTML PPT, TTS, or web-video presentation based on slides | BP031 for deck first; media BP/atoms layer after content and visuals pass | Two-phase deck, then audio/video layer |
| `review-existing-deck` | User asks to review, audit, fix, or polish an existing HTML PPT | BP031 quality gates + render acceptance before patching | Findings, patch plan, fixed deck, or review report |
| `ai-yueqianzhe-body-slide` | AI跃迁者调研正文页 or配图 PPT | Route to [BP033](BP033-ai-yueqianzhe-body-slide.md) | PNG body slide from locked template |

Article illustration boundary:

- Ordinary article illustrations are not HTML PPT. Route to BP030, BP032, or BP133.
- BP133 may use HTML as a screenshot production surface after image generation fails, but that is not a BP031 deck unless the user explicitly asks for a multi-page HTML PPT.

## 通用 HTML PPT 六锚点

These anchors are embedded here so every HTML PPT task can read one BP. [BP035](BP035-html-six-anchors.md) remains the shared HTML-output background, but HTML PPT execution must not require stitching rules from several BP files.

| Anchor | HTML PPT Requirement |
|---|---|
| Visual inheritance | First read upstream tokens or source style, then copy colors, fonts, grid, texture, spacing, and interaction conventions into the deck. |
| Five-piece closure | Before HTML, write north star, boundary, core judgment, route, and acceptance gate in the cockpit. |
| One page, one judgment | Every slide has one core judgment and one visual carrier. Before choosing the carrier, answer: what question must the reader answer after this page? Then match a structure from the library (§1.1c). Split overloaded pages. |
| Single-file deck | CSS/JS inline; keyboard navigation, progress, page counter, and mobile behavior are built into the HTML. |
| L3 self-review fallback | If reviewer/subagent is unavailable, main agent runs mechanical checks and records the independence level. |
| Visual relation maps structure | Choose the slide structure from the content relationship: path, system, contrast, hierarchy, evidence, set, or interaction. |

Quality anchors:

- [余一品味总纲](../../../../principles/余一品味总纲.md)
- [可视化交付通用经验](../../../../principles/可视化交付通用经验.md)
- [设计工艺层](../../../../principles/设计工艺层.md)
- [文本结构视觉化](../../../../../01余一/余一的偏好/文本结构视觉化.md)
- [版式与样式硬指标](../../../../../01余一/余一的偏好/版式与样式硬指标.md)

Immediate stop gates:

- If the task asks for HTML PPT, presentation visuals, layout polish, export screenshots, or visual audit, load the quality anchors before outline or HTML work.
- If PC and target export screenshots do not exist, the deck is a draft and must not be called deliverable.
- If `visual-acceptance-reviewer` is unavailable, record L3 self-review with mechanical evidence; self-review without screenshots is not an acceptance result.
- If any visible page is mostly equal-width cards, text columns, or decorative geometry, return to the page table and assign a real relation structure before styling.

Gold sample for visual and structural reference only: [从超级个体到超级团队_HTML_PPT.html](../../../../../03项目/ai原生(1)/报告成品-从超级个体到超级团队-2026-06-02/从超级个体到超级团队_HTML_PPT.html). Do not copy its chapter order, exact tokens, or geometry list unless the current material calls for them.

## 分层边界

- BP031 owns deck routing, five-piece closure, page table, visual-system lock, atom chain order, and deck-level acceptance.
- `html/slide-surface-build` owns fixed-canvas implementation, shared tokens, navigation, scaling, and debug overlay.
- `html/overflow-detect` owns DOM/layout mechanical checks.
- `html/screenshot-export` owns screenshot/export evidence.
- `.yuyi/principles/设计工艺层.md` and `.yuyi/principles/可视化交付通用经验.md` own cross-product typography, readability, and visual taste red lines.
- Provider, script, CSS, JS, or Playwright snippets do not belong in BP031 unless they are a one-line hard gate.

## 输入契约

Required:

- Goal: speaking deck, sharing deck, embedded webpage, exported slide screenshots, narrated deck, or other deck use.
- Source material: report, article, transcript, event notes, outline, or raw research.
- Delivery shape: HTML deck, slide screenshot package, narrated/video-ready deck, or export bundle.
- Deadline or stopping condition.

Conditionally required:

- Upstream visual asset or token source when the deck must inherit a known style.
- Target viewport when slide screenshots are the final deliverable.

Optional:

- Audience, platform, style constraints, account/permission state, output directory, speaker notes, audio/TTS need.

Missing-input rule:

- Ask only for inputs that change routing, facts, or acceptance.
- If the missing input affects style but not the main chain, pick a conservative default and mark the assumption in the cockpit.

## 开工前硬门

Before writing deck HTML, produce a five-piece closure and a page table.

Five-piece closure:

| Item | Requirement |
|---|---|
| North star | What the deck must let the reader understand or do |
| Boundary | What this deck does and does not cover |
| Core judgment | Visual system, file shape, page grain, and key craft choices |
| Route | Outline, implementation, render check, export/package |
| Acceptance gate | Checks, evidence, independence level, and known residual risk |

Page table:

| Field | Requirement |
|---|---|
| Page name | Short, concrete |
| Core judgment | One sentence; no page carries two main claims |
| Content question | **New.** What question must the reader answer after this page? One sentence. Feeds into structure selection via [可视化交付通用经验 §1.1c](../../../../principles/可视化交付通用经验.md). |
| Structure match | **New.** The specific visual structure matched from the structure library (e.g. "7-layer stacked pyramid", not "grid"). If no match exists, create one per [BP035 anchor 6](../../visual/BP035-html-six-anchors.md) and feed back to the library. |
| Delete test | **New.** Remove the visual module — how many layers of understanding are lost? 0 = rework. |
| State change | `previous reader state -> new judgment -> next-page hook` |
| Visual carrier | Implementation note: the concrete geometry chosen (e.g. "7 cells stacked with decreasing width"). Not a type label. |
| Source anchor | Where the fact or idea came from |

Hard failure signs:

- Source paragraphs are split into slides without a narrative state change.
- A page mixes definition, proof, example, and transition.
- Cards or columns repeat subtitles without exposing a hidden relationship.
- Removing the visual module does not reduce understanding.
- A user asks for a page count and the deck is split by number only.
- **Structure gate:** Any row in the page table with Content question empty, Structure match still "card/grid/list" (no content relationship encoded), or Delete test = 0 must not proceed to HTML implementation.

Content-owner review:

- Before HTML implementation, run a content-owner / speaker-voice review on the page table or script blueprint when the deck represents a specific person, organization, report author, or system owner.
- The reviewer must judge whether the narrative can actually be spoken by that owner, whether key modules are in the right argument order, and whether internal production language has leaked into audience-facing content.
- The review output must be recorded as constraints for the next outline/script revision, not as slide copy.
- **Hard gate:** if the review says the deck still reads like an internal system note, source digest, or construction plan, do not proceed to HTML.

## 执行链

| Step | Action / Atom | Input | Output | Pass Standard | Failure Fallback |
|---|---|---|---|---|---|
| 1 | Route branch | User goal + source material | Branch decision | Branch is one of the table entries above | If ambiguous, choose main deck branch and mark assumption |
| 2 | Five-piece closure | Goal + source + delivery shape | North star, boundary, core judgment, route, acceptance gate | Closure is in cockpit before HTML work | Stop and write it before coding |
| 3 | Synthesize outline | `.yuyi/skills/atoms/writing/outline-synthesis.md` | Page table + narrative arc | Every page has one judgment, content question, structure match, delete test, state change, and source anchor. Structure match encodes a real content relationship. | Reorder or merge pages before HTML |
| 4 | Content-owner review | Page table / script blueprint + owner voice or report context | Review constraints for structure, speaker fit, and public-facing language | Review passes or produces concrete revision constraints before HTML | Return to outline/script; do not code through a narrative failure |
| 5 | Lock visual system | `.yuyi/skills/atoms/image/visual-style-match.md` + upstream tokens | Color, font, spacing, texture, grid, screenshot/image policy | Tokens inherit the source style or state a default | Tokenize upstream asset first |
| 6 | Build slide surface | `.yuyi/skills/atoms/html/slide-surface-build.md` | Single HTML deck | Debug guide layer exists; pages have stable containers and visible visual actions | Return to page table or split overloaded slides |
| 7 | Add optional assets | `.yuyi/skills/atoms/image/image-generate.md` or real screenshots | Generated images, screenshots, charts | Assets serve a page judgment; no atmospheric filler | Use prompt/placeholders and list missing assets |
| 8 | Render check | `.yuyi/skills/atoms/html/responsive-layout-check.md` | Browser evidence | Key viewports have no overflow, overlap, blank slides, or unreadable labels | Fix layout, then rerun check |
| 9 | Screenshot/export | `.yuyi/skills/atoms/html/screenshot-export.md` | PNGs + screenshot record | Final screenshots match target viewport and context | Fix HTML before exporting again |
| 10 | Package | `.yuyi/skills/atoms/document/export-package.md` | HTML, assets, screenshots, notes | Package contains the user-facing final and verification record | List missing resources and handoff state |

## Presentation Quality Gates

### Narrative

- Deck pages usually land in the 15-25 page range for report-to-deck work, but page count follows argument thickness.
- Chapter order follows the current material's logic.
- Summary, definition, proof, case, formula, transition, and quote pages must use different page functions and layouts.
- Inserted modules require revised transition hooks before and after the module.

### Visual Action

Every slide must expose at least one visible structure:

- Relationship: variables or actors affect each other.
- Path: steps from problem to answer.
- System: input, process, feedback, output.
- Contrast: old/new, before/after, weak/strong.
- Set: group, hierarchy, ownership, inclusion.
- Evidence: number, case, time, identity, screenshot, source.

Pure text slides fail unless they are deliberate cover, section break, or quote pages.

### Typography

Declare font roles and type scale before implementation. BP031 keeps only the deck-level red lines:

- Presentation decks default to sans-serif.
- Chinese body text, labels, captions, notes, card text, and small informational text must not use `Noto Serif SC`, `Songti SC`, `STSong`, or generic `serif`.
- Informational labels and accent text must remain readable in the target screenshot viewport; important labels below 15px fail unless explicitly justified.
- For HTML PPT, this section overrides generic visual-preference font pairing. Serif can be used for a deliberate title or quote role only when body and label readability stay sans-serif.
- Detailed font roles and cross-product readability rules live in `.yuyi/principles/可视化交付通用经验.md` and `.yuyi/principles/设计工艺层.md`.

### Emphasis Color Readability

Blue or accent text often carries labels, numbering, evidence tags, chapter anchors, or formula variables. Treat it as information, not decoration. If a page is unclear, run `html/overflow-detect` or an equivalent computed-style scan before patching a single page.

### System Texture

- Use stable tokens for color, border, radius, shadow, grid, and background texture.
- Use one visual grammar for the same information type across the deck.
- Background texture, dots, rings, and lines must sit below the reading path.
- Real screenshots, report names, identities, dates, and data must remain accurate after compression.

## 渲染验收

Formal delivery requires browser evidence, not source-code inspection only.

Minimum mechanical checks:

1. `html/slide-surface-build` output uses fixed deck surface, shared tokens, navigation, page count, progress, and debug mode.
2. `html/overflow-detect` or equivalent browser scan passes page count, `data-page`, script syntax, overflow, collision, and important accent-text checks.
3. `html/screenshot-export` captures final target viewport and debug/evidence screenshots when practical.

## 评估标准

- 忠实：不伪造来源、事实、账号状态或用户意图。
- 可复现：下一次同类任务 can rerun from branch route, page table, visual system, build, render check, and package.
- 可验收：every key output has a pass standard and evidence.
- 品味：符合 `.yuyi/principles/余一品味总纲.md` and relevant visual principles.
- 视觉密度：deck contains visual structures, charts, diagrams, flows, comparisons, screenshots, real images, or generated images as needed.
- 阅读路径：each page has one dominant reading path; avoid equal-width multi-column wandering.
- 密度在结构：information density comes from visual structure, not a text tower.
- 工艺：debug guide layer, stable containers, token discipline, and screenshot gate are present.

## 验收标准

- Branch route is explicit.
- Required inputs are processed or missing inputs are marked.
- Five-piece closure exists before HTML implementation.
- Page table exists before HTML implementation.
- Content-owner review is completed before HTML implementation when the deck represents a specific person, organization, report author, or system owner.
- Output matches the user's delivery shape.
- HTML opens, navigates, and renders without blank or clipped slides.
- Key screenshots and screenshot check record exist.
- Mechanical checks for count, `data-page`, script syntax, overflow, and important small accent text pass or list exceptions.
- `visual-acceptance-reviewer` has returned `准予`, or the delivery is explicitly labeled `草稿/探索版` with L3 fallback evidence and residual risk.
- AI跃迁者 body-slide or配图 PPT tasks are routed to BP033, not handled inside BP031.
- Process materials are not mixed into the final deliverable.

## 产出位置

Default to the task's project directory.

Reusable system updates go to `.yuyi/skills/best-practices/practices/`, `.yuyi/skills/atoms/`, or `.yuyi/principles/` according to layer.

## 沉淀规则

- Two successful real runs keep or promote `stable-candidate`.
- New provider or tool capability updates the relevant atom provider, not this BP body.
- Cross-scenario quality judgment updates principles.
- A repeated deck failure updates the smallest relevant section: branch route, page-table hard gate, visual quality gate, or render check.
