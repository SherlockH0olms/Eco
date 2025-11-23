# Testing Guide

## Manual Testing Checklist

### ✅ Home Screen
- [ ] App launches without errors
- [ ] Statistics display correctly (or show "No data")
- [ ] "Arm Raise Game" button is clickable
- [ ] "Shoulder Rotation" button is disabled (Coming Soon)
- [ ] "View Progress" button navigates to dashboard
- [ ] Stats update after completing a session

### ✅ Exercise Game Screen

#### Camera & Pose Detection
- [ ] Camera permission requested on first launch
- [ ] Camera preview shows correctly
- [ ] Skeleton overlay appears when person detected
- [ ] Skeleton tracks movements accurately
- [ ] No skeleton when no person in frame

#### Game Mechanics
- [ ] Bubbles appear on screen
- [ ] Bubbles animate (floating motion)
- [ ] Correct arm raise pops a bubble
- [ ] Score increases on correct rep
- [ ] Rep counter increases
- [ ] Progress bar updates

#### Feedback System
- [ ] Green feedback for correct form
- [ ] Yellow feedback for "try again"
- [ ] Red feedback for incorrect form
- [ ] Feedback messages display properly
- [ ] Feedback disappears after 2 seconds

#### Session Completion
- [ ] Confetti plays at milestones (5, 10 reps)
- [ ] Completion dialog shows at target reps
- [ ] Score displayed correctly in dialog
- [ ] "Done" button exits to home
- [ ] "Play Again" starts new session
- [ ] Session saved to storage

#### Controls
- [ ] Back button shows exit confirmation
- [ ] Pause button pauses detection
- [ ] Resume button resumes detection
- [ ] Exit saves partial progress

### ✅ Caregiver Dashboard

#### Data Display
- [ ] Shows "No data" when no sessions
- [ ] Summary cards display correct stats
- [ ] Time period selector works (7/14/30/90 days)
- [ ] Progress chart renders correctly
- [ ] Recent sessions list shows all sessions

#### Session Cards
- [ ] Date and time display correctly
- [ ] Success rate calculated properly
- [ ] Success rate color coding (green/yellow/red)
- [ ] Reps, score, duration show correctly

#### Overall Statistics
- [ ] Total sessions count accurate
- [ ] Total score accumulates correctly
- [ ] Total reps accumulates correctly
- [ ] Average calculations correct
- [ ] Last session date displays

### ✅ Performance
- [ ] Pose detection runs at 20+ FPS
- [ ] No lag when popping bubbles
- [ ] App doesn't crash after 5 minutes
- [ ] Memory usage stays stable
- [ ] Battery drain is acceptable

### ✅ Edge Cases

#### Poor Conditions
- [ ] Works in low light (with degraded accuracy)
- [ ] Handles multiple people in frame (uses first)
- [ ] Recovers when person leaves/returns to frame
- [ ] Handles phone rotation gracefully

#### Data Persistence
- [ ] Sessions saved after crash
- [ ] Data persists after app restart
- [ ] Large session count (100+) loads quickly

## Automated Testing

### Unit Tests

```bash
flutter test test/services/angle_calculator_test.dart
flutter test test/services/storage_service_test.dart
```

### Widget Tests

```bash
flutter test test/widgets/feedback_overlay_test.dart
flutter test test/widgets/progress_chart_test.dart
```

## Performance Testing

### FPS Measurement

1. Enable performance overlay:
   ```dart
   MaterialApp(
     showPerformanceOverlay: true,
   )
   ```

2. Target: Green bars (60 FPS), acceptable: Yellow (30 FPS)

### Memory Profiling

1. Run with DevTools:
   ```bash
   flutter run --profile
   ```

2. Monitor memory usage in DevTools
3. Look for memory leaks (increasing trend)

## Device Testing Matrix

### Minimum Requirements
- Android 5.0 (API 21+)
- 2GB RAM
- Rear camera

### Recommended Testing Devices

| Device | OS | Status |
|--------|----|---------|
| Pixel 6 | Android 13 | ✅ Primary |
| Samsung A52 | Android 12 | ✅ Mid-range |
| iPhone 12 | iOS 16 | ✅ iOS |
| Old device | Android 8 | ⚠️ Edge case |

## Known Issues

### Camera Issues
- **Issue**: Black screen on some Android devices
- **Workaround**: Restart app, grant permissions manually

### Pose Detection
- **Issue**: Tracking fails in very low light
- **Solution**: Guide users to ensure good lighting

### Performance
- **Issue**: Lag on emulators
- **Solution**: Always test on real devices

## Demo Day Testing

### Pre-Demo Checklist (30 min before)
- [ ] Phone fully charged
- [ ] Test in demo location lighting
- [ ] Clear all previous test data (or prepare with good data)
- [ ] Position phone mount at chest height
- [ ] Test complete flow 2-3 times
- [ ] Have backup device ready

### Demo Setup
- **Lighting**: Bright, even lighting from front
- **Background**: Plain wall, no clutter
- **Camera Distance**: 1.5-2 meters from subject
- **Camera Height**: Chest level
- **Clothing**: Contrasting colors (avoid all black/white)

## Reporting Bugs

If you find issues:

1. Check if it's a known issue above
2. Try reproducing 2-3 times
3. Note device, OS version, steps to reproduce
4. Open GitHub issue with details

---

**Happy Testing! 🧪**
