# 处理FB文件

## 项目概览

- **仓库**: `~/Documents/Claude/Projects/处理FB文件/`
- **时间**: 2025
- **类型**: 工具脚本
- **状态**: 已完成
- **我的角色**: 脚本开发
- **团队规模**: 1 人

## 技术栈

Python/pandas + Brave Search API + GPT API + openpyxl

## 项目简介

Facebook 链接数据清洗补全工具。从 Excel 读取 FB 个人主页链接，调用 Brave Search 获取主页信息，GPT 做分类提取，输出标注后的 Excel 文件。

## 我负责的部分

- 全部脚本开发（`process_fb.py`、`process_fb_hybrid.py`、`normalize_categories.py`）

## 技术难点 & 解决方案

- **FB 页面信息抓取**：Facebook 反爬严格，改用 Brave Search API 间接获取页面摘要信息
- **分类归一化**：GPT 返回的分类名称不统一，写了 `normalize_categories.py` 做标准化映射

## 踩坑记录

- Brave Search API 免费额度有限，大量链接需要分批处理和缓存
- GPT 分类偶尔不稳定，同样输入不同时间返回不同结果，需要做结果校验

## 收获 & 思考

- 搜索引擎 API 是绕过社交媒体反爬的有效手段
- AI 做数据标注时要加校验层，不能完全信任 AI 输出

---

*最后更新: 2026-06-13*
