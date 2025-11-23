import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

/// Wrapper class for pose detection data
class PoseData {
  final Pose? pose;
  final DateTime timestamp;
  final Map<String, double> angles;
  final double confidence;

  PoseData({
    required this.pose,
    required this.timestamp,
    required this.angles,
    required this.confidence,
  });

  /// Extract specific landmark from pose
  PoseLandmark? getLandmark(PoseLandmarkType type) {
    return pose?.landmarks[type];
  }

  /// Check if pose is valid for analysis
  bool get isValid {
    return pose != null && confidence >= 0.6;
  }

  /// Get all landmarks as a map
  Map<PoseLandmarkType, PoseLandmark>? get landmarks {
    return pose?.landmarks;
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'angles': angles,
      'confidence': confidence,
    };
  }

  /// Create from JSON
  factory PoseData.fromJson(Map<String, dynamic> json) {
    return PoseData(
      pose: null, // Cannot reconstruct from JSON
      timestamp: DateTime.parse(json['timestamp']),
      angles: Map<String, double>.from(json['angles']),
      confidence: json['confidence'],
    );
  }
}

/// Represents a single repetition of an exercise
class ExerciseRepetition {
  final int repNumber;
  final DateTime timestamp;
  final double formQuality; // 0.0 to 1.0
  final double angle;
  final bool isCorrect;

  ExerciseRepetition({
    required this.repNumber,
    required this.timestamp,
    required this.formQuality,
    required this.angle,
    required this.isCorrect,
  });

  Map<String, dynamic> toJson() {
    return {
      'repNumber': repNumber,
      'timestamp': timestamp.toIso8601String(),
      'formQuality': formQuality,
      'angle': angle,
      'isCorrect': isCorrect,
    };
  }

  factory ExerciseRepetition.fromJson(Map<String, dynamic> json) {
    return ExerciseRepetition(
      repNumber: json['repNumber'],
      timestamp: DateTime.parse(json['timestamp']),
      formQuality: json['formQuality'],
      angle: json['angle'],
      isCorrect: json['isCorrect'],
    );
  }
}
