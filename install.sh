#!/bin/bash

# Прерывать скрипт при ошибках выполнения команд
set -e

# Подключаем файл с массивом пакетов
if [ -f "./packages.sh" ]; then
    source ./packages.sh
else
    echo "❌ Ошибка: Файл packages.sh не найден!"
    exit 1
fi

echo "🚀 Начинаем установку конфигурации..."

# Отключаем strict mode для секций, где ошибки развертывания не критичны
set +e

# 1. Делаем все .sh файлы исполняемыми
echo "⚙️  Настройка права для скриптов..."
find . -type f -name "*.sh" -exec chmod +x {} \;

# 2. Установка yay (если его нет)
if ! command -v yay &> /dev/null; then
    echo "📦 Установка пакетного менеджера yay..."
    sudo pacman -S --needed --noconfirm base-devel git
    
    # Безопасный subshell для сборки yay
    (
        cd $(mktemp -d) && 
        git clone https://aur.archlinux.org/yay.git . && 
        makepkg -si --noconfirm
    )
else
    echo "✅ yay уже установлен."
fi

# 3. Установка программ из массива APPS
if [ ${#APPS[@]} -gt 0 ]; then
    echo "⏳ Установка программ из списка APPS..."
    yay -S --needed --noconfirm "${APPS[@]}"
else
    echo "⚠️  Внимание: Список APPS пуст или не найден в packages.sh"
fi

# 4. Установка xgetres из utils
if [ -d "./utils/xgetres" ]; then
    echo "🛠️  Сборка и установка xgetres..."
    (cd ./utils/xgetres && make && sudo make install)
else
    echo "⚠️  Папка utils/xgetres не найдена, пропускаем."
fi

# 5. Установка конфигурационных файлов (.config)
echo "📁 Настройка ~/.config..."
mkdir -p ~/.config
if command -v rsync &> /dev/null; then
    rsync -av --progress ./config/ ~/.config/
else
    # Безопасное копирование содержимого папки config без захвата лишнего
    cp -rf ./config/* ~/.config/
fi

# 6. Настройка GTK и локальных ресурсов пользователя
echo "🎨 Настройка тем и GTK окружения..."
mkdir -p ~/.local/share/themes ~/.local/share/icons ~/.local/share/fonts ~/.local/share/applications

[ -d "./GTK/themes" ] && cp -rf ./GTK/themes/* ~/.local/share/themes/ 2>/dev/null
[ -d "./GTK/icons" ]  && cp -rf ./GTK/icons/* ~/.local/share/icons/ 2>/dev/null
[ -d "./GTK/fonts" ]  && cp -rf ./GTK/fonts/* ~/.local/share/fonts/ 2>/dev/null

# Копируем .desktop файлы
echo "Копирование .desktop файлов"
cp -f ./other/*.desktop ~/.local/share/applications/

# 7. Установка конфигурации для Neovim
PACKER_PATH="$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"
if [ ! -d "$PACKER_PATH" ]; then
    echo "📥 Клонирование Packer.nvim..."
    git clone --depth 1 https://github.com/wbthomason/packer.nvim "$PACKER_PATH"
fi

if command -v nvim &> /dev/null; then
    echo "📦 Установка плагинов Neovim..."
    nvim --headless -c 'PackerClean' -c 'PackerSync' --cmd "echo 'Синхронизация плагинов...'" +qall
fi

# 8. Симлинк для Vim
if [ -d "~/.config/vim" ]; then
    echo "🔗 Создание симлинков..."
    ln -sf ~/.config/vim/.vimrc ~/.vimrc
fi

# 9. Системные шрифты и конфиги (требуют sudo)
echo "🔤 Установка системных шрифтов..."
sudo mkdir -p /usr/share/fonts/custom
[ -d "./fonts" ] && sudo cp -rf ./fonts/* /usr/share/fonts/custom/
[ -f "./other/local.conf" ] && sudo cp -f ./other/local.conf /etc/fonts/
fc-cache -fv

# 10. Курсоры и иконки (системные)
echo "🖱️  Установка системных иконок..."
sudo mkdir -p /usr/share/icons
[ -d "./icons" ] && sudo cp -rf ./icons/* /usr/share/icons/

# 11. Файлы в $HOME (включая скрытые .bashrc, .Xresources)
echo "🏠 Копирование файлов в HOME..."
if [ -d "./home" ]; then
    # Включаем dotglob, чтобы cp видела файлы, начинающиеся с точки
    ( shopt -s dotglob; cp -rf ./home/* ~/ )
fi

# 12. Настройка Login Manager (ly)
echo "🖥️  Настройка экрана входа..."
sudo systemctl disable gdm lightdm sddm sgbm 2>/dev/null || true
sudo systemctl enable ly

# 13. nvm (Node Version Manager)
if [ ! -d "$HOME/.nvm" ]; then
    echo "🌐 Установка nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

# 14. Запуск дополнительных настроек
if [ -f "./settings.sh" ]; then
    echo "🛠️  Запуск дополнительных настроек (git config и др.)..."
    ./settings.sh
fi

# 15. Запуск дополнительных установок из папки setups
if [ -d "./setups" ]; then
    for f in ./setups/*; do
        if [ -x "$f" ]; then
            echo "Running setup: $f"
            "$f"
        fi
    done
fi

# 16. Финализация
echo "🔄 Обновление базы ресурсов X11..."
xrdb -merge ~/.Xresources 2>/dev/null || echo "⚠️  .Xresources не найдены или X-сервер не запущен"

echo "✅ Установка полностью завершена!"
echo "🔄 Перезагрузка через 10 секунд. Нажмите Ctrl+C для отмены."

for i in {10..1}; do
    echo "$i..."
    sleep 1
done

echo "Перезагрузка..."
systemctl reboot || sudo reboot
