# 案例：axios 统一封装 + 拦截器模式

- **领域**: 网站搭建
- **场景**: Next.js 前端需要统一管理 API 请求（认证、错误处理、baseURL）
- **来源项目**: 内容AI工厂

## 输入标准

各个业务模块的 API 调用需求

## 输出标准

一个 `api.ts` 文件，所有模块共享同一个 axios 实例

## 关键做法

1. `axios.create()` 创建单例，配置 `baseURL` 和 `timeout`
2. 请求拦截器自动从 localStorage 注入 Bearer token
3. 响应拦截器统一处理 401（清 token → 跳转登录）、自动解包 `response.data`
4. 业务 API 按模块分对象导出（`authApi`、`hotspotApi`、`analyticsApi`），每个方法声明入参类型

## 为什么好

把 token 注入、401 跳转和错误格式统一收敛到 `lib/api.ts`，页面组件只关心业务请求，减少重复代码和状态不一致。

## 避坑

- 拦截器中用 `typeof window !== "undefined"` 避免 SSR 时访问 localStorage 报错
- `Promise.reject(error.response?.data || error)` 确保调用方拿到一致的错误格式

## 关联经验

见 `projects/01-内容AI工厂.md`

---

*最后更新: 2026-06-13*
