import 'package:flutter/material.dart';
import 'shape_painter.dart';

class ShapeDisplay extends StatelessWidget {
  final int currentShape;
  final Color color;
  
  const ShapeDisplay({
    super.key,
    required this.currentShape,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: CustomPaint(
          size: Size(120, 120),
          painter: ShapePainter(
            shapeType: currentShape,
            color: color,
          ),
        ),
      ),
    );
  }
}