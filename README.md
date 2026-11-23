# KosmoVPN

KosmoVPN apps for phones, TVs and computers. You need a subscription: [kosmovpn.com](https://kosmovpn.com).

[Русская версия](README.ru.md)

## Download

| System | File |
|---|---|
| **Android** 7.1+ phones and tablets (arm64) | [KosmoVPN-android.apk](https://github.com/KosmoVPN/kosmovpn/releases/latest/download/KosmoVPN-android.apk) |
| **Android TV** and TV boxes, Android 7.1+ (32-bit ARM) — beta | [KosmoVPN-android-tv.apk](https://github.com/KosmoVPN/kosmovpn/releases/latest/download/KosmoVPN-android-tv.apk) |
| **Windows** 10 / 11 (64-bit) | [KosmoVPN-windows.msi](https://github.com/KosmoVPN/kosmovpn/releases/latest/download/KosmoVPN-windows.msi) — installer |
| **macOS**, Apple Silicon — beta | [kosmovpn-macos-arm64](https://github.com/KosmoVPN/kosmovpn/releases/latest/download/kosmovpn-macos-arm64) |
| **macOS**, Intel — beta | [kosmovpn-macos-intel](https://github.com/KosmoVPN/kosmovpn/releases/latest/download/kosmovpn-macos-intel) |
| **Linux** x86-64 — beta | [kosmovpn-linux-amd64](https://github.com/KosmoVPN/kosmovpn/releases/latest/download/kosmovpn-linux-amd64) |
| **Linux** arm64 — beta | [kosmovpn-linux-arm64](https://github.com/KosmoVPN/kosmovpn/releases/latest/download/kosmovpn-linux-arm64) |

Every version, with SHA-256 checksums, is on the [Releases](https://github.com/KosmoVPN/kosmovpn/releases) page. Once installed, the apps update themselves.

## Install

**Android.** Open the downloaded file and allow installing from this source when the phone asks. Then sign in or paste your subscription link.

**Android TV / TV box.** Get the TV file onto the device (a USB stick, a "send files to TV" app, or `adb install KosmoVPN-android-tv.apk`) and install it. On the first screen choose «Подключить с телефона по QR-коду»: point your phone's camera at the code and the KosmoVPN app on the phone hands its subscription to the TV. Phone and TV must be on the same Wi-Fi. No typing with the remote.

**Windows.** Run the downloaded installer. Windows may say "Windows protected your PC" — click "More info" → "Run anyway", then allow the installation. The program appears in the Start menu and opens by itself; closing the window leaves it in the tray. Settings has "VPN для всех программ" (VPN for every program): the whole computer's traffic goes through the VPN (games, messengers), not only the browser. The mode is new; switching it on or off drops open connections.

Without installing: [KosmoVPN-windows.exe](https://github.com/KosmoVPN/kosmovpn/releases/latest/download/KosmoVPN-windows.exe) — one program, no administrator rights, but "VPN for every program" does not work in it.

**macOS.** In Terminal, in the folder with the file:

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

## Under the hood

- **Engine.** [Xray-core](https://github.com/XTLS/Xray-core), a development snapshot of 9 November 2026 (commit `676eaf66f8f0`, after v26.3.27), embedded through [libXray](https://github.com/XTLS/libXray) 26.11.9. Built with Go 1.27. The Android and desktop apps share the same engine code.
- **Protocols.** Everything that Xray build speaks — VLESS (REALITY, XHTTP, Vision), VMess, Trojan, Shadowsocks, SOCKS — plus AnyTLS ([sing-anytls](https://github.com/anytls/sing-anytls) 0.0.13), TUIC v5 ([sing-quic](https://github.com/SagerNet/sing-quic) 0.7.1), TrustTunnel, and on Android AmneziaWG ([amneziawg-go](https://github.com/amnezia-vpn/amneziawg-go) 3.1).
- **Subscriptions.** A standard subscription URL or single share links (`vless://…` and the like); full Xray JSON configs are used when the provider serves them.
- **Auto.** Servers that answer a ping are tried fastest first, and each must carry a real request through the tunnel before it is chosen. While connected, a watchdog notices a dead tunnel and moves to another server by itself. On restricted networks it turns to the servers marked for white lists.
- **Android.** A full-device tunnel (`VpnService`), one APK of about 13 MB, no Google services required. Per-app bypass, custom DNS, and an optional "Russian sites direct" route. The TV file is the same app built for 32-bit ARM, driven entirely with a remote.
- **Desktop.** It runs a SOCKS5 + HTTP proxy on `127.0.0.1:10808` and sets it as the system proxy while connected, so browsers and proxy-aware programs go through the VPN. On Windows the installer adds a service and a Wintun adapter for a full tunnel (TUN), "VPN for every program"; on macOS and Linux it is one self-contained binary without a full tunnel.
- **Updates.** The apps fetch an update only from kosmovpn.com and install it only if its SHA-256 matches the published one. Android additionally refuses anything not signed with the KosmoVPN key — certificate SHA-256 `A6:BF:B5:7D:F6:B7:9C:BF:E2:A9:18:6A:35:E7:24:7A:43:57:32:40:75:39:58:60:E8:A8:15:F4:F1:B4:38:68`.
- **Usage statistics.** The apps report anonymous connection events (which server, how long a connect took, whether it worked) under a random install number: no account, no addresses, no sites.

macOS and Linux builds are marked beta because they have had less real-world testing than Android and Windows; the TV build because it has so far been tested on an emulator only.

The source code is not published; this repository holds release builds only.
