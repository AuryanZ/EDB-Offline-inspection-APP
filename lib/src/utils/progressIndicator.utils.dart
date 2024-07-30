import 'package:flutter/material.dart';

enum ProgressIndicatorType {
  circular,
  linear,
}

class CustomProgressIndicator extends StatefulWidget {
  final double size;
  final Color color;
  final Duration duration;
  final double strokeWidth;
  final ProgressIndicatorType type;

  const CustomProgressIndicator({
    super.key,
    this.size = 50.0,
    this.color = Colors.blue,
    this.duration = const Duration(seconds: 2),
    this.strokeWidth = 4.0,
    this.type = ProgressIndicatorType.circular,
  });

  @override
  State<CustomProgressIndicator> createState() =>
      _CustomProgressIndicatorState();
}

class _CustomProgressIndicatorState extends State<CustomProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorTween;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();

    _colorTween = _controller.drive(
      ColorTween(
        begin: widget.color.withOpacity(0.5),
        end: widget.color,
      ).chain(CurveTween(curve: Curves.easeInOut)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: widget.type == ProgressIndicatorType.circular
          ? SizedBox(
              height: widget.size,
              width: widget.size,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CircularProgressIndicator(
                    valueColor: _colorTween,
                    strokeWidth: widget.strokeWidth,
                  );
                },
              ),
            )
          : SizedBox(
              height: widget.size / 10,
              width: widget.size,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    valueColor: _colorTween,
                    minHeight: widget.strokeWidth,
                  );
                },
              ),
            ),
    );
  }
}
