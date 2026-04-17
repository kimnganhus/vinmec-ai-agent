# Lab 12 — Complete Production Agent

Kết hợp TẤT CẢ những gì đã học trong 1 project hoàn chỉnh.

## Checklist Deliverable

- [x] Dockerfile (multi-stage, < 500 MB)
- [x] docker-compose.yml (agent + redis)
- [x] .dockerignore
- [x] Health check endpoint (`GET /health`)
- [x] Readiness endpoint (`GET /ready`)
- [x] API Key authentication
- [x] Rate limiting
- [x] Cost guard
- [x] Config từ environment variables
- [x] Structured logging
- [x] Graceful shutdown
- [x] Public URL ready (Railway / Render config)

---

## 🚀 Hướng Dẫn Triển Khai Từng Bước

Tất cả cấu hình đã sẵn sàng. Bạn có thể chọn một trong hai nền tảng sau:

### 1. Triển khai lên Railway (Nhanh & Ổn định)
1.  **Cài CLI**: `npm i -g @railway/cli`
2.  **Login**: `railway login`
3.  **Khởi tạo**: `railway init` (Chọn New Project)
4.  **Đặt secrets**:
    *   `railway variables set OPENAI_API_KEY=sk-...`
    *   `railway variables set AGENT_API_KEY=your-secret`
5.  **Deploy**: `railway up`
6.  **Domain**: `railway domain` để lấy URL.

### 2. Triển khai lên Render (Kết nối GitHub)
1.  **Push code**: Lên một Private GitHub Repo.
2.  **Blueprint**: Trên Dashboard Render, chọn **New** -> **Blueprint**.
3.  **Connect**: Chọn Repo vừa push.
4.  **Config**: Render sẽ đọc `render.yaml`. Bạn chỉ cần nhập `OPENAI_API_KEY` khi được hỏi.

---

## Cấu Trúc Dự Án (Sau khi tích hợp)

```
2A202600432_lab12/
├── app/
│   ├── main.py         # Entry point (FastAPI + Agent Graph)
│   ├── agent.py        # Logic Vinmec AI Agent
│   ├── config.py       # cấu hình 12-factor
│   ├── data/           # Dữ liệu JSON (bác sĩ, phòng khám...)
│   ├── tools/          # Các công cụ hỗ trợ agent
│   └── system_prompt.txt
├── Dockerfile          # Multi-stage build tối ưu
├── docker-compose.yml  # Local stack (Agent + Redis)
├── check_production_ready.py # Script kiểm tra 100% tiêu chuẩn
├── requirements.txt
└── .gitignore
```

---

## Chạy Local

```bash
# 1. Setup
cp .env.example .env  # Điền OPENAI_API_KEY vào .env

# 2. Chạy với Docker Compose
docker compose up

# 3. Test API
curl -H "X-API-Key: dev-key-change-me" \
     -X POST http://localhost:8000/ask \
     -H "Content-Type: application/json" \
     -d '{"question": "Tôi muốn khám sức tổng quát"}'
```

---

## Kiểm Tra Production Readiness

```bash
py check_production_ready.py
```

Script này đã được cấu hình để kiểm tra 20/20 tiêu chuẩn sản xuất cho Vinmec AI Agent.
