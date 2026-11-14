# KosmoVPN

Приложения KosmoVPN для телефона и компьютера. Нужна подписка: [kosmovpn.com](https://kosmovpn.com).

## Скачать

| Система | Файл |
|---|---|
| **Android** 7.0 и новее (arm64) | [KosmoVPN-android.apk](https://github.com/KosmoVPN/kosmovpn/releases/latest/download/KosmoVPN-android.apk) |
| **Windows** 10 / 11 (64-бит) | [KosmoVPN-windows.exe](https://github.com/KosmoVPN/kosmovpn/releases/latest/download/KosmoVPN-windows.exe) |
| **macOS**, Apple Silicon (M1 и новее) — бета | [kosmovpn-macos-arm64](https://github.com/KosmoVPN/kosmovpn/releases/latest/download/kosmovpn-macos-arm64) |
| **macOS**, Intel — бета | [kosmovpn-macos-intel](https://github.com/KosmoVPN/kosmovpn/releases/latest/download/kosmovpn-macos-intel) |
| **Linux** x86-64 — бета | [kosmovpn-linux-amd64](https://github.com/KosmoVPN/kosmovpn/releases/latest/download/kosmovpn-linux-amd64) |
| **Linux** arm64 — бета | [kosmovpn-linux-arm64](https://github.com/KosmoVPN/kosmovpn/releases/latest/download/kosmovpn-linux-arm64) |

Все версии и контрольные суммы SHA-256 — на странице [Releases](https://github.com/KosmoVPN/kosmovpn/releases). Дальше приложения обновляются сами.

## Установка

**Android.** Откройте скачанный файл и разрешите установку из этого источника, когда телефон спросит. Затем войдите или вставьте ссылку подписки.

**Windows.** Установщика нет: это одна программа, просто запустите её. Windows может показать «Система Windows защитила ваш компьютер» — нажмите «Подробнее» → «Выполнить в любом случае». Права администратора не нужны. После закрытия окна программа остаётся в трее.

**macOS.** В Терминале, в папке с файлом:

```sh
chmod +x kosmovpn-macos-arm64
xattr -d com.apple.quarantine kosmovpn-macos-arm64
./kosmovpn-macos-arm64
```

**Linux.**

```sh
chmod +x kosmovpn-linux-amd64
./kosmovpn-linux-amd64
```

## Что важно знать

- **Авто** выбирает самый быстрый сервер, который действительно работает, и сам переключается на другой, если связь пропала.
- Программа для компьютера работает как системный прокси: через VPN идут браузеры и программы, которые используют системные настройки прокси. Полного туннеля для всех программ пока нет.
- Сборки для macOS и Linux — бета: они проверены меньше, чем Android и Windows.
- Приложения передают анонимную статистику подключений (какой сервер, сколько шло подключение, удалось ли оно) — без аккаунта, адресов и сайтов.

Исходный код здесь не публикуется; в этом репозитории только готовые сборки.
