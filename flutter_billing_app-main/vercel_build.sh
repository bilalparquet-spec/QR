#!/bin/bash
set -e

echo "==> Fetching Flutter SDK (stable channel)..."
git clone https://github.com/flutter/flutter.git -b stable --depth 1
export PATH="$PATH:$PWD/flutter/bin"

echo "==> Flutter doctor"
flutter doctor -v

echo "==> Enabling web support"
flutter config --enable-web --no-analytics

echo "==> Fetching packages"
flutter pub get

echo "==> Generating localizations (AppLocalizations from lib/l10n/*.arb)"
flutter gen-l10n

echo "==> Building release web bundle"
flutter build web --release

echo "==> Done. Output in build/web"
