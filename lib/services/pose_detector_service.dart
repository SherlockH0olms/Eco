import 'package:camera/camera.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:flutter/foundation.dart';
import 'package:sma_physio_game/models/pose_data.dart';
import 'package:sma_physio_game/utils/constants.dart';

/// Service for detecting human poses using Google ML Kit
class PoseDetectorService {
  late final PoseDetector _poseDetector;
  bool _isProcessing = false;

  PoseDetectorService() {
    _poseDetector = PoseDetector(
      options: PoseDetectorOptions(
        mode: PoseDetectionMode.stream,
        model: PoseDetectionModel.accurate,
      ),
    );
  }

  /// Process a camera image and detect pose
  Future<PoseData?> detectPose(CameraImage image) async {
    if (_isProcessing) return null;
    
    _isProcessing = true;
    
    try {
      final inputImage = _convertToInputImage(image);
      final poses = await _poseDetector.processImage(inputImage);
      
      if (poses.isNotEmpty) {
        final pose = poses.first;
        final confidence = _calculatePoseConfidence(pose);
        
        if (confidence >= AppConstants.minPoseConfidence) {
          return PoseData(
            pose: pose,
            timestamp: DateTime.now(),
            angles: {},
            confidence: confidence,
          );
        }
      }
      
      return null;
    } catch (e) {
      debugPrint('Error detecting pose: $e');
      return null;
    } finally {
      _isProcessing = false;
    }
  }

  /// Convert CameraImage to InputImage for ML Kit
  InputImage _convertToInputImage(CameraImage image) {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final InputImageRotation imageRotation = InputImageRotation.rotation0deg;

    final inputImageData = InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: imageRotation,
      format: InputImageFormat.nv21,
      bytesPerRow: image.planes[0].bytesPerRow,
    );

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: inputImageData,
    );
  }

  /// Calculate overall pose confidence
  double _calculatePoseConfidence(Pose pose) {
    if (pose.landmarks.isEmpty) return 0.0;
    
    // Average confidence of key landmarks
    final keyLandmarks = [
      PoseLandmarkType.leftShoulder,
      PoseLandmarkType.rightShoulder,
      PoseLandmarkType.leftElbow,
      PoseLandmarkType.rightElbow,
      PoseLandmarkType.leftWrist,
      PoseLandmarkType.rightWrist,
    ];
    
    double totalConfidence = 0.0;
    int count = 0;
    
    for (final type in keyLandmarks) {
      final landmark = pose.landmarks[type];
      if (landmark != null) {
        totalConfidence += landmark.likelihood;
        count++;
      }
    }
    
    return count > 0 ? totalConfidence / count : 0.0;
  }

  /// Dispose resources
  void dispose() {
    _poseDetector.close();
  }
}
