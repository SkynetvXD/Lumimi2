import 'package:flutter/material.dart';
import 'dart:math';
import '../../constants/colors.dart';
import '../../constants/shapes.dart';
import '../../services/progress_service.dart';
import '../../utils/message_helper.dart';
import '../common_widgets/gradient_background.dart';
import '../menu/menu_trainings_page.dart';
import '../colors_training/congratulations_page.dart';
import '../colors_training/dashboard_page.dart';
import 'widgets/shape_button.dart';
import 'widgets/shape_display.dart';

class ShapesTrainingPage extends StatefulWidget {
  const ShapesTrainingPage({super.key});

  @override
  State<ShapesTrainingPage> createState() => _ShapesTrainingPageState();
}

class _ShapesTrainingPageState extends State<ShapesTrainingPage> {
  // Lista de formas disponíveis
  final List<int> allShapes = [
    AppShapes.circle,
    AppShapes.square,
    AppShapes.triangle,
    AppShapes.rectangle,
    AppShapes.pentagon,
    AppShapes.hexagon,
    AppShapes.star,
    AppShapes.heart,
  ];
  
  // Formas atuais para mostrar (3 de cada vez)
  late List<int> currentOptionsShapes;
  
  // Controle do jogo
  late int currentTargetShape;
  late Color currentShapeColor;
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
  
  // Modo de dificuldade: 0 = fácil, 1 = médio, 2 = difícil
  int difficultyMode = 0;
  
  @override
  void initState() {
    super.initState();
    // Inicializa o jogo com uma seleção aleatória de formas
    _selectRandomShapeSet();
  }
  
  // Função para selecionar 3 formas aleatórias da lista completa
  void _selectRandomShapeSet() {
    final random = Random();
    
    // Lista de formas para escolher com base na dificuldade
    List<int> shapesToChooseFrom;
    
    if (difficultyMode == 0) {
      // Modo fácil: apenas formas básicas
      shapesToChooseFrom = [
        AppShapes.circle,
        AppShapes.square,
        AppShapes.triangle,
      ];
    } else if (difficultyMode == 1) {
      // Modo médio: formas básicas + médias
      shapesToChooseFrom = [
        AppShapes.circle,
        AppShapes.square,
        AppShapes.triangle,
        AppShapes.rectangle,
        AppShapes.star,
      ];
    } else {
      // Modo difícil: todas as formas
      shapesToChooseFrom = List.from(allShapes);
    }
    
    // Embaralhar a lista de formas
    shapesToChooseFrom.shuffle(random);
    
    // Selecionar as primeiras 3 formas
    currentOptionsShapes = shapesToChooseFrom.take(3).toList();
    
    // Escolher uma das 3 formas selecionadas como alvo
    currentTargetShape = currentOptionsShapes[random.nextInt(3)];
    
    // Escolher uma cor aleatória para a forma
    List<Color> colors = [
      AppColors.red,
      AppColors.green,
      AppColors.blue,
      AppColors.purple,
      AppColors.orange,
    ];
    currentShapeColor = colors[random.nextInt(colors.length)];
    
    setState(() {});
  }
  
  // Função para verificar se o usuário acertou a forma
  void _checkChoice(int chosenShape, GlobalKey buttonKey) {
    if (chosenShape == currentTargetShape) {
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
              // Quando o usuário continuar, muda a forma e volta para o jogo
              _selectRandomShapeSet();
              
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
        // Ainda tem tentativas, apenas muda as formas
        _selectRandomShapeSet();
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
              MaterialPageRoute(builder: (context) => const ShapesTrainingPage()),
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
      _selectRandomShapeSet();
    });
    
    // Mostrar mensagem de dificuldade atual
    String difficultyName = "";
    switch (difficultyMode) {
      case 0:
        difficultyName = "Fácil";
        break;
      case 1:
        difficultyName = "Médio";
        break;
      case 2:
        difficultyName = "Difícil";
        break;
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Dificuldade alterada para: $difficultyName"),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Treino de Formas"),
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
              colors: [Colors.green.shade100, Colors.green.shade300],
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Forma na parte superior
                  Positioned(
                    top: 50,
                    child: ShapeDisplay(
                      currentShape: currentTargetShape,
                      color: currentShapeColor,
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
                            "Qual é esta forma?",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "Toque no botão da forma certa!",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Nome da forma alvo (pode ser habilitado para treinamento)
                          Text(
                            AppShapes.getName(currentTargetShape),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: currentShapeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Botões de formas na parte inferior
                  Positioned(
                    bottom: 80,
                    left: 30,
                    right: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ShapeButton(
                          key: buttonKey1,
                          shape: currentOptionsShapes[0],
                          color: currentShapeColor,
                          onTap: () => _checkChoice(currentOptionsShapes[0], buttonKey1),
                        ),
                        ShapeButton(
                          key: buttonKey2,
                          shape: currentOptionsShapes[1],
                          color: currentShapeColor,
                          onTap: () => _checkChoice(currentOptionsShapes[1], buttonKey2),
                        ),
                        ShapeButton(
                          key: buttonKey3,
                          shape: currentOptionsShapes[2],
                          color: currentShapeColor,
                          onTap: () => _checkChoice(currentOptionsShapes[2], buttonKey3),
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