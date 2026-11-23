#!/bin/sh
# Makes a release here out of what https://kosmovpn.com/dl serves right now (version.json: Android,
# version-v7.json: Android for TVs, desktop.json: the computers), under fixed file names, so the README's "latest" links never change.
# Run it after publishing an app there: sh publish.sh   (needs curl, python, and gh logged in)
# Every file is checked against the SHA-256 from the JSON before anything is uploaded.
set -eu
REPO=KosmoVPN/kosmovpn
d=$(mktemp -d)
trap 'rm -rf "$d"' EXIT
curl -fsS https://kosmovpn.com/dl/version.json -o "$d/a.json"
curl -fsS https://kosmovpn.com/dl/version-v7.json -o "$d/t.json"
curl -fsS https://kosmovpn.com/dl/desktop.json -o "$d/d.json"
# -> "tag", "title", then "name url sha256" lines; notes.md beside them
python - "$d" > "$d/plan" <<'EOF'
import json, sys
d = sys.argv[1]
a = json.load(open(d + "/a.json", encoding="utf-8"))
t = json.load(open(d + "/t.json", encoding="utf-8"))
k = json.load(open(d + "/d.json", encoding="utf-8"))
names = {"windows-amd64": "KosmoVPN-windows.exe", "linux-amd64": "kosmovpn-linux-amd64", "linux-arm64": "kosmovpn-linux-arm64",
         "darwin-arm64": "kosmovpn-macos-arm64", "darwin-amd64": "kosmovpn-macos-intel"}
files = [("KosmoVPN-android.apk", a["url"], a["sha256"]), ("KosmoVPN-android-tv.apk", t["url"], t["sha256"])] + [(names[t], f["url"], f["sha256"]) for t, f in k["files"].items()]
print("android-%s-desktop-%s" % (a["versionName"], k["version"]))
print("Android and Android TV %s · Windows, macOS, Linux %s" % (a["versionName"], k["version"]))
for f in files:
    print(*f)
open(d + "/notes.md", "w", encoding="utf-8", newline="\n").write(
    "**Android and Android TV %s.** %s\n\n**Windows, macOS, Linux %s.** %s\n\nSHA-256:\n```\n%s\n```\n" % (
        a["versionName"], a["notes"], k["version"], k["notes"], "\n".join("%s  %s" % (s, n) for n, _, s in files)))
EOF
tag=$(sed -n 1p "$d/plan" | tr -d '\r')
title=$(sed -n 2p "$d/plan" | tr -d '\r')
if gh release view "$tag" -R "$REPO" >/dev/null 2>&1; then echo "$tag is already released"; exit 0; fi
sed 1,2d "$d/plan" | tr -d '\r' | while read -r name url sha; do
  curl -fsS "$url" -o "$d/$name"
  got=$(python -c 'import hashlib,sys; print(hashlib.sha256(open(sys.argv[1],"rb").read()).hexdigest())' "$d/$name" | tr -d '\r')
  [ "$got" = "$sha" ] || { echo "$name: sha256 $got, expected $sha" >&2; exit 1; }
  echo "ok $name"
done
set -- $(sed 1,2d "$d/plan" | tr -d '\r' | while read -r name _; do echo "$d/$name"; done)
[ $# -ge 7 ] || { echo "only $# files" >&2; exit 1; }
# ponytail: the Windows installer (the README's link) is not on /dl yet: it was built and attached
# by hand, so it is carried over from the latest release as it is. Upgrade: publish it on /dl
# with desktop.json and take it from there like the rest. Until /dl has desktop 0.3,
# KosmoVPN-windows.exe from /dl is the older 0.2.2 one.
gh release download -R "$REPO" -p KosmoVPN-windows.msi -D "$d" && set -- "$@" "$d/KosmoVPN-windows.msi"
gh release create "$tag" -R "$REPO" --title "$title" --notes-file "$d/notes.md" --latest "$@"
