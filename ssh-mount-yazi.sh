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

# Устанавливаем редактор для yazi
export EDITOR=nvim
export VISUAL=nvim

# Открываем yazi в tmux-панели, если в tmux
if [ -n "$TMUX" ]; then
  tmux split-window -h "EDITOR=nvim VISUAL=nvim yazi \"$mount_point\""
  sleep 0.2
  tmux select-pane -L
else
  echo "Не в tmux-сессии — yazi не запущен"
fi

# Подключаемся по SSH
ssh "$name"
