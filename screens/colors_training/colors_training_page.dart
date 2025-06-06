import 'package:flutter/material.dart';
import 'dart:math';
import '../../constants/colors.dart';  // Importação corrigida
import '../../services/progress_service.dart';
import '../../utils/message_helper.dart';
import '../common_widgets/gradient_background.dart';
import '../menu/menu_trainings_page.dart';
import 'congratulations_page.dart';
import 'dashboard_page.dart';
import 'widgets/color_button.dart';
import 'widgets/color_display.dart';

class ColorsTrainingPage extends StatefulWidget {
  const ColorsTrainingPage({super.key});  // Adicionado parâmetro Key

  @override
  State<ColorsTrainingPage> createState() => _ColorsTrainingPageState();  // Corrigido para State<ColorsTrainingPage>
}

class _ColorsTrainingPageState extends State<ColorsTrainingPage> {
  // Lista expandida de cores disponíveis
  final List<Color> allColors = [
    AppColors.red,      // Vermelho
    AppColors.green,    // Verde
    AppColors.yellow,   // Amarelo
    AppColors.blue,     // Azul
    AppColors.purple,   // Roxo
    AppColors.orange,   // Laranja
    AppColors.pink,     // Rosa
    AppColors.brown,    // Marrom
  ];
  
  // Cores atuais para mostrar (3 de cada vez)
  late List<Color> currentOptionsColors;
  
  // Controle do jogo
  late Color currentTargetColor;
  int successes = 0;
  int errors = 0;
  int totalAttempts = 10;
  int usedAttempts = 0;
  
  // Estado para mostrar mensagem de carregamento
  final bool _isLoading = false;  // Mudado para final
  
  // Para mostrar mensagem de erro
  final GlobalKey buttonKey1 = GlobalKey();
  final GlobalKey buttonKey2 = GlobalKey();
  final GlobalKey buttonKey3 = GlobalKey();
  
  @override
  void initState() {
    super.initState();
    // Inicializa o jogo com uma seleção aleatória de cores
    _selectRandomColorSet();
  }
  
  // Função para selecionar 3 cores aleatórias da lista completa
  void _selectRandomColorSet() {
    final random = Random();
    
    // Embaralhar a lista de todas as cores
    final shuffledColors = List<Color>.from(allColors)..shuffle(random);
    
    // Selecionar as primeiras 3 cores
    currentOptionsColors = shuffledColors.take(3).toList();
    
    // Escolher uma das 3 cores selecionadas como alvo
    currentTargetColor = currentOptionsColors[random.nextInt(3)];
    
    setState(() {});
  }
  
  // Função para verificar se o usuário acertou a cor
  void _checkChoice(Color chosenColor, GlobalKey buttonKey) {
    if (chosenColor == currentTargetColor) {
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
              // Quando o usuário continuar, muda a cor e volta para o jogo
              _selectRandomColorSet();
              
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
        // Ainda tem tentativas, apenas muda as cores
        _selectRandomColorSet();
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
              MaterialPageRoute(builder: (context) => const ColorsTrainingPage()),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Treino de Cores"),
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
              colors: AppColors.colorTrainingGradient,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Círculo colorido na parte superior
                  Positioned(
                    top: 50,
                    child: ColorDisplay(currentColor: currentTargetColor),
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
                      child: const Column(
                        children: [
                          Text(
                            "Qual é esta cor?",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Toque no botão da cor certa!",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Botões de cores na parte inferior
                  Positioned(
                    bottom: 80,
                    left: 30,
                    right: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ColorButton(
                          key: buttonKey1,
                          color: currentOptionsColors[0],
                          onTap: () => _checkChoice(currentOptionsColors[0], buttonKey1),
                        ),
                        ColorButton(
                          key: buttonKey2,
                          color: currentOptionsColors[1],
                          onTap: () => _checkChoice(currentOptionsColors[1], buttonKey2),
                        ),
                        ColorButton(
                          key: buttonKey3,
                          color: currentOptionsColors[2],
                          onTap: () => _checkChoice(currentOptionsColors[2], buttonKey3),
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