import 'package:sma_physio_game/utils/constants.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:sma_physio_game/services/angle_calculator_service.dart';

/// Service for providing real-time feedback on exercise form
class FeedbackService {
  final AngleCalculatorService _angleCalculator = AngleCalculatorService();

  /// Evaluate pose and return feedback
  FeedbackResult evaluatePose(Pose pose, ExerciseType exerciseType) {
    switch (exerciseType) {
      case ExerciseType.armRaise:
        return _evaluateArmRaise(pose);
      case ExerciseType.shoulderRotation:
        return _evaluateShoulderRotation(pose);
      case ExerciseType.neckFlexion:
        return _evaluateNeckFlexion(pose);
      default:
        return FeedbackResult(
          feedbackType: FeedbackType.none,
          message: '',
          formQuality: 0.0,
        );
    }
  }

  /// Evaluate arm raise exercise
  FeedbackResult _evaluateArmRaise(Pose pose) {
    final leftArmQuality = _angleCalculator.getArmRaiseQuality(pose, useLeftArm: true);
    final rightArmQuality = _angleCalculator.getArmRaiseQuality(pose, useLeftArm: false);
    
    // Use the better arm (some patients may have one side weaker)
    final leftAngle = leftArmQuality['angle'] as double;
    final rightAngle = rightArmQuality['angle'] as double;
    final bestAngle = leftAngle > rightAngle ? leftAngle : rightAngle;
    
    final leftFeedback = leftArmQuality['feedback'] as FeedbackType;
    final rightFeedback = rightArmQuality['feedback'] as FeedbackType;
    final bestFeedback = leftAngle > rightAngle ? leftFeedback : rightFeedback;
    
    String message;
    double formQuality;
    
    switch (bestFeedback) {
      case FeedbackType.correct:
        message = '🎉 Perfect! Great form!';
        formQuality = 1.0;
        break;
      case FeedbackType.tryAgain:
        message = '💪 Almost there! Lift a bit higher!';
        formQuality = 0.7;
        break;
      case FeedbackType.incorrect:
        message = '❗ Keep your arm straight and lift higher!';
        formQuality = 0.3;
        break;
      default:
        message = '';
        formQuality = 0.0;
    }
    
    return FeedbackResult(
      feedbackType: bestFeedback,
      message: message,
      formQuality: formQuality,
      angle: bestAngle,
    );
  }

  /// Evaluate shoulder rotation exercise
  FeedbackResult _evaluateShoulderRotation(Pose pose) {
    // Placeholder for shoulder rotation evaluation
    // This would check circular motion patterns
    return FeedbackResult(
      feedbackType: FeedbackType.none,
      message: 'Shoulder rotation coming soon!',
      formQuality: 0.0,
    );
  }

  /// Evaluate neck flexion exercise
  FeedbackResult _evaluateNeckFlexion(Pose pose) {
    // Placeholder for neck flexion evaluation
    return FeedbackResult(
      feedbackType: FeedbackType.none,
      message: 'Neck flexion coming soon!',
      formQuality: 0.0,
    );
  }

  /// Get encouragement message based on progress
  String getEncouragementMessage(int correctReps, int targetReps) {
    final progress = correctReps / targetReps;
    
    if (progress >= 1.0) {
      return '🏆 Fantastic! You completed your goal!';
    } else if (progress >= 0.75) {
      return '🚀 Amazing! Almost at your goal!';
    } else if (progress >= 0.5) {
      return '⭐ Great job! Halfway there!';
    } else if (progress >= 0.25) {
      return '💪 Good start! Keep going!';
    } else {
      return '🌟 Let\'s begin! You can do this!';
    }
  }
}

/// Result of feedback evaluation
class FeedbackResult {
  final FeedbackType feedbackType;
  final String message;
  final double formQuality; // 0.0 to 1.0
  final double? angle;

  FeedbackResult({
    required this.feedbackType,
    required this.message,
    required this.formQuality,
    this.angle,
  });
}
