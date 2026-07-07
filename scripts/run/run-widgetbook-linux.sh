#!/bin/bash
set -e

cd "$(dirname "$0")/../manabi_do"
flutter run -t lib/widgetbook.dart -d linux
