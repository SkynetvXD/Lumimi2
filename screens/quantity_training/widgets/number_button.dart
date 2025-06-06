import 'package:flutter/material.dart';

class NumberButton extends StatelessWidget {
  @override
  final GlobalKey key;
  final int number;
  final VoidCallback onTap;

  const NumberButton({
    required this.key,
    required this.number,
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
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            number.toString(),
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: _getColorForNumber(number),
            ),
          ),
        ),
      ),
    );
  }
  
  // Função para atribuir cores diferentes aos números
  Color _getColorForNumber(int number) {
    // Cada grupo de números tem uma cor diferente
    if (number <= 5) {
      return Colors.blue;
    } else if (number <= 10) {
      return Colors.green;
    } else if (number <= 15) {
      return Colors.orange;
    } else {
      return Colors.purple;
    }
  }
}