# Setup Instructions

## Prerequisites

- Flutter SDK (>=3.0.0)
- Android Studio or VS Code
- Android device/emulator (API 21+) or iOS device/simulator

## Installation Steps

### 1. Clone Repository

```bash
git clone https://github.com/SherlockH0olms/Eco.git
cd Eco
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Add Sound Assets (Optional)

Download free game sounds and place them in:
- `assets/sounds/pop.mp3`
- `assets/sounds/success.mp3`
- `assets/sounds/complete.mp3`

### 4. Run on Device

#### Android

```bash
flutter run
```

#### iOS

```bash
cd ios
pod install
cd ..
flutter run
```

## Troubleshooting

### Camera Permission Issues

**Android:**
- Check `android/app/src/main/AndroidManifest.xml` has camera permissions
- Manually grant camera permission in device settings

**iOS:**
- Check `ios/Runner/Info.plist` has `NSCameraUsageDescription`
- Manually grant camera permission when prompted

### Build Errors

**ML Kit Issues:**
```bash
flutter clean
flutter pub get
flutter run
```

**Android Gradle Issues:**
- Update Android SDK to API 34+
- Update Android Studio
- Update Gradle wrapper

### Performance Issues

**Pose Detection Lag:**
- Use physical device (emulator is slow)
- Reduce camera resolution in code (ResolutionPreset.low)
- Ensure good lighting conditions

## Running Tests

```bash
flutter test
```

## Building Release APK

```bash
flutter build apk --release
```

APK will be at: `build/app/outputs/flutter-apk/app-release.apk`

## Building iOS App

```bash
flutter build ios --release
```

Then open Xcode and archive for App Store.

## Hackathon Demo Tips

1. **Test on Real Device**: Emulators are too slow for pose detection
2. **Good Lighting**: Ensure bright, even lighting for best tracking
3. **Camera Angle**: Position camera to see full upper body
4. **Wear Contrasting Clothes**: Helps with pose detection accuracy
5. **Stable Phone Mount**: Use tripod or phone stand for hands-free demo

## Next Steps

- Add more exercise types (shoulder rotation, neck flexion)
- Implement cloud sync with Firebase
- Add therapist remote monitoring
- Implement AI fatigue detection
- Add multi-language support
