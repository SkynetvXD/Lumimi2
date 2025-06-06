import 'package:flutter/material.dart';

class MessageHelper {
  // Função para mostrar mensagem de erro acima do botão
  static void showErrorMessage(BuildContext context, GlobalKey buttonKey) {
    // Obtém a posição do botão
    final RenderBox renderBox = buttonKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    
    // Mostra um popup acima do botão
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx,
        top: position.dy - 50, // 50px acima do botão
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "Opa, vamos tentar novamente!",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
    
    // Adiciona e remove depois de 2 segundos
    Overlay.of(context).insert(overlayEntry);
    Future.delayed(Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  // Função para gerar mensagem personalizada de acordo com o desempenho
  static String getPerformanceMessage(double successPercentage) {
    if (successPercentage >= 90) {
      return "Incrível! Você é um verdadeiro expert em cores! 🌟";
    } else if (successPercentage >= 70) {
      return "Muito bom! Você tem um ótimo conhecimento de cores! 😃";
    } else if (successPercentage >= 50) {
      return "Bom trabalho! Continue praticando para melhorar! 👍";
    } else {
      return "Vamos praticar mais! A cada tentativa você vai melhorar! 💪";
    }
  }
}