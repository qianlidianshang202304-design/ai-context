# 案例：FastAPI Router 分层 + 字段映射模式

- **领域**: 网站搭建
- **场景**: FastAPI 后端需要处理 Excel 导入 → 数据库落库，列名需要做映射
- **来源项目**: 内容AI工厂

## 输入标准

竞品广告 Excel 文件（Meta Ad Library 导出格式）

## 输出标准

PostgreSQL `competitor_ads` 表中结构化的广告数据

## 关键做法

1. 用 `COLUMN_MAP` 字典做 Excel 列名 → DB 字段名的映射（单一真相源）
2. `APIRouter(prefix="/competitor", tags=["竞品监控"])` 做路由分组
3. pandas 读取 Excel 后用 `rename(columns=COLUMN_MAP)` 统一字段名
4. `AsyncSession` + `async/await` 做异步数据库操作

## 避坑

- Excel 列名可能变化，映射字典要作为配置集中管理
- 大批量导入时用 `bulk_insert_mappings` 而非逐条 insert

## 关联经验

见 `projects/内容AI工厂.md`

---

*最后更新: 2026-06-13*
