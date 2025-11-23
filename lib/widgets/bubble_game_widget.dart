import 'package:flutter/material.dart';
import 'package:sma_physio_game/models/game_state.dart';
import 'dart:math';

/// Widget to display and manage bubble pop game
class BubbleGameWidget extends StatefulWidget {
  final List<Bubble> bubbles;
  final Function(int) onBubbleTap;

  const BubbleGameWidget({
    Key? key,
    required this.bubbles,
    required this.onBubbleTap,
  }) : super(key: key);

  @override
  State<BubbleGameWidget> createState() => _BubbleGameWidgetState();
}

class _BubbleGameWidgetState extends State<BubbleGameWidget>
    with TickerProviderStateMixin {
  final List<AnimationController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    for (int i = 0; i < widget.bubbles.length; i++) {
      final controller = AnimationController(
        duration: Duration(seconds: 2 + Random().nextInt(2)),
        vsync: this,
      )..repeat(reverse: true);
      _controllers.add(controller);
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: widget.bubbles.asMap().entries.map((entry) {
        final index = entry.key;
        final bubble = entry.value;
        
        if (bubble.isPopped) {
          return SizedBox.shrink();
        }

        return AnimatedBubble(
          bubble: bubble,
          controller: _controllers[index],
          onTap: () => widget.onBubbleTap(index),
        );
      }).toList(),
    );
  }
}

/// Animated bubble widget
class AnimatedBubble extends StatelessWidget {
  final Bubble bubble;
  final AnimationController controller;
  final VoidCallback onTap;

  const AnimatedBubble({
    Key? key,
    required this.bubble,
    required this.controller,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final offset = sin(controller.value * 2 * pi) * 10;
        
        return Positioned(
          left: bubble.x * screenSize.width - bubble.size / 2,
          top: bubble.y * screenSize.height - bubble.size / 2 + offset,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              width: bubble.size,
              height: bubble.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    bubble.color.withOpacity(0.6),
                    bubble.color.withOpacity(0.3),
                    bubble.color.withOpacity(0.1),
                  ],
                  stops: [0.0, 0.7, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: bubble.color.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: bubble.size * 0.3,
                  height: bubble.size * 0.3,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.4),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Bubble pop explosion effect
class BubblePopEffect extends StatefulWidget {
  final Offset position;
  final Color color;

  const BubblePopEffect({
    Key? key,
    required this.position,
    required this.color,
  }) : super(key: key);

  @override
  State<BubblePopEffect> createState() => _BubblePopEffectState();
}

class _BubblePopEffectState extends State<BubblePopEffect>
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

    _scaleAnimation = Tween<double>(begin: 1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: widget.position.dx,
          top: widget.position.dy,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Icon(
                Icons.star,
                color: widget.color,
                size: 30,
              ),
            ),
          ),
        );
      },
    );
  }
}
