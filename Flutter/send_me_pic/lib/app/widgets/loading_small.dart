import 'package:flutter/material.dart';

class LoadingSmall extends StatelessWidget {

  LoadingSmall({this.color, this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: size ?? 22,
        width: size ?? 22,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(color ?? Colors.white),
        ),
      ),
    );
  }
}


class ProgressSmall extends StatelessWidget {

  ProgressSmall({this.color, this.size, this.progress});

  final Color color;
  final double size;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: size ?? 22,
        width: size ?? 22,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(color ?? Colors.white),
          value: progress ?? 0.0,
        ),
      ),
    );
  }
}