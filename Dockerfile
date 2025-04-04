FROM n8nio/n8n:latest

# Установка Python и зависимостей
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-venv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Создание и активация виртуального окружения Python
RUN python3 -m venv /usr/local/n8n/venv
ENV PATH="/usr/local/n8n/venv/bin:$PATH"

# Копирование requirements.txt
COPY requirements.txt /tmp/

# Установка Python-зависимостей
RUN pip3 install -r /tmp/requirements.txt

# Настройка PYTHONPATH для доступа к пакетам Python из n8n
ENV PYTHONPATH="/usr/local/n8n/venv/lib/python3.11/site-packages:$PYTHONPATH"
