FROM node:20-slim

# Установка Python и других зависимостей
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python3 \
    python3-dev \
    python3-pip \
    python3-venv \
    build-essential \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Установка правильной версии pnpm
RUN npm install -g pnpm@10.2.1

WORKDIR /app

# Копируем package.json, pnpm-lock.yaml и requirements.txt для кэширования зависимостей
COPY package.json pnpm-lock.yaml requirements.txt ./

# Установка node зависимостей
RUN pnpm install --ignore-scripts

# Установка Python-зависимостей в виртуальное окружение
RUN python3 -m venv /app/venv && \
    /app/venv/bin/pip install --upgrade pip && \
    /app/venv/bin/pip install -r requirements.txt

# Копируем остальной код
COPY . .

# Сборка проекта
RUN pnpm build

# Настройка окружения
ENV PATH="/app/venv/bin:$PATH"
ENV EXPRESS_TRUST_PROXY=true

# Запуск n8n
CMD ["pnpm", "start"]
