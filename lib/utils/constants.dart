import 'package:flutter/material.dart';

/// App-wide constants for colors, thresholds, and configurations
class AppConstants {
  // App Info
  static const String appName = 'SMA Physio Game';
  static const String version = '1.0.0';

  // Colors
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color secondaryColor = Color(0xFF4CAF50);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  
  // Feedback Colors
  static const Color correctColor = Color(0xFF4CAF50);  // Green
  static const Color tryAgainColor = Color(0xFFFFC107); // Yellow
  static const Color incorrectColor = Color(0xFFF44336); // Red
  
  // Game Colors
  static const Color bubbleColor1 = Color(0xFFE91E63);
  static const Color bubbleColor2 = Color(0xFF9C27B0);
  static const Color bubbleColor3 = Color(0xFF2196F3);
  static const Color bubbleColor4 = Color(0xFF4CAF50);
  
  // Pose Detection Thresholds
  static const double minPoseConfidence = 0.6;
  static const double armRaiseAngleThreshold = 160.0; // degrees
  static const double armRaiseAngleTryAgain = 140.0;  // degrees
  static const double wristHeightRatio = 0.7; // Wrist should be 70% above shoulder
  
  // Game Settings
  static const int pointsPerCorrectRep = 10;
  static const int maxBubbles = 6;
  static const double bubblePopDistance = 0.15; // 15% of screen
  static const int targetRepsPerSession = 10;
  
  // Exercise Durations (seconds)
  static const int restDuration = 5;
  static const int exerciseDuration = 60;
  static const int fatigueCheckInterval = 5; // Check every 5 reps
  
  // UI Sizes
  static const double bigButtonHeight = 80.0;
  static const double bigButtonWidth = 200.0;
  static const double iconSizeLarge = 48.0;
  static const double iconSizeMedium = 32.0;
  
  // Text Styles
  static const TextStyle titleStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );
  
  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 18,
    color: Colors.black54,
  );
  
  static const TextStyle scoreStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );
  
  // Storage Keys
  static const String storageKeySessions = 'exercise_sessions';
  static const String storageKeyTotalScore = 'total_score';
  static const String storageKeyTotalReps = 'total_reps';
  static const String storageKeyLastSession = 'last_session_date';
}

/// Exercise types available in the app
enum ExerciseType {
  armRaise,
  shoulderRotation,
  neckFlexion,
}

/// Feedback types for user guidance
enum FeedbackType {
  none,
  correct,
  tryAgain,
  incorrect,
}

/// Game state for bubble pop game
enum GameState {
  idle,
  playing,
  paused,
  completed,
}
