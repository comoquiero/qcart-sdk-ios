#!/bin/bash

# 1. Definir nombres (Asegúrate de que 'QcartSDK' es el nombre exacto de tu Scheme en Xcode)
SCHEME_NAME="QcartSDK"
WORKSPACE_NAME="QcartSDK.xcworkspace"
FRAMEWORK_NAME="QcartSDK.framework"

# Crear carpeta temporal para los archivos de compilación
mkdir -p build

echo "⚙️ Compilando para dispositivos iOS (ARM64)..."
xcodebuild archive \
  -workspace $WORKSPACE_NAME \
  -scheme $SCHEME_NAME \
  -configuration Release \
  -destination 'generic/platform=iOS' \
  -archivePath './build/QcartSDK-iphoneos.xcarchive' \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

echo "⚙️ Compilando para Simuladores iOS (x86_64 y ARM64)..."
xcodebuild archive \
  -workspace $WORKSPACE_NAME \
  -scheme $SCHEME_NAME \
  -configuration Release \
  -destination 'generic/platform=iOS Simulator' \
  -archivePath './build/QcartSDK-iphonesimulator.xcarchive' \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

echo "📦 Generando el XCFramework final..."
xcodebuild -create-xcframework \
  -framework './build/QcartSDK-iphoneos.xcarchive/Products/Library/Frameworks/'$FRAMEWORK_NAME \
  -framework './build/QcartSDK-iphonesimulator.xcarchive/Products/Library/Frameworks/'$FRAMEWORK_NAME \
  -output './build/QcartSDK.xcframework'

echo "✅ ¡Listo! Tu QcartSDK.xcframework está en la carpeta 'build/'"