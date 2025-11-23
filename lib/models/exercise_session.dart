import 'dart:convert';
import 'package:sma_physio_game/utils/constants.dart';
import 'package:sma_physio_game/models/pose_data.dart';

/// Represents a complete exercise session
class ExerciseSession {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final ExerciseType exerciseType;
  final List<ExerciseRepetition> repetitions;
  final int totalScore;
  final int correctReps;
  final int totalReps;
  final double averageFormQuality;
  final Duration duration;

  ExerciseSession({
    required this.id,
    required this.startTime,
    this.endTime,
    required this.exerciseType,
    required this.repetitions,
    required this.totalScore,
    required this.correctReps,
    required this.totalReps,
    required this.averageFormQuality,
    required this.duration,
  });

  /// Calculate average form quality from repetitions
  static double _calculateAverageFormQuality(List<ExerciseRepetition> reps) {
    if (reps.isEmpty) return 0.0;
    final sum = reps.fold<double>(0.0, (sum, rep) => sum + rep.formQuality);
    return sum / reps.length;
  }

  /// Create a new session
  factory ExerciseSession.create(ExerciseType type) {
    return ExerciseSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      startTime: DateTime.now(),
      exerciseType: type,
      repetitions: [],
      totalScore: 0,
      correctReps: 0,
      totalReps: 0,
      averageFormQuality: 0.0,
      duration: Duration.zero,
    );
  }

  /// Add a repetition to the session
  ExerciseSession addRepetition(ExerciseRepetition rep) {
    final newReps = List<ExerciseRepetition>.from(repetitions)..add(rep);
    final newCorrectReps = rep.isCorrect ? correctReps + 1 : correctReps;
    final newScore = rep.isCorrect ? totalScore + AppConstants.pointsPerCorrectRep : totalScore;

    return ExerciseSession(
      id: id,
      startTime: startTime,
      endTime: endTime,
      exerciseType: exerciseType,
      repetitions: newReps,
      totalScore: newScore,
      correctReps: newCorrectReps,
      totalReps: totalReps + 1,
      averageFormQuality: _calculateAverageFormQuality(newReps),
      duration: duration,
    );
  }

  /// Complete the session
  ExerciseSession complete() {
    final now = DateTime.now();
    return ExerciseSession(
      id: id,
      startTime: startTime,
      endTime: now,
      exerciseType: exerciseType,
      repetitions: repetitions,
      totalScore: totalScore,
      correctReps: correctReps,
      totalReps: totalReps,
      averageFormQuality: averageFormQuality,
      duration: now.difference(startTime),
    );
  }

  /// Get success rate as percentage
  double get successRate {
    if (totalReps == 0) return 0.0;
    return (correctReps / totalReps) * 100;
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'exerciseType': exerciseType.toString(),
      'repetitions': repetitions.map((r) => r.toJson()).toList(),
      'totalScore': totalScore,
      'correctReps': correctReps,
      'totalReps': totalReps,
      'averageFormQuality': averageFormQuality,
      'duration': duration.inSeconds,
    };
  }

  /// Create from JSON
  factory ExerciseSession.fromJson(Map<String, dynamic> json) {
    return ExerciseSession(
      id: json['id'],
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      exerciseType: ExerciseType.values.firstWhere(
        (e) => e.toString() == json['exerciseType'],
      ),
      repetitions: (json['repetitions'] as List)
          .map((r) => ExerciseRepetition.fromJson(r))
          .toList(),
      totalScore: json['totalScore'],
      correctReps: json['correctReps'],
      totalReps: json['totalReps'],
      averageFormQuality: json['averageFormQuality'],
      duration: Duration(seconds: json['duration']),
    );
  }

  /// Convert to JSON string
  String toJsonString() {
    return jsonEncode(toJson());
  }

  /// Create from JSON string
  factory ExerciseSession.fromJsonString(String jsonString) {
    return ExerciseSession.fromJson(jsonDecode(jsonString));
  }
}
