import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sma_physio_game/utils/constants.dart';

/// Represents the state of the bubble pop game
class GameStateModel with ChangeNotifier {
  GameState _state = GameState.idle;
  int _score = 0;
  int _correctReps = 0;
  int _totalReps = 0;
  List<Bubble> _bubbles = [];
  FeedbackType _currentFeedback = FeedbackType.none;
  DateTime? _sessionStartTime;

  // Getters
  GameState get state => _state;
  int get score => _score;
  int get correctReps => _correctReps;
  int get totalReps => _totalReps;
  List<Bubble> get bubbles => _bubbles;
  FeedbackType get currentFeedback => _currentFeedback;
  Duration? get sessionDuration {
    if (_sessionStartTime == null) return null;
    return DateTime.now().difference(_sessionStartTime!);
  }

  /// Start a new game session
  void startGame() {
    _state = GameState.playing;
    _score = 0;
    _correctReps = 0;
    _totalReps = 0;
    _sessionStartTime = DateTime.now();
    _generateBubbles();
    notifyListeners();
  }

  /// Pause the game
  void pauseGame() {
    _state = GameState.paused;
    notifyListeners();
  }

  /// Resume the game
  void resumeGame() {
    _state = GameState.playing;
    notifyListeners();
  }

  /// Complete the game
  void completeGame() {
    _state = GameState.completed;
    notifyListeners();
  }

  /// Add score
  void addScore(int points) {
    _score += points;
    notifyListeners();
  }

  /// Increment correct reps
  void incrementCorrectReps() {
    _correctReps++;
    _totalReps++;
    notifyListeners();
  }

  /// Increment total reps (for incorrect attempts)
  void incrementTotalReps() {
    _totalReps++;
    notifyListeners();
  }

  /// Set feedback
  void setFeedback(FeedbackType feedback) {
    _currentFeedback = feedback;
    notifyListeners();
    
    // Auto-clear feedback after 2 seconds
    Future.delayed(Duration(seconds: 2), () {
      if (_currentFeedback == feedback) {
        _currentFeedback = FeedbackType.none;
        notifyListeners();
      }
    });
  }

  /// Generate random bubbles
  void _generateBubbles() {
    _bubbles.clear();
    final random = Random();
    
    for (int i = 0; i < AppConstants.maxBubbles; i++) {
      _bubbles.add(Bubble(
        x: random.nextDouble() * 0.8 + 0.1, // 10% to 90% of screen
        y: random.nextDouble() * 0.6 + 0.2, // 20% to 80% of screen
        color: _getRandomBubbleColor(),
        size: random.nextDouble() * 30 + 40, // 40 to 70 pixels
      ));
    }
  }

  /// Get random bubble color
  Color _getRandomBubbleColor() {
    final colors = [
      AppConstants.bubbleColor1,
      AppConstants.bubbleColor2,
      AppConstants.bubbleColor3,
      AppConstants.bubbleColor4,
    ];
    return colors[Random().nextInt(colors.length)];
  }

  /// Pop a bubble at position
  void popBubble(int index) {
    if (index >= 0 && index < _bubbles.length) {
      _bubbles[index].isPopped = true;
      notifyListeners();
      
      // Generate new bubble after delay
      Future.delayed(Duration(milliseconds: 500), () {
        if (_state == GameState.playing) {
          _bubbles[index] = Bubble(
            x: Random().nextDouble() * 0.8 + 0.1,
            y: Random().nextDouble() * 0.6 + 0.2,
            color: _getRandomBubbleColor(),
            size: Random().nextDouble() * 30 + 40,
          );
          notifyListeners();
        }
      });
    }
  }

  /// Reset game
  void reset() {
    _state = GameState.idle;
    _score = 0;
    _correctReps = 0;
    _totalReps = 0;
    _bubbles.clear();
    _currentFeedback = FeedbackType.none;
    _sessionStartTime = null;
    notifyListeners();
  }
}

/// Represents a single bubble in the game
class Bubble {
  final double x; // Normalized position (0.0 to 1.0)
  final double y; // Normalized position (0.0 to 1.0)
  final Color color;
  final double size;
  bool isPopped;

  Bubble({
    required this.x,
    required this.y,
    required this.color,
    required this.size,
    this.isPopped = false,
  });
}
