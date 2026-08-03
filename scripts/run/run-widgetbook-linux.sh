#!/bin/bash
set -e

cd "$(dirname "$(realpath "$0")")/../../manabi_do"
flutter run -t lib/widgetbook.dart -d linux
