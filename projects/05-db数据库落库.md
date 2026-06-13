# db数据库落库

## 项目概览

- **仓库**: `~/Documents/Claude/Projects/db数据库落库/`
- **类型**: 数据管道脚本
- **状态**: 维护中
- **我的角色**: 数据工程
- **团队规模**: 1 人

## 技术栈

Python/psycopg2 + Instagram Graph API

## 项目简介

社交媒体数据 ETL 管道。从飞书表格读取视频链接 → Instagram API 获取数据 → 写入 PostgreSQL，支持定时执行。

## 关键做法

- 单文件脚本，`psycopg2` 直连 PostgreSQL
- 飞书 SDK 读取表格数据 → Instagram Graph API 获取详情 → 结构化入库
- 支持定时执行（cron / 手动触发）

## 踩坑记录

- Instagram Graph API token 有过期时间，需要定期刷新
- 飞书表格数据可能有重复，入库前做 upsert（ON CONFLICT DO UPDATE）

---

*最后更新: 2026-06-13*
