echo "Установка конфигурации...\n"

# Делаем все .sh файлы executable
echo "Делаем shell файлы запускаемыми...\n"
find . -type f -name "*.sh" -exec chmod +x {} \;
echo "Готово!\n"

# Устанавливаем пакетный менеджер
echo "Установка пакетного менеджера \"yay\"\n"
sudo pacman -S yay
echo "\"yay\" установлен!\n"

# Устанавливаем все програмы из required.txt
echo "Установка всех необходимых программ...\n"
while IFS= read -r pkg; do
  if ! pacman -Qq "$pkg" &>/dev/null; then
    echo "⏳ Installing: $pkg"
    yay -S --needed  --noconfirm "$pkg"
  else
    echo "✅ Already installed: $pkg"
  fi
done < required.txt
echo "Установка програм завершена успешно!\n"

# Устанавливаем конфигурационные файлы и папки в .config
echo "Установка конфигурационный файлов...\n"
cp -rf ./config/.* ~/.config/
cp -rf ./config/* ~/.config/
echo "Конфигурационные файлы успешно установлены!\n"

# Устанавливаем шрифты
echo "Установка шрифтов\n"
sudo cp -rf ./fonts/* /usr/share/fonts/
sudo cp -f ./other/local.conf /etc/fonts/
echo "Установка шрифтов выполнена успешно!\n"

# Устанавливаем курсоры и иконки
echo "Устанавливаем курсоры и иконки...\n"
sudo cp -rf ./icons/ /usr/share/icons/
echo "Установка выполнена успешно!\n"

# Копируем .Xresources
echo "Копирование файла .Xresources\n"
cp ./other/.Xresources ~/
echo "Копирование выполнено успешно!\n"

# Запускаем скрипт настроек
echo "Выставляем стандартные настройки..."
./settings.sh
echo "Стандартные настройки применены!"

# Установка nvm
echo "Установка nvm...\n"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
echo "Установка nvm выполнена успешно!\n"

xrdb -merge ~/.Xresources

echo "Установка завершена. Все готово к работе.\n"
echo "Перезапустите рабочий стол выбрав i3.\n"
echo "Если же i3 уже выбран, то нажмите mod+shift+r.\n"
echo "~~~ Приятного пользования :3 ~~~\n"



