#!/bin/bash
# Простейший скрипт деплоя для запуска прямо на сервере
# Запускайте через консоль Hetzner

set -e

echo "========================================="
echo "Установка Hello World приложения"
echo "========================================="
echo ""

# Обновление системы
echo "Шаг 1: Обновление системы..."
apt-get update -qq

# Установка Docker
echo "Шаг 2: Установка Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
    sh /tmp/get-docker.sh
    systemctl enable docker
    systemctl start docker
    echo "✓ Docker установлен"
else
    echo "✓ Docker уже установлен"
fi

# Установка Git
echo "Шаг 3: Установка Git..."
if ! command -v git &> /dev/null; then
    apt-get install -y git
    echo "✓ Git установлен"
else
    echo "✓ Git уже установлен"
fi

# Создание директории и клонирование
echo "Шаг 4: Клонирование кода..."
mkdir -p /opt/hello-world-app
cd /opt/hello-world-app

if [ -d .git ]; then
    echo "Обновление существующего репозитория..."
    git fetch --all
    git reset --hard origin/claude/hello-world-github-actions-9IxaD
else
    echo "Клонирование репозитория..."
    rm -rf /opt/hello-world-app/*
    git clone -b claude/hello-world-github-actions-9IxaD https://github.com/eduardkolberg/testclaude2 /opt/hello-world-app
fi

echo "✓ Код получен"

# Остановка старого контейнера
echo "Шаг 5: Остановка старого контейнера..."
docker stop hello-world-app 2>/dev/null || echo "Контейнер не запущен"
docker rm hello-world-app 2>/dev/null || echo "Контейнер не существует"

# Сборка образа
echo "Шаг 6: Сборка Docker образа..."
docker build -t hello-world-app:latest .

# Запуск контейнера
echo "Шаг 7: Запуск приложения..."
docker run -d \
  --name hello-world-app \
  --restart unless-stopped \
  -p 80:3000 \
  hello-world-app:latest

# Проверка
echo "Шаг 8: Проверка..."
sleep 3

if docker ps | grep -q hello-world-app; then
    echo "✓ Контейнер запущен"
    docker ps | grep hello-world-app

    echo ""
    echo "Тестирование приложения..."
    sleep 2

    if curl -f http://localhost:80 > /dev/null 2>&1; then
        echo "✓ Приложение отвечает"
    else
        echo "⚠ Приложение еще загружается, подождите 10 секунд..."
    fi

    echo ""
    echo "========================================="
    echo "✓✓✓ ДЕПЛОЙ ЗАВЕРШЕН! ✓✓✓"
    echo "========================================="
    echo ""
    echo "Ваше приложение доступно по адресу:"
    echo ""
    IP=$(curl -s ifconfig.me || echo "49.13.52.51")
    echo "    🌐 http://$IP"
    echo ""
    echo "Откройте эту ссылку в браузере!"
    echo ""
    echo "Полезные команды:"
    echo "  Статус:     docker ps"
    echo "  Логи:       docker logs hello-world-app"
    echo "  Перезапуск: docker restart hello-world-app"
    echo "  Остановка:  docker stop hello-world-app"
    echo ""
else
    echo "❌ Ошибка запуска контейнера"
    echo "Логи:"
    docker logs hello-world-app 2>&1
    exit 1
fi
