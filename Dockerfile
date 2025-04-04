FROM railwayapp/nixpacks:latest

# Устанавливаем Node.js и npm
RUN apt-get update && apt-get install -y \
    curl \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm@latest \
    && rm -rf /var/lib/apt/lists/*

# Устанавливаем pnpm
RUN npm install -g pnpm@10.2.1

# Устанавливаем lefthook
RUN npm install -g @arkweid/lefthook

# Устанавливаем Python и необходимые зависимости
RUN apt-get update && apt-get install -y \
    python3.9 \
    python3.9-dev \
    python3-pip \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Устанавливаем pip и проверяем его версию
RUN python3.9 -m pip install --upgrade pip

# Копируем requirements.txt
COPY requirements.txt /app/requirements.txt

# Устанавливаем Python-зависимости
RUN python3.9 -m pip install -r /app/requirements.txt

# Копируем остальной код
COPY . /app

# Устанавливаем зависимости с помощью pnpm
WORKDIR /app
RUN pnpm install

# Запускаем n8n
CMD ["npm", "run", "start"]
