#!/bin/bash

echo ' 🔄 Updating dependencies...'
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs

cd example/sign/

echo ' ⬇️ Getting dependencies...'
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
