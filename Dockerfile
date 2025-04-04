FROM railwayapp/nixpacks:latest

# Устанавливаем Node.js и npm (версия npm совместима с Node.js 18.x)
RUN apt-get update && apt-get install -y \
    curl \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm@9.8.1 \
    && rm -rf /var/lib/apt/lists/*

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

# Устанавливаем зависимости Node.js для n8n
WORKDIR /app
RUN npm install

# Запускаем n8n
CMD ["npm", "run", "start"]
