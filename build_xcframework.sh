#!/bin/bash

# 1. Define target names (Ensure 'QcartSDK' is the exact name of your Xcode Scheme)
SCHEME_NAME="QcartSDK"
WORKSPACE_NAME="QcartSDK.xcworkspace"

# Clean and create a temporary build folder
rm -rf build
mkdir -p build

# --- 1. BUILD FOR PHYSICAL DEVICE (iOS ARM64) ---
echo "⚙️ Building for iOS devices (ARM64)..."
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

echo "🚑 Rescuing the .swiftmodule (iOS)..."
FRAMEWORK_IOS=$(find ./build/QcartSDK-iphoneos.xcarchive -name "*.framework" -type d | head -n 1)
mkdir -p "$FRAMEWORK_IOS/Modules"

# Search for the swiftmodule in Derived Data or inside the Archive
MODULE_IOS=$(find ./build/dd-ios ./build/QcartSDK-iphoneos.xcarchive -name "*.swiftmodule" -type d | head -n 1)
if [ -n "$MODULE_IOS" ]; then
  echo "✅ Module copied from: $MODULE_IOS"
  cp -R "$MODULE_IOS" "$FRAMEWORK_IOS/Modules/"
else
  echo "❌ FATAL ERROR: The iOS .swiftmodule was not found."
  exit 1
fi

# --- 2. BUILD FOR SIMULATOR (x86_64 and ARM64) ---
echo "⚙️ Building for iOS Simulators (x86_64 and ARM64)..."
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
  SWIFT_EMIT_MODULE_INTERFACE=YES \
  OTHER_SWIFT_FLAGS="-enable-library-evolution -emit-module-interface"

echo "🚑 Rescuing the .swiftmodule (Simulator)..."
FRAMEWORK_SIM=$(find ./build/QcartSDK-iphonesimulator.xcarchive -name "*.framework" -type d | head -n 1)
mkdir -p "$FRAMEWORK_SIM/Modules"

# Search for the swiftmodule in Derived Data or inside the Archive
MODULE_SIM=$(find ./build/dd-sim ./build/QcartSDK-iphonesimulator.xcarchive -name "*.swiftmodule" -type d | head -n 1)
if [ -n "$MODULE_SIM" ]; then
  echo "✅ Module copied from: $MODULE_SIM"
  cp -R "$MODULE_SIM" "$FRAMEWORK_SIM/Modules/"
else
  echo "❌ FATAL ERROR: The Simulator .swiftmodule was not found."
  exit 1
fi

# --- 3. CREATE FINAL XCFRAMEWORK ---
echo "📦 Generating the final XCFramework..."
xcodebuild -create-xcframework \
  -framework "$FRAMEWORK_IOS" \
  -framework "$FRAMEWORK_SIM" \
  -output './build/QcartSDK.xcframework'

echo "✅ Done! Your bulletproof QcartSDK.xcframework is located in the 'build/' folder."