#!/bin/bash

# Подключаем файл с массивом пакетов
if [ -f "./packages.sh" ]; then
    source ./packages.sh
else
    echo "Ошибка: Файл packages.sh не найден!"
    exit 1
fi

echo "🚀 Начинаем установку конфигурации..."

# 1. Делаем все .sh файлы исполняемыми
echo "⚙️  Настройка прав для скриптов..."
find . -type f -name "*.sh" -exec chmod +x {} \;

# 2. Установка yay (если его нет)
if ! command -v yay &> /dev/null; then
    echo "📦 Установка пакетного менеджера yay..."
    sudo pacman -S --needed --noconfirm base-devel git
    git clone https://aur.archlinux.org/yay.git
    cd yay && makepkg -si --noconfirm
    cd .. && rm -rf yay
else
    echo "✅ yay уже установлен."
fi

# 3. Установка программ из массива APPS
echo "⏳ Установка всех необходимых программ (это может занять время)..."
# Устанавливаем всё одной командой для скорости
yay -S --needed --noconfirm "${APPS[@]}"

# 4. Установка конфигурационных файлов
echo "📁 Настройка .config..."
mkdir -p ~/.config
# Используем rsync, чтобы не плодить вложенные папки и корректно копировать hidden файлы
if command -v rsync &> /dev/null; then
    rsync -av --progress ./config/ ~/.config/
else
    cp -rf ./config/. ~/ # если rsync не в списке, копируем через cp
fi

# 4.1 Устанавливаем конфигурацию для Neovim
# 4.1.1 Проверяем и устанавливаем Packer, если его нет
PACKER_PATH="$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"
if [ ! -d "$PACKER_PATH" ]; then
    echo "📥 Клонирование Packer.nvim..."
    git clone --depth 1 https://github.com/wbthomason/packer.nvim "$PACKER_PATH"
fi

# 4.1.2 Устанавливаем плагины
if command -v nvim &> /dev/null; then
    echo "📦 Установка плагинов Neovim..."
    nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
fi

# 5. Симлинк для Vim
echo "🔗 Создание симлинков..."
ln -sf ~/.config/vim/.vimrc ~/.vimrc

# 6. Шрифты и системные конфиги
echo "🔤 Установка шрифтов..."
sudo mkdir -p /usr/share/fonts/custom
sudo cp -rf ./fonts/* /usr/share/fonts/custom/
sudo cp -f ./other/local.conf /etc/fonts/
fc-cache -fv # Обновляем кэш шрифтов

# 7. Курсоры и иконки
echo "🖱️  Установка иконок..."
sudo mkdir -p /usr/share/icons
sudo cp -rf ./icons/* /usr/share/icons/

# 8. Файлы в $HOME
echo "🏠 Копирование файлов в HOME..."
cp -f ./home/* ~/ 2>/dev/null || true

# 9. Настройка Login Manager (ly)
echo "🖥️  Настройка экрана входа..."
sudo systemctl disable gdm lightdm sddm || true
sudo systemctl enable ly

# 10. nvm (Node Version Manager)
if [ ! -d "$HOME/.nvm" ]; then
    echo "🌐 Установка nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

# 11. Запуск дополнительных скриптов
echo "🛠️  Запуск дополнительных настроек..."
./settings.sh

# 12. Запуск дополнительных установок
for f in ./setups/*; do
    if [ -x "$f" ]; then
        echo "Running setup: $f"
        "$f"
    fi
done

# 13. Финализация
xrdb -merge ~/.Xresources || echo "Xresources не найдены"

echo "✅ Установка завершена!"
echo "🔄 Перезагрузка через 10 секунд. Нажмите Ctrl+C для отмены."

for i in {9..1}; do
    echo "$i..."
    sleep 1
done

echo "Перезагрузка..."
reboot
