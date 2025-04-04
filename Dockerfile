FROM n8nio/n8n:1.81.0

# Проверяем базовый дистрибутив и устанавливаем Python соответственно
RUN if command -v apt-get >/dev/null 2>&1; then \
        apt-get update && \
        apt-get install -y --no-install-recommends python3 python3-pip && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/*; \
    elif command -v apk >/dev/null 2>&1; then \
        apk add --no-cache python3 py3-pip; \
    fi

# Создаем requirements.txt с зависимостью
RUN echo "youtube-transcript-api" > /tmp/requirements.txt

# Установка Python-зависимостей
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt

# Определяем путь к сайт-пакетам Python
RUN python3 -c "import site; import os; print(site.getsitepackages()[0])" > /tmp/python_path && \
    PYTHON_SITE_PACKAGES=$(cat /tmp/python_path) && \
    echo "PYTHONPATH=${PYTHON_SITE_PACKAGES}" >> /etc/environment

# Настройка PYTHONPATH для доступа к пакетам Python из n8n
ENV PYTHONPATH=/usr/local/lib/python3.10/site-packages:/usr/lib/python3/dist-packages:/usr/lib/python3.10/site-packages
