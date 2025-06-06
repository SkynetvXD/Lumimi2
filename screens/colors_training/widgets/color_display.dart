import 'package:flutter/material.dart';

class ColorDisplay extends StatelessWidget {
  final Color currentColor;
  
  const ColorDisplay({
    super.key,
    required this.currentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: currentColor,
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
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.sentiment_very_satisfied,
            size: 50,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}