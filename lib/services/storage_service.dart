import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sma_physio_game/models/exercise_session.dart';
import 'package:sma_physio_game/utils/constants.dart';

/// Service for local data persistence
class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  /// Initialize storage
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Save an exercise session
  Future<bool> saveSession(ExerciseSession session) async {
    try {
      final sessions = await getSessions();
      sessions.add(session);
      
      final sessionsJson = sessions.map((s) => s.toJson()).toList();
      final success = await _prefs?.setString(
        AppConstants.storageKeySessions,
        jsonEncode(sessionsJson),
      );
      
      // Update total stats
      await _updateTotalStats(session);
      
      return success ?? false;
    } catch (e) {
      print('Error saving session: $e');
      return false;
    }
  }

  /// Get all exercise sessions
  Future<List<ExerciseSession>> getSessions() async {
    try {
      final sessionsString = _prefs?.getString(AppConstants.storageKeySessions);
      
      if (sessionsString == null || sessionsString.isEmpty) {
        return [];
      }
      
      final List<dynamic> sessionsJson = jsonDecode(sessionsString);
      return sessionsJson
          .map((json) => ExerciseSession.fromJson(json))
          .toList();
    } catch (e) {
      print('Error getting sessions: $e');
      return [];
    }
  }

  /// Get sessions from last N days
  Future<List<ExerciseSession>> getRecentSessions(int days) async {
    final allSessions = await getSessions();
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    
    return allSessions
        .where((session) => session.startTime.isAfter(cutoffDate))
        .toList();
  }

  /// Get total score
  Future<int> getTotalScore() async {
    return _prefs?.getInt(AppConstants.storageKeyTotalScore) ?? 0;
  }

  /// Get total reps
  Future<int> getTotalReps() async {
    return _prefs?.getInt(AppConstants.storageKeyTotalReps) ?? 0;
  }

  /// Update total stats
  Future<void> _updateTotalStats(ExerciseSession session) async {
    final currentScore = await getTotalScore();
    final currentReps = await getTotalReps();
    
    await _prefs?.setInt(
      AppConstants.storageKeyTotalScore,
      currentScore + session.totalScore,
    );
    
    await _prefs?.setInt(
      AppConstants.storageKeyTotalReps,
      currentReps + session.totalReps,
    );
    
    await _prefs?.setString(
      AppConstants.storageKeyLastSession,
      DateTime.now().toIso8601String(),
    );
  }

  /// Get last session date
  Future<DateTime?> getLastSessionDate() async {
    final dateString = _prefs?.getString(AppConstants.storageKeyLastSession);
    if (dateString == null) return null;
    
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Clear all data
  Future<bool> clearAllData() async {
    return await _prefs?.clear() ?? false;
  }

  /// Get statistics summary
  Future<Map<String, dynamic>> getStatistics() async {
    final sessions = await getSessions();
    final totalScore = await getTotalScore();
    final totalReps = await getTotalReps();
    final lastSession = await getLastSessionDate();
    
    int totalSessions = sessions.length;
    double avgScore = totalSessions > 0 ? totalScore / totalSessions : 0.0;
    double avgReps = totalSessions > 0 ? totalReps / totalSessions : 0.0;
    
    return {
      'totalSessions': totalSessions,
      'totalScore': totalScore,
      'totalReps': totalReps,
      'avgScore': avgScore,
      'avgReps': avgReps,
      'lastSession': lastSession,
    };
  }
}
