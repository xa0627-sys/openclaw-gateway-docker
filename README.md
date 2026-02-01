# OpenClaw Gateway Docker

🦞 OpenClaw Gateway 的 Docker 部署方案，支援 Git 版控與 Zeabur CI/CD 自動部署。

## 特色

✅ **版本控制**：所有配置透過 Git 追蹤  
✅ **Zeabur 自動部署**：Push 到 GitHub 自動觸發部署  
✅ **環境隔離**：支援多環境配置（開發/預發/正式）  
✅ **快速疊代**：改動 Dockerfile 即時同步到服務  

## 快速開始

### 前置準備

1. **Zeabur 帳號**：已有 OpenClaw Gateway 服務運作的 Docker image
2. **此 Repo**：Fork 或 Clone
3. **環境變數**：準備好 API keys、tokens 等

### 部署步驟

#### 方式 1：全新部署（使用此 Repo）

1. 在 Zeabur 建立新服務
2. 選擇 **GitHub Repository** 作為來源
3. 選擇本 Repo：`xa0627-sys/openclaw-gateway-docker`
4. Zeabur 會自動偵測 Dockerfile 並部署
5. 在「環境變數」中設定所需的 key（見下方）

#### 方式 2：從現有 Docker Image 遷移

如你已有可運作的 Docker Image（如 `your-registry/openclaw-gateway:2026.1.29`）：

```dockerfile
# 修改本 Repo 的 Dockerfile
FROM your-registry/openclaw-gateway:2026.1.29

# 添加其他配置...
RUN ...

CMD ["openclaw", "gateway", "--config", "/home/node/.openclaw/openclaw.json"]
```

然後 push，Zeabur 會自動重新部署。

## 必要環境變數

```bash
# Gateway Token（必填）
OPENCLAW_GATEWAY_TOKEN=your-gateway-token-here

# 至少一個模型提供者（必填其一）
ANTHROPIC_API_KEY=your-key-here
OPENAI_API_KEY=your-key-here
GEMINI_API_KEY=your-key-here

# 可選：工作目錄挂載
# Zeabur 會自動處理 /home/node/.openclaw 持久化
```

## 項目結構

```
openclw-gateway-docker/
├── Dockerfile          # Docker 映像定義
├── .dockerignore        # Docker build 排除檔案
├── README.md           # 本文件
├── .github/
│   └── workflows/      # CI/CD 工作流（可選）
│       └── build.yml   # 自動測試/構建示例
└── config/
    └── openclaw.json   # 範例設定檔（需自己調整）
```

## 工作流程

### 本地開發

```bash
# 1. Clone 本 Repo
git clone https://github.com/xa0627-sys/openclaw-gateway-docker.git
cd openclaw-gateway-docker

# 2. 修改 Dockerfile（如果需要）
# vim Dockerfile

# 3. 本地測試（可選）
docker build -t openclaw-local .
docker run -e OPENCLAW_GATEWAY_TOKEN=xxx openclaw-local

# 4. Commit & Push
git add .
git commit -m "feat: update gateway config"
git push origin main
```

### Zeabur 自動部署

- 一旦 push 到 `main` 分支
- Zeabur 偵測到變更
- 自動 rebuild image
- 自動部署新版本

## 常見問題

### Q: 如何更新 OpenClaw 版本？

A: 修改 `Dockerfile` 的 `FROM` 行，改成新版本的 image tag，然後 push。

```dockerfile
# 舊版本
FROM your-registry/openclaw-gateway:2026.1.29

# 新版本
FROM your-registry/openclaw-gateway:2026.2.15
```

### Q: 如何新增自定義配置或初始化腳本？

A: 在 `Dockerfile` 中添加 `RUN` 或 `COPY` 指令：

```dockerfile
COPY config/openclaw.json /home/node/.openclaw/
RUN chmod 644 /home/node/.openclaw/openclaw.json
```

### Q: 我想同時管理開發和正式版本怎麼辦？

A: 建議用 Git branch：

- `main` → 正式版部署到 Zeabur 正式專案
- `dev` → 測試版部署到 Zeabur 測試專案
- 修改時先在 `dev` 測試，驗證後 merge 到 `main`

## 更新日誌

- **2026-02-01**：初版發佈，支援 Zeabur 自動部署

## 許可

MIT License

## 聯絡

Issues 與 PRs 歡迎！
