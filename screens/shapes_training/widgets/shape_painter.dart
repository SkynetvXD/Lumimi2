import 'package:flutter/material.dart';
import 'dart:math' as math;

class ShapePainter extends CustomPainter {
  final int shapeType;
  final Color color;

  ShapePainter({
    required this.shapeType,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeWidth = 4.0;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 10;

    switch (shapeType) {
      case 0: // Circle
        _drawCircle(canvas, center, radius, paint);
        break;
      case 1: // Square
        _drawSquare(canvas, center, radius, paint);
        break;
      case 2: // Triangle
        _drawTriangle(canvas, center, radius, paint);
        break;
      case 3: // Rectangle
        _drawRectangle(canvas, center, radius, paint);
        break;
      case 4: // Pentagon
        _drawPolygon(canvas, center, radius, 5, paint);
        break;
      case 5: // Hexagon
        _drawPolygon(canvas, center, radius, 6, paint);
        break;
      case 6: // Star
        _drawStar(canvas, center, radius, paint);
        break;
      case 7: // Heart
        _drawHeart(canvas, center, radius, paint);
        break;
      default:
        _drawCircle(canvas, center, radius, paint);
    }
  }

  void _drawCircle(Canvas canvas, Offset center, double radius, Paint paint) {
    canvas.drawCircle(center, radius, paint);
  }

  void _drawSquare(Canvas canvas, Offset center, double radius, Paint paint) {
    final rect = Rect.fromCenter(
      center: center,
      width: radius * 2,
      height: radius * 2,
    );
    canvas.drawRect(rect, paint);
  }

  void _drawTriangle(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    
    // Começar no topo
    path.moveTo(center.dx, center.dy - radius);
    
    // Traçar para a esquerda abaixo
    path.lineTo(center.dx - radius, center.dy + radius / 1.5);
    
    // Traçar para a direita abaixo
    path.lineTo(center.dx + radius, center.dy + radius / 1.5);
    
    // Fechar o triângulo
    path.close();
    
    canvas.drawPath(path, paint);
  }

  void _drawRectangle(Canvas canvas, Offset center, double radius, Paint paint) {
    final rect = Rect.fromCenter(
      center: center,
      width: radius * 2,
      height: radius * 1.4,
    );
    canvas.drawRect(rect, paint);
  }

  void _drawPolygon(Canvas canvas, Offset center, double radius, int sides, Paint paint) {
    final path = Path();
    final angle = (math.pi * 2) / sides;

    // Mover para o primeiro ponto
    path.moveTo(
      center.dx + radius * math.cos(0),
      center.dy + radius * math.sin(0),
    );

    // Desenhar os lados
    for (int i = 1; i <= sides; i++) {
      path.lineTo(
        center.dx + radius * math.cos(angle * i),
        center.dy + radius * math.sin(angle * i),
      );
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    final outerRadius = radius;
    final innerRadius = radius * 0.4;
    const int numPoints = 5;
    final angle = (math.pi * 2) / (numPoints * 2);

    // Começar no topo do ponto exterior
    path.moveTo(
      center.dx,
      center.dy - outerRadius,
    );

    // Desenhar a estrela
    for (int i = 1; i < numPoints * 2; i++) {
      final currentRadius = i % 2 == 0 ? outerRadius : innerRadius;
      final x = center.dx + currentRadius * math.sin(angle * i);
      final y = center.dy - currentRadius * math.cos(angle * i);
      path.lineTo(x, y);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawHeart(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    
    // Escalar para caber dentro do raio
    final scale = radius / 25.0; 
    
    // Mover o ponto inicial para onde queremos começar
    path.moveTo(center.dx, center.dy + 15 * scale);
    
    // Desenhar a curva esquerda do coração
    path.cubicTo(
      center.dx - 25 * scale, center.dy, 
      center.dx - 25 * scale, center.dy - 20 * scale, 
      center.dx, center.dy - 15 * scale
    );
    
    // Desenhar a curva direita do coração
    path.cubicTo(
      center.dx + 25 * scale, center.dy - 20 * scale, 
      center.dx + 25 * scale, center.dy, 
      center.dx, center.dy + 15 * scale
    );
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}