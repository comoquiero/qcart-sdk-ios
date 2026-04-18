#!/bin/bash

# 1. Definir nombres (Asegúrate de que 'QcartSDK' es el nombre exacto de tu Scheme en Xcode)
SCHEME_NAME="QcartSDK"
WORKSPACE_NAME="QcartSDK.xcworkspace"

# Crear carpeta temporal para los archivos de compilación
mkdir -p build

# --- 1. COMPILAR PARA IPHONE FISICO ---
echo "⚙️ Compilando para dispositivos iOS (ARM64)..."
xcodebuild archive \
  -workspace $WORKSPACE_NAME \
  -scheme $SCHEME_NAME \
  -configuration Release \
  -destination 'generic/platform=iOS' \
  -archivePath './build/QcartSDK-iphoneos.xcarchive' \
  -derivedDataPath './build/dd-ios' \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  DEFINES_MODULE=YES \
  SWIFT_EMIT_MODULE_INTERFACE=YES \
  OTHER_SWIFT_FLAGS="-enable-library-evolution -emit-module-interface"

# 🚑 FIX APPLE BUG: Rescatar el .swiftmodule oculto y meterlo a la fuerza en el Framework
FRAMEWORK_IOS=$(find ./build/QcartSDK-iphoneos.xcarchive -name "$SCHEME_NAME.framework" | head -n 1)
mkdir -p "$FRAMEWORK_IOS/Modules"
find ./build/dd-ios -name "$SCHEME_NAME.swiftmodule" -type d -exec cp -r {} "$FRAMEWORK_IOS/Modules/" \;

# --- 2. COMPILAR PARA SIMULADOR ---
echo "⚙️ Compilando para Simuladores iOS (x86_64 y ARM64)..."
xcodebuild archive \
  -workspace $WORKSPACE_NAME \
  -scheme $SCHEME_NAME \
  -configuration Release \
  -destination 'generic/platform=iOS Simulator' \
  -archivePath './build/QcartSDK-iphonesimulator.xcarchive' \
  -derivedDataPath './build/dd-sim' \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  DEFINES_MODULE=YES \
  SWIFT_EMIT_MODULE_INTERFACE=YES\
  OTHER_SWIFT_FLAGS="-enable-library-evolution -emit-module-interface"

# 🚑 FIX APPLE BUG: Rescatar el .swiftmodule oculto y meterlo a la fuerza en el Framework
FRAMEWORK_SIM=$(find ./build/QcartSDK-iphonesimulator.xcarchive -name "$SCHEME_NAME.framework" | head -n 1)
mkdir -p "$FRAMEWORK_SIM/Modules"
find ./build/dd-sim -name "$SCHEME_NAME.swiftmodule" -type d -exec cp -r {} "$FRAMEWORK_SIM/Modules/" \;

echo "🔍 Buscando las rutas exactas de los frameworks compilados..."
FRAMEWORK_IOS=$(find ./build/QcartSDK-iphoneos.xcarchive -name "*.framework" -type d | head -n 1)
FRAMEWORK_SIM=$(find ./build/QcartSDK-iphonesimulator.xcarchive -name "*.framework" -type d | head -n 1)

echo "-> Framework iOS encontrado en: $FRAMEWORK_IOS"
echo "-> Framework Simulador encontrado en: $FRAMEWORK_SIM"

# Verificamos si realmente se encontraron los archivos
if [ -z "$FRAMEWORK_IOS" ] || [ -z "$FRAMEWORK_SIM" ]; then
  echo "❌ ERROR: No se encontró ningún archivo .framework en los archivos compilados."
  echo "Asegúrate de que el 'Mach-O Type' en Xcode esté configurado como 'Dynamic Library'."
  exit 1
fi

echo "📦 Generando el XCFramework final..."
xcodebuild -create-xcframework \
  -framework "$FRAMEWORK_IOS" \
  -framework "$FRAMEWORK_SIM" \
  -output './build/QcartSDK.xcframework'

echo "✅ ¡Listo! Tu QcartSDK.xcframework está en la carpeta 'build/'"