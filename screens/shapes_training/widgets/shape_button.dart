import 'package:flutter/material.dart';
import 'shape_painter.dart';

class ShapeButton extends StatelessWidget {
  @override
  final GlobalKey key;
  final int shape;
  final Color color;
  final VoidCallback onTap;

  const ShapeButton({
    required this.key,
    required this.shape,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: key,
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: CustomPaint(
            size: Size(60, 60),
            painter: ShapePainter(
              shapeType: shape,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}