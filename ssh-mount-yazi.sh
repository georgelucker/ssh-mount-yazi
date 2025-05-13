#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <host>"
  exit 1
fi

name="$1"
mount_point="$HOME/$name"

mkdir -p "$mount_point"

# Проверяем, смонтирована ли папка
if ! mountpoint -q "$mount_point"; then
  sshfs "$name":/ "$mount_point"
fi

# Открываем yazi в tmux-панели, если в tmux
if [ -n "$TMUX" ]; then
  tmux split-window -h "yazi \"$mount_point\""
  # Немного подождем, чтобы tmux успел отобразить окно
  sleep 0.2
  tmux select-pane -L  # Переключаемся на левую панель
  # Расскоментируйте, чтобы поменять yazi и текущий терминал местами
  # tmux swap-pane -s 0 -t 1  # Меняем местами панели (левая и правая)
else
  echo "Не в tmux-сессии — yazi не запущен"
fi

# Подключаемся по SSH
ssh "$name"
