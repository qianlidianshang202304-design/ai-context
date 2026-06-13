# 案例：定时 ETL 管道模式

- **领域**: 爬虫 & 数据
- **场景**: 从飞书表格读取视频链接 → Instagram API 获取数据 → 写入 PostgreSQL
- **来源项目**: db数据库落库

## 输入标准

飞书多维表格中的视频链接列表

## 输出标准

PostgreSQL 表中结构化的社交媒体验数据

## 关键做法

1. 单文件脚本，`psycopg2` 直连 PostgreSQL
2. 飞书 SDK 读取表格数据 → Instagram Graph API 获取详情 → 结构化入库
3. 支持定时执行（cron / 手动触发）
4. 处理 API 限流和异常重试

## 避坑

- Instagram Graph API token 有过期时间，需要定期刷新
- 飞书表格数据可能有重复，入库前做 upsert（ON CONFLICT DO UPDATE）

## 关联经验

见 `projects/05-db数据库落库.md`

---

*最后更新: 2026-06-13*
