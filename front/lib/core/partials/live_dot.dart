import 'package:flutter/material.dart';

class LiveDot extends StatefulWidget {
  final Color color;
  final double size;
  final double maxSize;
  final Duration duration;

  const LiveDot({
    super.key,
    this.color = Colors.red,
    this.size = 15.0,
    this.maxSize = 50.0,
    this.duration = const Duration(seconds: 1),
  });

  @override
  State<LiveDot> createState() => _LiveDotState();
}

class _LiveDotState extends State<LiveDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: widget.color,
              shape: BoxShape.circle,
            ),
          ),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                width: widget.maxSize * _animation.value,
                height: widget.maxSize * _animation.value,
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(1 - _animation.value),
                  shape: BoxShape.circle,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
