# 案例：TikTok Bio 批量抓取（断点续传）

- **领域**: 内容洞察
- **场景**: 从 TikTok 页面抓取数万条达人 Bio，需要处理反爬和请求失败
- **来源项目**: 达人库分析系统

## 输入标准

包含 TikTok username 列的 Excel 文件

## 输出标准

在原 Excel 后追加 Bio、粉丝数、昵称等字段的新列

## 关键做法

1. **SQLite 缓存层**：已抓取的 profile 存入 SQLite，重复运行只请求未缓存的
2. **断点续传**：`--refresh` 标志控制是否重新抓取，默认跳过已缓存
3. **流式读写**：用 `load_workbook(read_only=True)` 流式读 Excel，避免大文件撑爆内存
4. **UA 轮换**：维护 USER_AGENTS 列表，每次请求随机选取
5. **正则提取**：从 HTML 中提取 `__UNIVERSAL_DATA_FOR_REHYDRATION__` JSON 数据
6. **并发控制**：`concurrent.futures` 控制并发数，避免被封
7. **重试状态分类**：`RETRYABLE_STATUSES` 集合区分可重试和不可重试错误

## 为什么好

这个方案适合几十万行级别的达人数据任务：脚本可以随时中断和恢复，失败状态不会污染缓存，最终输出还能保留抓取状态和检查时间，方便复核。

## 避坑

- TikTok 页面需要带完整的 User-Agent 和 Cookie，否则返回空
- 正则提取 JSON 时注意处理特殊字符（`html.unescape`）
- 请求间隔要加随机延时（`random.uniform`）

## 关联经验

见 `projects/03-达人库分析系统.md`

---

*最后更新: 2026-06-13*
