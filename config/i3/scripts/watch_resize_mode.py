#!/usr/bin/env python3
### Скрипт, который отслеживает переход в режим `Resize` и меняет внешний вид окна в зависимости от этого


import i3ipc
import subprocess

# subprocess.run(["notify-send", "script is connected and watching"])


def on_mode_change(i3, e):
    if e.change == 'resize':
        # Здесь можно вызвать уведомление или поменять цвет через i3-msg
        i3.command('border normal 1')
        i3.command('mark "Resize Mode"')
    else:
        i3.command('border pixel 1')
        i3.command('unmark "Resize Mode"')

conn = i3ipc.Connection()
conn.on('mode', on_mode_change)
conn.main()
