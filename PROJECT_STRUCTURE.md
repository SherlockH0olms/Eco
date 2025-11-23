# 📚 Project Structure Overview

## 📁 Repository Layout

```
Eco/
├── 📝 Documentation
│   ├── README.md              # Main project overview
│   ├── SETUP.md               # Installation guide
│   ├── QUICKSTART.md          # Quick start for demos
│   ├── PITCH.md               # Hackathon pitch deck
│   ├── TESTING.md             # Testing guide
│   ├── CONTRIBUTING.md        # Contribution guidelines
│   ├── CHANGELOG.md           # Version history
│   └── LICENSE                # MIT License
│
├── 🛠️ Configuration
│   ├── pubspec.yaml           # Flutter dependencies
│   ├── analysis_options.yaml  # Dart linter config
│   └── .gitignore             # Git ignore rules
│
├── 📱 Platform Config
│   ├── android/
│   │   ├── app/
│   │   │   ├── build.gradle       # Android build config
│   │   │   └── src/main/
│   │   │       └── AndroidManifest.xml  # Permissions
│   │   └── build.gradle       # Project build config
│   │
│   └── ios/
│       └── Runner/
│           └── Info.plist         # iOS permissions
│
├── 🎨 Assets
│   ├── sounds/
│   │   └── README.md          # Sound assets guide
│   └── images/
│       └── README.md          # Image assets guide
│
├── 🐛 GitHub
│   └── .github/
│       └── ISSUE_TEMPLATE/
│           ├── bug_report.md      # Bug report template
│           └── feature_request.md # Feature request template
│
└── 💻 Source Code (lib/)
    ├── main.dart             # App entry point
    │
    ├── 📺 screens/          # UI Screens
    │   ├── home_screen.dart
    │   ├── exercise_game_screen.dart
    │   └── caregiver_dashboard.dart
    │
    ├── 📦 models/           # Data Models
    │   ├── pose_data.dart
    │   ├── exercise_session.dart
    │   └── game_state.dart
    │
    ├── ⚙️ services/         # Business Logic
    │   ├── pose_detector_service.dart
    │   ├── angle_calculator_service.dart
    │   ├── feedback_service.dart
    │   └── storage_service.dart
    │
    ├── 🧩 widgets/          # UI Components
    │   ├── pose_painter.dart
    │   ├── bubble_game_widget.dart
    │   ├── feedback_overlay.dart
    │   └── progress_chart.dart
    │
    └── 🔧 utils/            # Utilities
        ├── constants.dart
        └── helpers.dart
```

## 📊 File Statistics

### Code Files

| Category | Files | Lines | Purpose |
|----------|-------|-------|----------|
| Screens | 3 | ~1,200 | UI screens |
| Models | 3 | ~400 | Data structures |
| Services | 4 | ~800 | Business logic |
| Widgets | 4 | ~600 | UI components |
| Utils | 2 | ~200 | Helpers |
| **Total** | **16** | **~3,200** | Core app |

### Documentation Files

| File | Lines | Purpose |
|------|-------|----------|
| README.md | ~200 | Main overview |
| SETUP.md | ~80 | Installation |
| PITCH.md | ~180 | Hackathon pitch |
| TESTING.md | ~150 | Test guide |
| QUICKSTART.md | ~120 | Quick demo |
| CONTRIBUTING.md | ~100 | Contribution |
| **Total** | **~830** | Documentation |

## 🔍 Component Details

### 📺 Screens (UI Layer)

#### 1. `home_screen.dart`
- **Purpose**: Welcome screen and exercise selection
- **Features**:
  - Display statistics summary
  - Exercise type selection buttons
  - Navigation to dashboard
  - Gradient background
- **Dependencies**: StorageService, Constants

#### 2. `exercise_game_screen.dart`
- **Purpose**: Main game with pose detection
- **Features**:
  - Camera preview
  - Real-time pose tracking
  - Bubble pop game
  - Score/rep tracking
  - Feedback overlay
  - Session completion
- **Dependencies**: All services, all widgets

#### 3. `caregiver_dashboard.dart`
- **Purpose**: Progress tracking for caregivers
- **Features**:
  - Time period selector (7/14/30/90 days)
  - Summary statistics cards
  - Progress charts
  - Session history list
  - Overall statistics
- **Dependencies**: StorageService, ProgressChartWidget

### 📦 Models (Data Layer)

#### 1. `pose_data.dart`
- **Classes**: `PoseData`, `ExerciseRepetition`
- **Purpose**: Wrapper for pose detection data
- **Key Methods**:
  - `getLandmark()`: Get specific joint
  - `isValid`: Check pose confidence
  - `toJson()`/`fromJson()`: Serialization

#### 2. `exercise_session.dart`
- **Class**: `ExerciseSession`
- **Purpose**: Track complete exercise session
- **Key Methods**:
  - `create()`: Start new session
  - `addRepetition()`: Add rep to session
  - `complete()`: Finalize session
  - `successRate`: Calculate accuracy %

#### 3. `game_state.dart`
- **Classes**: `GameStateModel`, `Bubble`
- **Purpose**: Manage game state with Provider
- **Key Methods**:
  - `startGame()`, `pauseGame()`, `completeGame()`
  - `addScore()`, `incrementCorrectReps()`
  - `setFeedback()`, `popBubble()`

### ⚙️ Services (Business Layer)

#### 1. `pose_detector_service.dart`
- **Purpose**: MediaPipe pose detection
- **Key Methods**:
  - `detectPose()`: Process camera frame
  - `_convertToInputImage()`: Format conversion
  - `_calculatePoseConfidence()`: Quality check
- **Tech**: Google ML Kit

#### 2. `angle_calculator_service.dart`
- **Purpose**: Calculate joint angles
- **Key Methods**:
  - `calculateAngle()`: 3-point angle calculation
  - `isArmRaiseCorrect()`: Validate arm raise
  - `getArmRaiseQuality()`: Detailed feedback
- **Algorithms**: Vector math, trigonometry

#### 3. `feedback_service.dart`
- **Purpose**: Real-time exercise feedback
- **Key Methods**:
  - `evaluatePose()`: Analyze form quality
  - `_evaluateArmRaise()`: Exercise-specific
  - `getEncouragementMessage()`: Motivational text
- **Output**: `FeedbackResult` with type, message, quality

#### 4. `storage_service.dart`
- **Purpose**: Local data persistence
- **Key Methods**:
  - `saveSession()`: Store session
  - `getSessions()`: Retrieve all
  - `getRecentSessions()`: Filter by date
  - `getStatistics()`: Aggregate stats
- **Tech**: SharedPreferences

### 🧩 Widgets (Component Layer)

#### 1. `pose_painter.dart`
- **Purpose**: Draw skeleton overlay
- **Features**:
  - Custom painter for joints
  - Connection lines between landmarks
  - Coordinate translation
- **Usage**: Overlay on camera preview

#### 2. `bubble_game_widget.dart`
- **Purpose**: Animated bubble display
- **Features**:
  - Floating bubble animations
  - Pop effects with confetti
  - Dynamic bubble generation
- **Tech**: AnimationController, CustomPaint

#### 3. `feedback_overlay.dart`
- **Purpose**: Visual feedback display
- **Features**:
  - Color-coded feedback (Green/Yellow/Red)
  - Animated entry/exit
  - Icon + message display
- **States**: Correct, Try Again, Incorrect, None

#### 4. `progress_chart.dart`
- **Purpose**: Data visualization
- **Features**:
  - Line charts for progress
  - Statistics cards
  - Empty state handling
- **Tech**: FL Chart library

### 🔧 Utils (Helper Layer)

#### 1. `constants.dart`
- **Purpose**: App-wide constants
- **Contents**:
  - Colors (primary, secondary, feedback)
  - Thresholds (angles, confidence, distances)
  - Game settings (points, target reps)
  - UI sizes and text styles
  - Enums (ExerciseType, FeedbackType, GameState)

#### 2. `helpers.dart`
- **Purpose**: Utility functions
- **Functions**:
  - Date/time formatting
  - Distance calculations
  - Percentage calculations
  - Encouragement message generation
  - Form quality scoring

## 🔄 Data Flow

```
Camera Feed
    ↓
PoseDetectorService
    ↓
AngleCalculatorService
    ↓
FeedbackService
    ↓
GameStateModel (Provider)
    ↓
UI Updates
    ↓
StorageService
```

## 📦 Dependencies

### Core Flutter Packages
- `flutter`: Framework
- `camera`: Camera access
- `provider`: State management

### ML/AI Packages
- `google_mlkit_pose_detection`: Pose tracking

### UI/UX Packages
- `fl_chart`: Data visualization
- `confetti`: Celebration effects
- `audioplayers`: Sound effects

### Storage
- `shared_preferences`: Local persistence

### Utils
- `intl`: Date formatting
- `cupertino_icons`: iOS icons

## 📊 Architecture Pattern

**Pattern**: Clean Architecture + Provider State Management

```
┌───────────────────────┐
│   Presentation Layer    │  ← Screens, Widgets
├───────────────────────┤
│   State Management     │  ← Provider (GameState)
├───────────────────────┤
│   Business Logic       │  ← Services
├───────────────────────┤
│   Data Layer           │  ← Models, Storage
├───────────────────────┤
│   External Services    │  ← ML Kit, Camera
└───────────────────────┘
```

## 🔐 Key Design Decisions

1. **Local-First Storage**: Privacy + offline support
2. **Provider State Management**: Simple, Flutter-native
3. **Service Layer Pattern**: Separation of concerns
4. **MediaPipe over Custom ML**: Proven, optimized
5. **Rule-Based Validation**: Fast, no training needed (MVP)

## 🚀 Future Enhancements

- [ ] Add `test/` directory with unit tests
- [ ] Add `docs/` for API documentation
- [ ] Implement `lib/l10n/` for i18n
- [ ] Create `lib/api/` for cloud sync
- [ ] Add `lib/ai/` for advanced ML models

---

**Last Updated**: 2025-11-23
