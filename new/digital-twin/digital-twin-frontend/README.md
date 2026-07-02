# Digital Twin Frontend

This frontend is built with Vue 3 and Vite. It includes the greenhouse digital twin dashboard and the embedded Dify application "智慧小菇".

## AI assistant configuration

The Dify chat page is configured by `VITE_DIFY_CHAT_URL`.

1. Copy `.env.example` to `.env`.
2. Keep the default value if the Dify service is running on `172.22.44.178:8090`.
3. If the Dify host changes, update the address in `.env`.

Example:

```env
VITE_DIFY_CHAT_URL=http://172.22.44.178:8090/chat/IDCeWnE4p0dMGXW7
```

The computer running Dify must keep Docker, Dify, and Ollama running. Teammates must be in the same LAN and able to open `http://172.22.44.178:8090`.

## Run

```bash
npm install
npm run dev
```

Open the Vite URL printed in the terminal, usually `http://localhost:5173`.
