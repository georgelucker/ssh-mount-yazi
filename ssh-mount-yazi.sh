#!/bin/bash
if [ -z "$1" ]; then
  echo "Usage: $0 <host>"
  exit 1
fi
name="$1"
mount_point="$HOME/$name"
mkdir -p "$mount_point"

# Определяем удаленный путь в зависимости от аргумента
if [ "$name" = "ans" ]; then
  remote_path="/root/ans/"
elif [ "$name" = "terra" ]; then
  remote_path="/root/dc/pcc/"
elif [ "$name" = "web" ]; then
  remote_path="/var/www/"
else
  remote_path="/"
fi

if ! mountpoint -q "$mount_point"; then
  sshfs "$name":"$remote_path" "$mount_point"
fi
export EDITOR=lvim
export VISUAL=lvim

# Переименовать активную вкладку tmux
if [ -n "$TMUX" ]; then
  tmux rename-window "$name"
  tmux split-window -h "EDITOR=lvim VISUAL=lvim yazi \"$mount_point\""
  sleep 0.2
  tmux select-pane -L
else
  echo "Не в tmux-сессии — yazi не запущен"
fi

# SSH подключение с переходом в нужную директорию
if [ "$name" = "ans" ]; then
  ssh "$name" -t "cd /root/ans && exec \$SHELL"
elif [ "$name" = "terra" ]; then
  ssh "$name" -t "cd /root/dc/pcc && exec \$SHELL"
elif [ "$name" = "web" ]; then
  ssh "$name" -t "cd /var/www && exec \$SHELL"
else
  ssh "$name"
fi
