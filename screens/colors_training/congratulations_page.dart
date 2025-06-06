import 'package:flutter/material.dart';
import 'dart:math';
import '../../constants/colors.dart';
import '../common_widgets/gradient_background.dart';

class CongratulationsPage extends StatelessWidget {
  final VoidCallback onContinue;
  
  const CongratulationsPage({super.key, required this.onContinue});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        colors: AppColors.congratulationsGradient,
        child: Stack(
          children: [
            // Confettis animados (simulados com círculos estáticos)
            for (int i = 0; i < 30; i++)
              Positioned(
                left: Random().nextDouble() * MediaQuery.of(context).size.width,
                top: Random().nextDouble() * MediaQuery.of(context).size.height,
                child: Container(
                  width: Random().nextDouble() * 10 + 5,
                  height: Random().nextDouble() * 10 + 5,
                  decoration: BoxDecoration(
                    color: Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0)
                        .withOpacity(1.0),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            
            // Conteúdo principal
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.sentiment_very_satisfied,
                    color: Colors.green,
                    size: 80,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Parabéns!",
                  style: TextStyle(
                    fontSize: 32, 
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    "Você acertou a cor! Vamos continuar jogando?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onContinue();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Próxima Cor",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}