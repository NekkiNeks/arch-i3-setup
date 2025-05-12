echo "Установка конфигурации..."

# Делаем все .sh файлы executable
echo "Делаем shell файлы запускаемыми..."
find . -type f -name "*.sh" -exec chmod +x {} \;
echo "Готово!"

# Устанавливаем пакетный менеджер
echo "Установка пакетного менеджера \"yay\""
sudo pacman -S yay
echo "\"yay\" установлен!"

# Устанавливаем все програмы из required.txt
echo "Установка всех необходимых программ..."
while IFS= read -r pkg; do
    echo "⏳ Устанавливаем: $pkg"
    yay -S --needed  --noconfirm "$pkg"
done < required.txt
echo "Установка програм завершена успешно!"

# Устанавливаем конфигурационные файлы и папки в .config
echo "Установка конфигурационный файлов..."
cp -rf ./config/.* ~/.config/
cp -rf ./config/* ~/.config/
echo "Конфигурационные файлы успешно установлены!"

# Устанавливаем шрифты
echo "Установка шрифтов"
sudo cp -rf ./fonts/* /usr/share/fonts/
sudo cp -f ./other/local.conf /etc/fonts/
echo "Установка шрифтов выполнена успешно!"

# Устанавливаем курсоры и иконки
echo "Устанавливаем курсоры и иконки..."
sudo cp -rf ./icons/ /usr/share/icons/
echo "Установка выполнена успешно!"

# Устанавливаем файлы в $HOME
echo "Устанавливаем файлы в папку $HOME"
cp -f ./home/* ~/
echo "Копирование выполнено успешно!"

# Запускаем скрипт настроек
echo "Выставляем стандартные настройки..."
./settings.sh
echo "Стандартные настройки применены!"

# Установка nvm
echo "Установка nvm..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
echo "Установка nvm выполнена успешно!"

echo "Установка ly..."
sudo systemctl disable gdm lightdm sddm
sudo systemctl enable ly
echo "Установка экрана логина ly выполнена успешно..."

xrdb -merge ~/.Xresources



echo "Установка завершена. Все готово к работе."
echo "Перезапустите рабочий стол выбрав i3."
echo "~~~ Приятного пользования :3 ~~~"

echo "Автоматическая перезагрузка через 10..."
for i in {9..1}; do
    echo "$i..."
    sleep 1
done

echo "Перезагрузка утройства"
sleep 1
reboot


