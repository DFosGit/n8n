FROM railwayapp/nixpacks:latest

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

# Запускаем n8n
CMD ["npm", "run", "start"]
