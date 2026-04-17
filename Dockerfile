# --- Stage 1: Builder ---
FROM python:3.11-slim AS builder

WORKDIR /build

# Cài đặt công cụ build
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Cài đặt thư viện vào thư mục /root/.local
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# --- Stage 2: Runtime ---
FROM python:3.11-slim AS runtime

# Tạo user agent với thư mục home chuẩn
RUN groupadd -r agent && useradd -r -g agent -m -d /home/agent agent

WORKDIR /app

# Copy thư viện từ stage trước vào đúng thư mục home của user agent
COPY --from=builder /root/.local /home/agent/.local

# Copy mã nguồn và dữ liệu
COPY app/ ./app/

# Phân quyền cho user agent trên toàn bộ thư mục app và home
RUN chown -R agent:agent /app /home/agent

USER agent

# Thiết lập môi trường
ENV PATH=/home/agent/.local/bin:$PATH
ENV PYTHONPATH=/app
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=15s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')" || exit 1

# Sử dụng shell form để biến $PORT có thể được giải phóng
CMD uvicorn app.main:app --host 0.0.0.0 --port ${PORT:-8000} --workers 2
