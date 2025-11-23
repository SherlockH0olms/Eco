import 'package:flutter/material.dart';
import 'package:sma_physio_game/utils/constants.dart';

/// Overlay widget to show exercise feedback
class FeedbackOverlay extends StatelessWidget {
  final FeedbackType feedbackType;
  final String? customMessage;

  const FeedbackOverlay({
    Key? key,
    required this.feedbackType,
    this.customMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (feedbackType == FeedbackType.none) {
      return SizedBox.shrink();
    }

    return Positioned(
      top: 100,
      left: 0,
      right: 0,
      child: Center(
        child: AnimatedFeedbackCard(
          feedbackType: feedbackType,
          message: customMessage ?? _getDefaultMessage(),
        ),
      ),
    );
  }

  String _getDefaultMessage() {
    switch (feedbackType) {
      case FeedbackType.correct:
        return '🎉 Perfect!';
      case FeedbackType.tryAgain:
        return '💪 Try Again!';
      case FeedbackType.incorrect:
        return '❗ Not Quite!';
      default:
        return '';
    }
  }
}

/// Animated feedback card
class AnimatedFeedbackCard extends StatefulWidget {
  final FeedbackType feedbackType;
  final String message;

  const AnimatedFeedbackCard({
    Key? key,
    required this.feedbackType,
    required this.message,
  }) : super(key: key);

  @override
  State<AnimatedFeedbackCard> createState() => _AnimatedFeedbackCardState();
}

class _AnimatedFeedbackCardState extends State<AnimatedFeedbackCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getColor() {
    switch (widget.feedbackType) {
      case FeedbackType.correct:
        return AppConstants.correctColor;
      case FeedbackType.tryAgain:
        return AppConstants.tryAgainColor;
      case FeedbackType.incorrect:
        return AppConstants.incorrectColor;
      default:
        return Colors.grey;
    }
  }

  IconData _getIcon() {
    switch (widget.feedbackType) {
      case FeedbackType.correct:
        return Icons.check_circle;
      case FeedbackType.tryAgain:
        return Icons.refresh;
      case FeedbackType.incorrect:
        return Icons.close;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: _getColor(),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: _getColor().withOpacity(0.4),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getIcon(),
                    color: Colors.white,
                    size: 32,
                  ),
                  SizedBox(width: 12),
                  Text(
                    widget.message,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Small feedback indicator for continuous feedback
class FeedbackIndicator extends StatelessWidget {
  final FeedbackType feedbackType;

  const FeedbackIndicator({
    Key? key,
    required this.feedbackType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (feedbackType) {
      case FeedbackType.correct:
        color = AppConstants.correctColor;
        break;
      case FeedbackType.tryAgain:
        color = AppConstants.tryAgainColor;
        break;
      case FeedbackType.incorrect:
        color = AppConstants.incorrectColor;
        break;
      default:
        return SizedBox.shrink();
    }

    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}
