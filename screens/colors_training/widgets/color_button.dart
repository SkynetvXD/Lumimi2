import 'package:flutter/material.dart';

class ColorButton extends StatelessWidget {
  @override
  final GlobalKey key;
  final Color color;
  final VoidCallback onTap;

  const ColorButton({
    required this.key,
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
        decoration: ShapeDecoration(
          color: color,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: const Color(0xFF303030)),
            borderRadius: BorderRadius.circular(40),
          ),
          shadows: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            Icons.touch_app,
            color: Colors.white.withOpacity(0.5),
            size: 30,
          ),
        ),
      ),
    );
  }
}