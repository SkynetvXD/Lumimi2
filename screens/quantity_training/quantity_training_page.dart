import 'package:flutter/material.dart';
import 'dart:math';
import '../../constants/colors.dart';
import '../../services/progress_service.dart';
import '../../utils/message_helper.dart';
import '../common_widgets/gradient_background.dart';
import '../menu/menu_trainings_page.dart';
import '../colors_training/congratulations_page.dart';
import '../colors_training/dashboard_page.dart';
import 'widgets/number_button.dart';
import 'widgets/quantity_display.dart';

class QuantityTrainingPage extends StatefulWidget {
  const QuantityTrainingPage({super.key});

  @override
  State<QuantityTrainingPage> createState() => _QuantityTrainingPageState();
}

class _QuantityTrainingPageState extends State<QuantityTrainingPage> {
  // Lista de quantidades disponíveis (1 a 10)
  final List<int> allQuantities = List.generate(10, (index) => index + 1);
  
  // Quantidades atuais para mostrar (3 de cada vez)
  late List<int> currentOptionsQuantities;
  
  // Controle do jogo
  late int currentTargetQuantity;
  int successes = 0;
  int errors = 0;
  int totalAttempts = 10;
  int usedAttempts = 0;
  
  // Estado para mostrar mensagem de carregamento
  final bool _isLoading = false;
  
  // Para mostrar mensagem de erro
  final GlobalKey buttonKey1 = GlobalKey();
  final GlobalKey buttonKey2 = GlobalKey();
  final GlobalKey buttonKey3 = GlobalKey();
  
  // Modo de dificuldade: 0 = fácil (1-5), 1 = médio (1-10), 2 = difícil (1-20)
  int difficultyMode = 0;
  
  @override
  void initState() {
    super.initState();
    // Inicializa o jogo com uma seleção aleatória de quantidades
    _selectRandomQuantitySet();
  }
  
  // Função para selecionar 3 quantidades aleatórias da lista completa
  void _selectRandomQuantitySet() {
    final random = Random();
    
    // Lista de quantidades para escolher com base na dificuldade
    List<int> quantitiesToChooseFrom;
    
    if (difficultyMode == 0) {
      // Modo fácil: apenas números de 1 a 5
      quantitiesToChooseFrom = List.generate(5, (index) => index + 1);
    } else if (difficultyMode == 1) {
      // Modo médio: números de 1 a 10
      quantitiesToChooseFrom = List.generate(10, (index) => index + 1);
    } else {
      // Modo difícil: números de 1 a 20
      quantitiesToChooseFrom = List.generate(20, (index) => index + 1);
    }
    
    // Embaralhar a lista de quantidades
    quantitiesToChooseFrom.shuffle(random);
    
    // Selecionar as primeiras 3 quantidades
    currentOptionsQuantities = quantitiesToChooseFrom.take(3).toList();
    
    // Escolher uma das 3 quantidades selecionadas como alvo
    currentTargetQuantity = currentOptionsQuantities[random.nextInt(3)];
    
    setState(() {});
  }
  
  // Função para verificar se o usuário acertou a quantidade
  void _checkChoice(int chosenQuantity, GlobalKey buttonKey) {
    if (chosenQuantity == currentTargetQuantity) {
      // Acertou
      setState(() {
        successes++;
        usedAttempts++;
      });
      
      // Navega para a página de parabéns
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CongratulationsPage(
            onContinue: () {
              // Quando o usuário continuar, muda a quantidade e volta para o jogo
              _selectRandomQuantitySet();
              
              // Verifica se acabaram as tentativas
              if (usedAttempts >= totalAttempts) {
                _showDashboard();
              }
            },
          ),
        ),
      );
    } else {
      // Errou
      setState(() {
        errors++;
        usedAttempts++;
      });
      
      // Mostrar mensagem de erro acima do botão
      MessageHelper.showErrorMessage(context, buttonKey);
      
      // Verifica se acabaram as tentativas
      if (usedAttempts >= totalAttempts) {
        _showDashboard();
      } else {
        // Ainda tem tentativas, apenas muda as quantidades
        _selectRandomQuantitySet();
      }
    }
  }
  
  // Função para mostrar o dashboard no final
  void _showDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DashboardPage(
          successes: successes,
          errors: errors,
          totalAttempts: totalAttempts,
          onTryAgain: () {
            // Reinicia o jogo
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const QuantityTrainingPage()),
            );
          },
          onFinishAttempt: () {
            // Volta para o menu principal
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MenuTrainingsPage()),
            );
          },
        ),
      ),
    );
  }
  
  // Função para alternar entre os modos de dificuldade
  void _toggleDifficulty() {
    setState(() {
      difficultyMode = (difficultyMode + 1) % 3;
      _selectRandomQuantitySet();
    });
    
    // Mostrar mensagem de dificuldade atual
    String difficultyName = "";
    String difficultyRange = "";
    switch (difficultyMode) {
      case 0:
        difficultyName = "Fácil";
        difficultyRange = "1-5";
        break;
      case 1:
        difficultyName = "Médio";
        difficultyRange = "1-10";
        break;
      case 2:
        difficultyName = "Difícil";
        difficultyRange = "1-20";
        break;
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Dificuldade alterada para: $difficultyName ($difficultyRange)"),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Treino de Quantidades"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Confirmar antes de sair para não perder o progresso
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Sair do treino?"),
                content: const Text("Se sair agora, você perderá seu progresso."),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Continuar Treinando"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const MenuTrainingsPage()),
                      );
                    },
                    child: const Text("Sair"),
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          // Botão para alternar dificuldade
          IconButton(
            icon: const Icon(Icons.switch_access_shortcut),
            onPressed: _toggleDifficulty,
            tooltip: "Mudar Dificuldade",
          ),
          // Contador de progresso
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                "$usedAttempts/$totalAttempts",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GradientBackground(
              colors: [Colors.blue.shade100, Colors.blue.shade300],
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Exibição da quantidade na parte superior
                  Positioned(
                    top: 50,
                    child: QuantityDisplay(
                      quantity: currentTargetQuantity,
                    ),
                  ),
                  
                  // Instrução para o jogador com nuvem de fala
                  Positioned(
                    top: 220,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "Quantos itens existem?",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "Toque no número correto!",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Botões de números na parte inferior
                  Positioned(
                    bottom: 80,
                    left: 30,
                    right: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        NumberButton(
                          key: buttonKey1,
                          number: currentOptionsQuantities[0],
                          onTap: () => _checkChoice(currentOptionsQuantities[0], buttonKey1),
                        ),
                        NumberButton(
                          key: buttonKey2,
                          number: currentOptionsQuantities[1],
                          onTap: () => _checkChoice(currentOptionsQuantities[1], buttonKey2),
                        ),
                        NumberButton(
                          key: buttonKey3,
                          number: currentOptionsQuantities[2],
                          onTap: () => _checkChoice(currentOptionsQuantities[2], buttonKey3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}