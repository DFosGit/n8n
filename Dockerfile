FROM node:20-slim

# Установка Python и других зависимостей
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-venv \
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
    git \
    build-essential \
    python3-dev \
    libsqlite3-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Установка правильной версии pnpm
RUN npm install -g pnpm@10.2.1

WORKDIR /app

# Копируем все файлы проекта
COPY . .

# Создание и активация виртуального окружения Python
RUN python3 -m venv /app/venv
ENV PATH="/app/venv/bin:$PATH"

# Установка Python-зависимостей в виртуальное окружение
RUN pip3 install -r requirements.txt

# Установка нативных зависимостей с принудительной сборкой из исходников
ENV npm_config_build_from_source=true
RUN pnpm install --no-frozen-lockfile

# После установки всех зависимостей, компилируем sqlite3 отдельно
RUN cd node_modules/sqlite3 && npm run install

# Запуск только основного сервера n8n без сборки всего монорепозитория
# Это позволит избежать проблем со сборкой некоторых пакетов
RUN cd packages/cli && pnpm build

# Настройка окружения
ENV NIXPACKS_PATH=/app/node_modules/.bin:$PATH
ENV EXPRESS_TRUST_PROXY=true
ENV PYTHONPATH="/app/venv/lib/python3.11/site-packages:$PYTHONPATH"

# Делаем n8n исполняемым
RUN chmod +x packages/cli/bin/n8n

# Запуск n8n
CMD ["node", "packages/cli/bin/n8n", "start"]
