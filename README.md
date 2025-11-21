# Flutter App

A simple Flutter application with a counter demo.

## Prerequisites

Before running this app, make sure you have Flutter installed on your system. If you haven't installed Flutter yet, follow these steps:

1. Download Flutter SDK from [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
2. Extract the zip file to your desired location
3. Add Flutter to your PATH
4. Run `flutter doctor` to verify the installation

## Getting Started

1. **Clone or download this repository**

2. **Get Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   
   For running on an emulator or physical device:
   ```bash
   flutter run
   ```
   
   Make sure you have an emulator running or a physical device connected via USB with developer mode enabled.

## Platform-Specific Setup

### Android

- Install Android Studio
- Install Android SDK (API 21 or higher)
- Create an Android emulator or enable USB debugging on a physical device

### iOS (macOS only)

- Install Xcode from the App Store
- Install CocoaPods: `sudo gem install cocoapods`
- Open the iOS project: `cd ios && pod install && cd ..`

## Project Structure

```
flutter_app/
├── lib/
│   └── main.dart          # Main application entry point
├── android/               # Android platform files
├── ios/                   # iOS platform files
├── pubspec.yaml           # Flutter dependencies and configuration
└── README.md              # This file
```

## Features

- Simple counter app that demonstrates basic Flutter state management
- Material Design 3 UI
- Responsive layout

## Building for Release

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## Troubleshooting

- If you encounter issues, run `flutter doctor` to check for missing dependencies
- For Android, ensure you have Java installed (JDK 8 or higher)
- For iOS, ensure you have Xcode and CocoaPods installed
- Run `flutter clean` if you encounter build issues

## Learn More

- [Flutter Documentation](https://flutter.dev/docs)
- [Flutter Cookbook](https://flutter.dev/docs/cookbook)
- [Flutter Samples](https://github.com/flutter/flutter/tree/master/examples)

