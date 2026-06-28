# 智慧羊肚菌大棚数字孪生模块

本目录包含数字孪生大屏的前端与轻量后端接口。

## 目录结构

- `digital-twin-frontend`：Vue + Three.js 数字孪生大屏
- `digital-twin-backend`：Node.js 后端接口，用于连接 KingbaseES 数据库

## 前端启动

```powershell
cd digital-twin-frontend
npm install
npm run dev
```

## 后端启动

```powershell
cd digital-twin-backend
npm install
copy .env.example .env
npm start
```

如果暂时不连接数据库，只启动前端即可，页面会自动回退到模拟数据。
