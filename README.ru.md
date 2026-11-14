# KosmoVPN

Приложения KosmoVPN для телефона, телевизора и компьютера. Нужна подписка: [kosmovpn.com](https://kosmovpn.com).

[English version](README.md)

## Скачать

| Система | Файл |
|---|---|
| **Android** 7.0 и новее, телефоны и планшеты (arm64) | [KosmoVPN-android.apk](https://github.com/KosmoVPN/kosmovpn/releases/latest/download/KosmoVPN-android.apk) |
| **Android TV** и ТВ-приставки, Android 7.0 и новее (32-бит ARM) — бета | [KosmoVPN-android-tv.apk](https://github.com/KosmoVPN/kosmovpn/releases/latest/download/KosmoVPN-android-tv.apk) |
| **Windows** 10 / 11 (64-бит) | [KosmoVPN-windows.exe](https://github.com/KosmoVPN/kosmovpn/releases/latest/download/KosmoVPN-windows.exe) |
| **macOS**, Apple Silicon — бета | [kosmovpn-macos-arm64](https://github.com/KosmoVPN/kosmovpn/releases/latest/download/kosmovpn-macos-arm64) |
| **macOS**, Intel — бета | [kosmovpn-macos-intel](https://github.com/KosmoVPN/kosmovpn/releases/latest/download/kosmovpn-macos-intel) |
| **Linux** x86-64 — бета | [kosmovpn-linux-amd64](https://github.com/KosmoVPN/kosmovpn/releases/latest/download/kosmovpn-linux-amd64) |
| **Linux** arm64 — бета | [kosmovpn-linux-arm64](https://github.com/KosmoVPN/kosmovpn/releases/latest/download/kosmovpn-linux-arm64) |

Все версии и контрольные суммы SHA-256 — на странице [Releases](https://github.com/KosmoVPN/kosmovpn/releases). Дальше приложения обновляются сами.

## Установка

**Android.** Откройте скачанный файл и разрешите установку из этого источника, когда телефон спросит. Затем войдите или вставьте ссылку подписки.

**Android TV / ТВ-приставка.** Перенесите файл для ТВ на устройство (флешка, приложение для отправки файлов на телевизор или `adb install KosmoVPN-android-tv.apk`) и установите. На первом экране выберите «Подключить с телефона по QR-коду»: наведите камеру телефона на код, и приложение KosmoVPN на телефоне передаст подписку телевизору. Телефон и телевизор должны быть в одной сети Wi-Fi. Набирать пультом ничего не нужно.

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

## Как это устроено

- **Ядро.** [Xray-core](https://github.com/XTLS/Xray-core), сборка из ветки разработки от 9 ноября 2026 года (коммит `676eaf66f8f0`, после v26.3.27), встроено через [libXray](https://github.com/XTLS/libXray) 26.11.9. Собрано на Go 1.27. У приложений для Android и компьютера общий код ядра.
- **Протоколы.** Всё, что умеет эта сборка Xray, — VLESS (REALITY, XHTTP, Vision), VMess, Trojan, Shadowsocks, SOCKS — а также AnyTLS ([sing-anytls](https://github.com/anytls/sing-anytls) 0.0.13), TUIC v5 ([sing-quic](https://github.com/SagerNet/sing-quic) 0.7.1), TrustTunnel и, на Android, AmneziaWG ([amneziawg-go](https://github.com/amnezia-vpn/amneziawg-go) 3.1).
- **Подписки.** Обычная ссылка подписки или отдельные ссылки серверов (`vless://…` и подобные); если провайдер отдаёт полные конфигурации Xray в JSON, используются они.
- **Авто.** Серверы, ответившие на пинг, пробуются от самого быстрого, и каждый должен пропустить настоящий запрос через туннель, прежде чем будет выбран. Во время работы приложение само замечает, что туннель перестал работать, и переходит на другой сервер. В сетях с ограничениями оно переходит на серверы для «белых списков».
- **Android.** Туннель для всего устройства (`VpnService`), один APK около 13 МБ, сервисы Google не нужны. Приложения вне VPN, свой DNS, отдельный маршрут «Сайты РФ напрямую». Файл для ТВ — то же приложение, собранное под 32-битный ARM; им полностью управляют с пульта.
- **Компьютер.** Один самодостаточный файл: без установщика, драйвера и прав администратора. Программа запускает прокси SOCKS5 + HTTP на `127.0.0.1:10808` и на время подключения делает его системным, поэтому через VPN идут браузеры и программы, которые учитывают системный прокси. Полного туннеля (TUN) пока нет.
- **Обновления.** Приложения берут обновление только с kosmovpn.com и устанавливают его, только если SHA-256 файла совпадает с опубликованным. Android к тому же не примет файл, не подписанный ключом KosmoVPN — SHA-256 сертификата `A6:BF:B5:7D:F6:B7:9C:BF:E2:A9:18:6A:35:E7:24:7A:43:57:32:40:75:39:58:60:E8:A8:15:F4:F1:B4:38:68`.
- **Статистика.** Приложения передают анонимные события подключений (какой сервер, сколько шло подключение, удалось ли оно) под случайным номером установки: без аккаунта, адресов и сайтов.

Сборки для macOS и Linux помечены как бета, потому что проверены в работе меньше, чем Android и Windows; сборка для ТВ — потому что пока проверена только на эмуляторе.

Исходный код здесь не публикуется; в этом репозитории только готовые сборки.
