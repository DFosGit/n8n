FROM node:20-slim

# Установка Python и других зависимостей
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    libnss3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libgbm1 \
    libasound2 \
    libpangocairo-1.0-0 \
    libxss1 \
    libgtk-3-0 \
    libxshmfence1 \
    libglu1-mesa \
    sudo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Установка правильной версии pnpm
RUN npm install -g pnpm@10.2.1

WORKDIR /app

# Копирование только package.json сначала для кэширования зависимостей
COPY package.json pnpm-lock.yaml* ./
COPY requirements.txt ./

# Установка зависимостей 
RUN pnpm install --ignore-scripts
RUN pip3 install -r requirements.txt

# Копирование остальных файлов проекта
COPY . .

# Настройка окружения
ENV NIXPACKS_PATH=/app/node_modules/.bin:$PATH
ENV EXPRESS_TRUST_PROXY=true

# Запуск n8n (подставьте вашу команду запуска, если она отличается)
CMD ["pnpm", "start"]
