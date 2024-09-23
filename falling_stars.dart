import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: AnimatedCircles(),
        ),
      ),
    );
  }
}

class AnimatedCircles extends StatefulWidget {
  @override
  _AnimatedCirclesState createState() => _AnimatedCirclesState();
}

class _AnimatedCirclesState extends State<AnimatedCircles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(9, (index) {
        final double delay = index * 0.2;
        final double duration = 1 + (index % 3) * 0.5;
        final double topOffset = (index < 7) ? 0.0 : 300.0;
        final double rightOffset = (index % 3) * 80.0 + (index < 7 ? 0 : 450.0);

        return Positioned(
          top: topOffset,
          right: rightOffset,
          child: AnimatedDot(
            animationDelay: delay,
            animationDuration: duration,
            controller: _controller,
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class AnimatedDot extends StatelessWidget {
  final double animationDelay;
  final double animationDuration;
  final AnimationController controller;

  AnimatedDot({
    required this.animationDelay,
    required this.animationDuration,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final double start = (animationDelay / 3.0).clamp(0.0, 1.0);
    final double end =
        ((animationDelay + animationDuration) / 3.0).clamp(0.0, 1.0);

    final opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(start, end, curve: Curves.linear),
      ),
    );

    final translateAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(-1000, 0),
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.linear,
      ),
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..rotateZ(315 * pi / 180)
            ..translate(
                translateAnimation.value.dx, translateAnimation.value.dy),
          child: Opacity(
            opacity: opacityAnimation.value,
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    spreadRadius: 4,
                    blurRadius: 4,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    spreadRadius: 8,
                    blurRadius: 8,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    spreadRadius: 20,
                    blurRadius: 20,
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
