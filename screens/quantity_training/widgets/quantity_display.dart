import 'package:flutter/material.dart';
import 'dart:math';

class QuantityDisplay extends StatelessWidget {
  final int quantity;
  
  const QuantityDisplay({
    super.key,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 150,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: _buildItemsDisplay(quantity),
    );
  }
  
  // Função para construir a exibição dos itens
  Widget _buildItemsDisplay(int quantity) {
    // Gerar cores e formas aleatórias para tornar o visual mais interessante
    final random = Random();
    
    // Uma lista de possíveis ícones para usar
    final List<IconData> icons = [
      Icons.star,
      Icons.favorite,
      Icons.pets,
      Icons.emoji_emotions,
      Icons.cake,
      Icons.wb_sunny,
      Icons.local_florist,
    ];
    
    // Escolher um ícone aleatório para esta exibição
    final selectedIcon = icons[random.nextInt(icons.length)];
    
    // Escolher uma cor aleatória para esta exibição
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
    ];
    final selectedColor = colors[random.nextInt(colors.length)];
    
    // Organizar os ícones em linhas e colunas (máximo 5 por linha)
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 15,
      runSpacing: 15,
      children: List.generate(
        quantity,
        (index) => Icon(
          selectedIcon,
          color: selectedColor,
          size: 35,
        ),
      ),
    );
  }
}