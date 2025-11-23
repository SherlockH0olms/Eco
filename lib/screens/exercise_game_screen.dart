import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';

import 'package:sma_physio_game/models/game_state.dart';
import 'package:sma_physio_game/models/pose_data.dart';
import 'package:sma_physio_game/models/exercise_session.dart';
import 'package:sma_physio_game/services/pose_detector_service.dart';
import 'package:sma_physio_game/services/angle_calculator_service.dart';
import 'package:sma_physio_game/services/feedback_service.dart';
import 'package:sma_physio_game/services/storage_service.dart';
import 'package:sma_physio_game/widgets/pose_painter.dart';
import 'package:sma_physio_game/widgets/bubble_game_widget.dart';
import 'package:sma_physio_game/widgets/feedback_overlay.dart';
import 'package:sma_physio_game/utils/constants.dart';
import 'package:sma_physio_game/utils/helpers.dart';

/// Main exercise game screen with camera and pose detection
class ExerciseGameScreen extends StatefulWidget {
  final ExerciseType exerciseType;

  const ExerciseGameScreen({
    Key? key,
    required this.exerciseType,
  }) : super(key: key);

  @override
  State<ExerciseGameScreen> createState() => _ExerciseGameScreenState();
}

class _ExerciseGameScreenState extends State<ExerciseGameScreen> {
  // Services
  final PoseDetectorService _poseDetector = PoseDetectorService();
  final AngleCalculatorService _angleCalculator = AngleCalculatorService();
  final FeedbackService _feedbackService = FeedbackService();
  final StorageService _storage = StorageService();
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Camera
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;

  // Pose
  Pose? _currentPose;
  bool _isProcessing = false;

  // Game State
  late GameStateModel _gameState;
  ExerciseSession? _currentSession;
  FeedbackType _currentFeedback = FeedbackType.none;
  String _feedbackMessage = '';
  bool _lastRepWasCorrect = false;

  // Confetti
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: Duration(seconds: 2));
    _initializeCamera();
    _startNewSession();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _poseDetector.dispose();
    _audioPlayer.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        _showError('No camera found');
        return;
      }

      _cameraController = CameraController(
        _cameras!.first,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      await _cameraController!.startImageStream(_processCameraImage);

      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      _showError('Camera initialization failed: $e');
    }
  }

  void _startNewSession() {
    _currentSession = ExerciseSession.create(widget.exerciseType);
    _gameState = GameStateModel();
    _gameState.startGame();
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (_isProcessing || _gameState.state != GameState.playing) return;

    _isProcessing = true;

    try {
      final poseData = await _poseDetector.detectPose(image);

      if (poseData != null && poseData.pose != null) {
        setState(() {
          _currentPose = poseData.pose;
        });

        _evaluateExercise(poseData.pose!);
      }
    } catch (e) {
      debugPrint('Error processing image: $e');
    } finally {
      _isProcessing = false;
    }
  }

  void _evaluateExercise(Pose pose) {
    final result = _feedbackService.evaluatePose(pose, widget.exerciseType);

    setState(() {
      _currentFeedback = result.feedbackType;
      _feedbackMessage = result.message;
    });

    _gameState.setFeedback(result.feedbackType);

    // Handle correct repetition
    if (result.feedbackType == FeedbackType.correct && !_lastRepWasCorrect) {
      _handleCorrectRep(result);
      _lastRepWasCorrect = true;
    } else if (result.feedbackType != FeedbackType.correct) {
      _lastRepWasCorrect = false;
    }

    // Check if target reached
    if (_gameState.correctReps >= AppConstants.targetRepsPerSession) {
      _completeSession();
    }
  }

  void _handleCorrectRep(FeedbackResult result) {
    // Add score
    _gameState.addScore(AppConstants.pointsPerCorrectRep);
    _gameState.incrementCorrectReps();

    // Pop random bubble
    if (_gameState.bubbles.isNotEmpty) {
      final randomIndex = DateTime.now().millisecond % _gameState.bubbles.length;
      _gameState.popBubble(randomIndex);
    }

    // Play sound
    _playSuccessSound();

    // Show confetti for milestones
    if (_gameState.correctReps % 5 == 0) {
      _confettiController.play();
    }

    // Save repetition to session
    final rep = ExerciseRepetition(
      repNumber: _gameState.correctReps,
      timestamp: DateTime.now(),
      formQuality: result.formQuality,
      angle: result.angle ?? 0.0,
      isCorrect: true,
    );

    _currentSession = _currentSession?.addRepetition(rep);
  }

  Future<void> _playSuccessSound() async {
    try {
      // Note: You'll need to add a sound file to assets/sounds/
      // await _audioPlayer.play(AssetSource('sounds/pop.mp3'));
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  Future<void> _completeSession() async {
    _gameState.completeGame();

    final completedSession = _currentSession?.complete();
    if (completedSession != null) {
      await _storage.saveSession(completedSession);
    }

    _showCompletionDialog();
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          '🎉 Great Job!',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.emoji_events,
              size: 80,
              color: AppConstants.secondaryColor,
            ),
            SizedBox(height: 20),
            Text(
              'You completed ${_gameState.correctReps} reps!',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'Score: ${_gameState.score}',
              style: AppConstants.scoreStyle,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Done', style: TextStyle(fontSize: 18)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _startNewSession();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryColor,
            ),
            child: Text('Play Again', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _gameState,
      child: Scaffold(
        body: _isCameraInitialized
            ? _buildGameView()
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text('Initializing camera...'),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildGameView() {
    return Stack(
      children: [
        // Camera Preview
        if (_cameraController != null)
          Positioned.fill(
            child: CameraPreview(_cameraController!),
          ),

        // Pose Overlay
        if (_currentPose != null && _cameraController != null)
          Positioned.fill(
            child: PoseOverlayWidget(
              pose: _currentPose,
              imageSize: Size(
                _cameraController!.value.previewSize!.height,
                _cameraController!.value.previewSize!.width,
              ),
            ),
          ),

        // Bubble Game
        Consumer<GameStateModel>(
          builder: (context, gameState, child) {
            return BubbleGameWidget(
              bubbles: gameState.bubbles,
              onBubbleTap: (index) => gameState.popBubble(index),
            );
          },
        ),

        // Feedback Overlay
        FeedbackOverlay(
          feedbackType: _currentFeedback,
          customMessage: _feedbackMessage,
        ),

        // Confetti
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            particleDrag: 0.05,
            emissionFrequency: 0.05,
            numberOfParticles: 50,
            gravity: 0.1,
          ),
        ),

        // Top Bar
        _buildTopBar(),

        // Score Display
        _buildScoreDisplay(),

        // Progress Bar
        _buildProgressBar(),
      ],
    );
  }

  Widget _buildTopBar() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Back button
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () => _showExitDialog(),
              ),
            ),

            // Exercise type
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Arm Raise',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Pause button
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Consumer<GameStateModel>(
                builder: (context, gameState, child) {
                  return IconButton(
                    icon: Icon(
                      gameState.state == GameState.paused
                          ? Icons.play_arrow
                          : Icons.pause,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (gameState.state == GameState.paused) {
                        gameState.resumeGame();
                      } else {
                        gameState.pauseGame();
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreDisplay() {
    return Positioned(
      top: 100,
      right: 20,
      child: Consumer<GameStateModel>(
        builder: (context, gameState, child) {
          return Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 32),
                SizedBox(height: 4),
                Text(
                  '${gameState.score}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Icon(Icons.fitness_center, color: Colors.green, size: 28),
                SizedBox(height: 4),
                Text(
                  '${gameState.correctReps}/${AppConstants.targetRepsPerSession}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgressBar() {
    return Positioned(
      bottom: 40,
      left: 20,
      right: 20,
      child: Consumer<GameStateModel>(
        builder: (context, gameState, child) {
          final progress = gameState.correctReps / AppConstants.targetRepsPerSession;
          
          return Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Text(
                  _feedbackService.getEncouragementMessage(
                    gameState.correctReps,
                    AppConstants.targetRepsPerSession,
                  ),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    backgroundColor: Colors.grey[800],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppConstants.secondaryColor,
                    ),
                    minHeight: 12,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit Exercise?'),
        content: Text('Your progress will be saved.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_currentSession != null) {
                final session = _currentSession!.complete();
                await _storage.saveSession(session);
              }
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Exit'),
          ),
        ],
      ),
    );
  }
}
