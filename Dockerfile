FROM python:3.10-slim

# OpenCV va PaddleOCR ishlashi uchun kerakli tizim kutubxonalari
# libgl1-mesa-glx o'rniga yangi tizimlar uchun libgl1 ishlatamiz
RUN apt-get update && apt-get install -y \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Avval oddiy kutubxonalarni o'rnatamiz
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Maxsus muhit (environment) o'rnatilishi:
RUN python -m pip install paddlepaddle==3.2.0 -i https://www.paddlepaddle.org.cn/packages/stable/cpu/
RUN python -m pip install "paddleocr[all]"

# Qolgan barcha kodlarni nusxalaymiz
COPY . .

# Serverni ishga tushirish
CMD ["sh", "-c", "uvicorn server:app --host 0.0.0.0 --port ${PORT:-8000}"]