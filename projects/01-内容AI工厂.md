# 内容AI工厂

## 项目概览

- **仓库**: `~/Documents/Claude/Projects/内容ai工厂/`
- **时间**: 2025 ~ 至今
- **类型**: Web 应用（全栈）
- **状态**: 开发中
- **我的角色**: 全栈开发
- **团队规模**: 1 人

## 技术栈

后端 FastAPI + SQLAlchemy + PostgreSQL + ChromaDB
前端 Next.js 16 + React 19 + TypeScript + Tailwind CSS + Zustand + Recharts

## 项目简介

AI 驱动的内容创作和竞品分析平台，集成热点监控、竞品广告监控（Meta Ad Library）、素材管理、品牌视频分析、Reddit 洞察、AI 脚本生成、飞书同步等功能。

## 我负责的部分

- 后端全部 API 设计（FastAPI Router 分层）
- 前端全部页面和组件（Next.js App Router）
- 竞品广告数据从 Meta Ad Library 的采集和存储（Apify + PostgreSQL）
- ChromaDB 向量检索用于素材相似搜索
- 飞书消息通知和多维表格同步集成
- Claude/Gemini API 用于 AI 内容生成和脚本创作

## 技术难点 & 解决方案

- **竞品广告批量导入**：通过 Apify 调用 Meta Ad Library API，处理分页和限流，用 ChromaDB 做向量索引实现素材去重和相似搜索
- **Reddit 洞察**：爬取 Reddit 相关子版块帖子，用 AI 做情感分析和需求提取，结构化入库
- **前后端分离的数据一致性**：用 Zustand 管理前端状态，API 层统一错误处理（axios 拦截器）

## 踩坑记录

- ChromaDB 数据持久化路径问题：Docker 挂载卷配置不对导致重启后数据丢失，需确保 `chroma-data/` 目录正确映射
- Meta Ad Library 数据字段不稳定：不同国家/地区的广告数据字段有差异，需要做兼容映射

## 收获 & 思考

- 向量检索在素材管理场景非常实用，比传统关键词搜索效果好很多
- Zustand 比 Redux 简洁太多，适合中小型项目
- 飞书作为业务中台极大降低了内部工具开发成本

---

*最后更新: 2026-06-13*
