import 'dart:math';
import 'package:intl/intl.dart';

/// Helper functions for the app
class Helpers {
  /// Format date to readable string
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
  
  /// Format time to readable string
  static String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }
  
  /// Format duration to minutes:seconds
  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
  
  /// Calculate distance between two points
  static double calculateDistance(double x1, double y1, double x2, double y2) {
    return sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));
  }
  
  /// Generate random color
  static int getRandomColor() {
    final random = Random();
    return 0xFF000000 + random.nextInt(0xFFFFFF);
  }
  
  /// Calculate percentage
  static double calculatePercentage(int value, int total) {
    if (total == 0) return 0.0;
    return (value / total) * 100;
  }
  
  /// Get encouragement message based on progress
  static String getEncouragementMessage(int reps, int target) {
    final percentage = calculatePercentage(reps, target);
    
    if (percentage >= 100) {
      return '🎉 Amazing! Target completed!';
    } else if (percentage >= 75) {
      return '💪 Almost there! Keep going!';
    } else if (percentage >= 50) {
      return '🚀 Great progress! You\'re halfway!';
    } else if (percentage >= 25) {
      return '⭐ Good start! Keep it up!';
    } else {
      return '🌟 Let\'s begin! You can do it!';
    }
  }
  
  /// Validate exercise form quality (0.0 to 1.0)
  static double calculateFormQuality(double angle, double targetAngle, double tolerance) {
    final difference = (angle - targetAngle).abs();
    if (difference <= tolerance) {
      return 1.0; // Perfect form
    } else if (difference <= tolerance * 2) {
      return 0.7; // Good form
    } else if (difference <= tolerance * 3) {
      return 0.4; // Needs improvement
    } else {
      return 0.0; // Incorrect form
    }
  }
}
