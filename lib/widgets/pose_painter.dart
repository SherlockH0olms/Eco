import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

/// Custom painter to draw skeleton overlay on camera feed
class PosePainter extends CustomPainter {
  final Pose? pose;
  final Size imageSize;
  final InputImageRotation rotation;

  PosePainter({
    required this.pose,
    required this.imageSize,
    required this.rotation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (pose == null) return;

    final paint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    final pointPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 8.0
      ..style = PaintingStyle.fill;

    // Draw landmarks (joints)
    pose!.landmarks.forEach((type, landmark) {
      final point = _translatePoint(
        Offset(landmark.x, landmark.y),
        size,
      );
      canvas.drawCircle(point, 5, pointPaint);
    });

    // Draw connections (bones)
    _drawConnection(canvas, size, paint, 
      PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder);
    _drawConnection(canvas, size, paint,
      PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow);
    _drawConnection(canvas, size, paint,
      PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist);
    _drawConnection(canvas, size, paint,
      PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow);
    _drawConnection(canvas, size, paint,
      PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist);
    _drawConnection(canvas, size, paint,
      PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip);
    _drawConnection(canvas, size, paint,
      PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip);
    _drawConnection(canvas, size, paint,
      PoseLandmarkType.leftHip, PoseLandmarkType.rightHip);
  }

  void _drawConnection(
    Canvas canvas,
    Size size,
    Paint paint,
    PoseLandmarkType from,
    PoseLandmarkType to,
  ) {
    final fromLandmark = pose?.landmarks[from];
    final toLandmark = pose?.landmarks[to];

    if (fromLandmark != null && toLandmark != null) {
      final fromPoint = _translatePoint(
        Offset(fromLandmark.x, fromLandmark.y),
        size,
      );
      final toPoint = _translatePoint(
        Offset(toLandmark.x, toLandmark.y),
        size,
      );
      canvas.drawLine(fromPoint, toPoint, paint);
    }
  }

  Offset _translatePoint(Offset point, Size size) {
    // Scale coordinates from image size to widget size
    final double scaleX = size.width / imageSize.width;
    final double scaleY = size.height / imageSize.height;
    
    return Offset(
      point.dx * scaleX,
      point.dy * scaleY,
    );
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) {
    return oldDelegate.pose != pose;
  }
}

/// Widget wrapper for PosePainter
class PoseOverlayWidget extends StatelessWidget {
  final Pose? pose;
  final Size imageSize;

  const PoseOverlayWidget({
    Key? key,
    required this.pose,
    required this.imageSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PosePainter(
        pose: pose,
        imageSize: imageSize,
        rotation: InputImageRotation.rotation0deg,
      ),
      child: Container(),
    );
  }
}
