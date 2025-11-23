import 'dart:math';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:sma_physio_game/utils/constants.dart';

/// Service for calculating joint angles from pose landmarks
class AngleCalculatorService {
  /// Calculate angle between three points (in degrees)
  double calculateAngle(
    PoseLandmark point1,
    PoseLandmark point2,
    PoseLandmark point3,
  ) {
    // Create vectors
    final vector1 = Point(point1.x - point2.x, point1.y - point2.y);
    final vector2 = Point(point3.x - point2.x, point3.y - point2.y);
    
    // Calculate dot product
    final dotProduct = vector1.x * vector2.x + vector1.y * vector2.y;
    
    // Calculate magnitudes
    final magnitude1 = sqrt(pow(vector1.x, 2) + pow(vector1.y, 2));
    final magnitude2 = sqrt(pow(vector2.x, 2) + pow(vector2.y, 2));
    
    // Calculate angle in radians
    final angleRad = acos(dotProduct / (magnitude1 * magnitude2));
    
    // Convert to degrees
    return angleRad * 180 / pi;
  }

  /// Check if arm raise exercise is performed correctly
  bool isArmRaiseCorrect(Pose pose, {bool useLeftArm = true}) {
    try {
      final shoulder = useLeftArm
          ? pose.landmarks[PoseLandmarkType.leftShoulder]
          : pose.landmarks[PoseLandmarkType.rightShoulder];
      
      final elbow = useLeftArm
          ? pose.landmarks[PoseLandmarkType.leftElbow]
          : pose.landmarks[PoseLandmarkType.rightElbow];
      
      final wrist = useLeftArm
          ? pose.landmarks[PoseLandmarkType.leftWrist]
          : pose.landmarks[PoseLandmarkType.rightWrist];

      if (shoulder == null || elbow == null || wrist == null) {
        return false;
      }

      // Calculate arm angle (should be extended, ~180 degrees)
      final armAngle = calculateAngle(shoulder, elbow, wrist);
      
      // Check if arm is extended
      final isExtended = armAngle > AppConstants.armRaiseAngleThreshold;
      
      // Check if wrist is above shoulder
      final isRaised = wrist.y < shoulder.y;
      
      return isExtended && isRaised;
    } catch (e) {
      return false;
    }
  }

  /// Get arm raise quality (returns angle and whether it's correct)
  Map<String, dynamic> getArmRaiseQuality(Pose pose, {bool useLeftArm = true}) {
    try {
      final shoulder = useLeftArm
          ? pose.landmarks[PoseLandmarkType.leftShoulder]
          : pose.landmarks[PoseLandmarkType.rightShoulder];
      
      final elbow = useLeftArm
          ? pose.landmarks[PoseLandmarkType.leftElbow]
          : pose.landmarks[PoseLandmarkType.rightElbow];
      
      final wrist = useLeftArm
          ? pose.landmarks[PoseLandmarkType.leftWrist]
          : pose.landmarks[PoseLandmarkType.rightWrist];

      if (shoulder == null || elbow == null || wrist == null) {
        return {
          'angle': 0.0,
          'feedback': FeedbackType.none,
          'isCorrect': false,
        };
      }

      final armAngle = calculateAngle(shoulder, elbow, wrist);
      final isRaised = wrist.y < shoulder.y;
      
      FeedbackType feedback;
      bool isCorrect = false;
      
      if (armAngle > AppConstants.armRaiseAngleThreshold && isRaised) {
        feedback = FeedbackType.correct;
        isCorrect = true;
      } else if (armAngle > AppConstants.armRaiseAngleTryAgain && isRaised) {
        feedback = FeedbackType.tryAgain;
      } else {
        feedback = FeedbackType.incorrect;
      }
      
      return {
        'angle': armAngle,
        'feedback': feedback,
        'isCorrect': isCorrect,
      };
    } catch (e) {
      return {
        'angle': 0.0,
        'feedback': FeedbackType.none,
        'isCorrect': false,
      };
    }
  }

  /// Calculate shoulder angle
  double? calculateShoulderAngle(Pose pose, {bool useLeft = true}) {
    try {
      final shoulder = useLeft
          ? pose.landmarks[PoseLandmarkType.leftShoulder]
          : pose.landmarks[PoseLandmarkType.rightShoulder];
      
      final elbow = useLeft
          ? pose.landmarks[PoseLandmarkType.leftElbow]
          : pose.landmarks[PoseLandmarkType.rightElbow];
      
      final hip = useLeft
          ? pose.landmarks[PoseLandmarkType.leftHip]
          : pose.landmarks[PoseLandmarkType.rightHip];

      if (shoulder == null || elbow == null || hip == null) {
        return null;
      }

      return calculateAngle(hip, shoulder, elbow);
    } catch (e) {
      return null;
    }
  }

  /// Check if both arms are raised
  bool areBothArmsRaised(Pose pose) {
    return isArmRaiseCorrect(pose, useLeftArm: true) &&
           isArmRaiseCorrect(pose, useLeftArm: false);
  }
}
