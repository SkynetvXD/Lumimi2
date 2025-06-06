import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../models/training_stats.dart';
import '../../services/progress_service.dart';
import '../../utils/message_helper.dart';
import '../common_widgets/gradient_background.dart';

class DashboardPage extends StatefulWidget {
  final int successes;
  final int errors;
  final int totalAttempts;
  final VoidCallback onTryAgain;
  final VoidCallback onFinishAttempt;
  
  const DashboardPage({
    super.key, 
    required this.successes, 
    required this.errors, 
    required this.totalAttempts,
    required this.onTryAgain,
    required this.onFinishAttempt,
  });
  
   @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _isLoading = true;
  double? _previousAverageSuccess;
  int _completedTrainings = 0;
  int _totalStars = 0;
  bool _mounted = true;
  
   @override
  void initState() {
    super.initState();
    _saveStatsAndLoadProgress();
  }
  
  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }
  
  Future<void> _saveStatsAndLoadProgress() async {
    // Criar objeto de estatísticas
    final stats = TrainingStats(
      successes: widget.successes,
      errors: widget.errors,
      totalAttempts: widget.totalAttempts,
      date: DateTime.now(),
    );
    
    // Salvar estatísticas baseado no tipo de treinamento
    if (Navigator.of(context).widget.toString().contains('ColorsTraining')) {
      await ProgressService.saveColorTrainingStats(stats);
    } else if (Navigator.of(context).widget.toString().contains('ShapesTraining')) {
      await ProgressService.saveShapeTrainingStats(stats);
    } else if (Navigator.of(context).widget.toString().contains('QuantityTraining')) {
      await ProgressService.saveQuantityTrainingStats(stats);
    } else {
      await ProgressService.saveColorTrainingStats(stats);
    }
    
    // Marcar treinamento como concluído se a taxa de sucesso for maior que 50%
    if (stats.successPercentage >= 50) {
      if (Navigator.of(context).widget.toString().contains('ColorsTraining')) {
        await ProgressService.markColorTrainingCompleted();
      } else if (Navigator.of(context).widget.toString().contains('ShapesTraining')) {
        await ProgressService.markShapeTrainingCompleted();
      } else if (Navigator.of(context).widget.toString().contains('QuantityTraining')) {
        await ProgressService.markQuantityTrainingCompleted();
      } else {
        await ProgressService.markColorTrainingCompleted();
      }
    }
    
    // Obter estatísticas médias anteriores (antes desta sessão)
    final avgStats = await ProgressService.getAverageColorTrainingStats();
    if (avgStats != null) {
      _previousAverageSuccess = avgStats.successPercentage;
    }
    
     // Obter progresso geral
    final overallProgress = await ProgressService.getOverallProgress();
    _completedTrainings = overallProgress['completedTrainings'] as int;
    _totalStars = overallProgress['totalStars'] as int;
    
    // Verificar se o widget ainda está montado antes de chamar setState
    if (_mounted) {
      setState(() {
        _isLoading = false;
      });
    }
    
    // Verificar se o widget ainda está montado antes de chamar setState
    if (_mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // Criar objeto de estatísticas
    final stats = TrainingStats(
      successes: widget.successes,
      errors: widget.errors,
      totalAttempts: widget.totalAttempts,
    );
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Resultado Final"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: GradientBackground(
        colors: AppColors.dashboardGradient,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Título com ícone
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 40,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Fim do Treino!",
                          style: TextStyle(
                            fontSize: 28, 
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Progresso total (novo)
                    if (_completedTrainings > 0)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(50), // Substituído withOpacity por withAlpha
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "Seu Progresso Total",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.emoji_events, color: Colors.amber),
                                const SizedBox(width: 5),
                                Text(
                                  "Treinamentos completos: $_completedTrainings",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.star, color: Colors.amber),
                                const SizedBox(width: 5),
                                Text(
                                  "Estrelas conquistadas: $_totalStars",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    
                    const SizedBox(height: 20),
                    
                    // Card com estatísticas
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "Seu Desempenho",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Acertos
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.check_circle, color: Colors.green),
                                  SizedBox(width: 10),
                                  Text(
                                    "Acertos:",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "${widget.successes} (${stats.successPercentage.toStringAsFixed(1)}%)",
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          
                          // Barra de progresso dos acertos
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: widget.successes / widget.totalAttempts,
                              backgroundColor: Colors.grey[200],
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                              minHeight: 15,
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Erros
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.cancel, color: Colors.red),
                                  SizedBox(width: 10),
                                  Text(
                                    "Erros:",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "${widget.errors} (${stats.errorPercentage.toStringAsFixed(1)}%)",
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          
                          // Barra de progresso dos erros
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: widget.errors / widget.totalAttempts,
                              backgroundColor: Colors.grey[200],
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                              minHeight: 15,
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Total de tentativas
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.format_list_numbered, color: Colors.blue),
                                  SizedBox(width: 10),
                                  Text(
                                    "Total de tentativas:",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "${widget.totalAttempts}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          
                          // Mostrar comparação com média anterior se disponível
                          if (_previousAverageSuccess != null) ...[
                            const SizedBox(height: 20),
                            const Divider(),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Seu desempenho anterior:",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${_previousAverageSuccess!.toStringAsFixed(1)}%",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Evolução:",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                _buildEvolutionText(stats.successPercentage - _previousAverageSuccess!),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Mensagem de desempenho
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(50), // Substituído withOpacity por withAlpha
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        MessageHelper.getPerformanceMessage(stats.successPercentage),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    // Botões com ícones
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: widget.onTryAgain,
                          icon: const Icon(Icons.replay),
                          label: const Text("Tentar Novamente"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: widget.onFinishAttempt,
                          icon: const Icon(Icons.home),
                          label: const Text("Menu Principal"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
  
  Widget _buildEvolutionText(double difference) {
    final String formattedDifference = difference.abs().toStringAsFixed(1);
    
    if (difference > 0) {
      return Row(
        children: [
          const Icon(Icons.arrow_upward, color: Colors.green, size: 16),
          const SizedBox(width: 5),
          Text(
            "+$formattedDifference%",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    } else if (difference < 0) {
      return Row(
        children: [
          const Icon(Icons.arrow_downward, color: Colors.red, size: 16),
          const SizedBox(width: 5),
          Text(
            "-$formattedDifference%",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    } else {
      return const Text(
        "Sem alteração",
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }
}