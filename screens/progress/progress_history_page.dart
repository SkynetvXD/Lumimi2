import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants/colors.dart';
import '../../models/training_stats.dart';
import '../../services/progress_service.dart';
import '../common_widgets/gradient_background.dart';

class ProgressHistoryPage extends StatefulWidget {
  const ProgressHistoryPage({super.key});

  @override
  State<ProgressHistoryPage> createState() => _ProgressHistoryPageState();
}

class _ProgressHistoryPageState extends State<ProgressHistoryPage> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _colorTrainingHistory = [];
  List<Map<String, dynamic>> _shapeTrainingHistory = [];
  List<Map<String, dynamic>> _quantityTrainingHistory = [];
  Map<String, dynamic> _overallProgress = {};
  bool _mounted = true;
  
  @override
  void initState() {
    super.initState();
    _loadProgressData();
  }
  
  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }
  
  Future<void> _loadProgressData() async {
    // Carregar histórico de treinamentos
    _colorTrainingHistory = await ProgressService.getColorTrainingStats();
    _shapeTrainingHistory = await ProgressService.getShapeTrainingStats();
    _quantityTrainingHistory = await ProgressService.getQuantityTrainingStats();
    
    // Ordenar históricos do mais recente para o mais antigo
    _colorTrainingHistory.sort((a, b) {
      DateTime dateA = DateTime.parse(a['date']);
      DateTime dateB = DateTime.parse(b['date']);
      return dateB.compareTo(dateA);
    });
    
    _shapeTrainingHistory.sort((a, b) {
      DateTime dateA = DateTime.parse(a['date']);
      DateTime dateB = DateTime.parse(b['date']);
      return dateB.compareTo(dateA);
    });
    
    _quantityTrainingHistory.sort((a, b) {
      DateTime dateA = DateTime.parse(a['date']);
      DateTime dateB = DateTime.parse(b['date']);
      return dateB.compareTo(dateA);
    });
    
    // Carregar progresso geral
    _overallProgress = await ProgressService.getOverallProgress();
    
    if (_mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Histórico de Progresso"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              setState(() {
                _isLoading = true;
              });
              await _loadProgressData();
            },
          ),
        ],
      ),
      body: GradientBackground(
        colors: [Colors.purple.shade300, Colors.indigo.shade300],
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    // Resumo do progresso geral
                    _buildProgressSummary(),
                    const SizedBox(height: 20),
                    
                    // Histórico de treinos
                    Expanded(
                      child: _allTrainingsEmpty()
                          ? _buildEmptyHistoryMessage()
                          : _buildHistoryList(),
                    ),
                  ],
                ),
              ),
      ),
      // Botão para limpar todo o progresso
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: const Icon(Icons.delete_forever),
        onPressed: () => _showClearProgressDialog(),
      ),
    );
  }
  
  bool _allTrainingsEmpty() {
    return _colorTrainingHistory.isEmpty && 
           _shapeTrainingHistory.isEmpty && 
           _quantityTrainingHistory.isEmpty;
  }
  
  Widget _buildProgressSummary() {
    int completedTrainings = _overallProgress['completedTrainings'] as int;
    int totalStars = _overallProgress['totalStars'] as int;
    bool colorTrainingCompleted = _overallProgress['colorTrainingCompleted'] as bool;
    bool shapeTrainingCompleted = _overallProgress['shapeTrainingCompleted'] as bool? ?? false;
    bool quantityTrainingCompleted = _overallProgress['quantityTrainingCompleted'] as bool? ?? false;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Resumo de Progresso",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Treinamentos completos:"),
              Row(
                children: [
                  Text(
                    "$completedTrainings",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 5),
                  const Icon(Icons.emoji_events, color: Colors.amber, size: 20),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Estrelas conquistadas:"),
              Row(
                children: [
                  Text(
                    "$totalStars",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 5),
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Treino de Cores:"),
              Row(
                children: [
                  Text(
                    colorTrainingCompleted ? "Concluído" : "Não concluído",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorTrainingCompleted ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    colorTrainingCompleted ? Icons.check_circle : Icons.cancel,
                    color: colorTrainingCompleted ? Colors.green : Colors.red,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Treino de Formas:"),
              Row(
                children: [
                  Text(
                    shapeTrainingCompleted ? "Concluído" : "Não concluído",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: shapeTrainingCompleted ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    shapeTrainingCompleted ? Icons.check_circle : Icons.cancel,
                    color: shapeTrainingCompleted ? Colors.green : Colors.red,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Treino de Quantidades:"),
              Row(
                children: [
                  Text(
                    quantityTrainingCompleted ? "Concluído" : "Não concluído",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: quantityTrainingCompleted ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    quantityTrainingCompleted ? Icons.check_circle : Icons.cancel,
                    color: quantityTrainingCompleted ? Colors.green : Colors.red,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmptyHistoryMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 80,
            color: Colors.white.withAlpha(128),
          ),
          const SizedBox(height: 20),
          const Text(
            "Nenhum histórico de treino encontrado",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Complete um treinamento para ver seu histórico aqui",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withAlpha(204),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildHistoryList() {
    // Combinar todos os históricos para exibição
    List<Map<String, dynamic>> allHistory = [];
    
    // Adicionar histórico de cores com tipo
    for (var stats in _colorTrainingHistory) {
      allHistory.add({
        ...stats,
        'type': 'color',
      });
    }
    
    // Adicionar histórico de formas com tipo
    for (var stats in _shapeTrainingHistory) {
      allHistory.add({
        ...stats,
        'type': 'shape',
      });
    }
    
    // Adicionar histórico de quantidades com tipo
    for (var stats in _quantityTrainingHistory) {
      allHistory.add({
        ...stats,
        'type': 'quantity',
      });
    }
    
    // Ordenar todos por data (mais recentes primeiro)
    allHistory.sort((a, b) {
      DateTime dateA = DateTime.parse(a['date']);
      DateTime dateB = DateTime.parse(b['date']);
      return dateB.compareTo(dateA);
    });
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            "Histórico de Treinamentos",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: allHistory.length,
            itemBuilder: (context, index) {
              final session = allHistory[index];
              
              final DateTime date = DateTime.parse(session['date']);
              final String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(date);
              
              final int successes = session['successes'];
              final int errors = session['errors'];
              final int totalAttempts = session['totalAttempts'];
              final String type = session['type'];
              
              final double successRate = (successes / totalAttempts) * 100;
              
              // Determinar o título e cor baseado no tipo de treino
              String title;
              Color cardColor;
              
              switch (type) {
                case 'color':
                  title = "Treino de Cores";
                  cardColor = Colors.red.shade100;
                  break;
                case 'shape':
                  title = "Treino de Formas";
                  cardColor = Colors.green.shade100;
                  break;
                case 'quantity':
                  title = "Treino de Quantidades";
                  cardColor = Colors.blue.shade100;
                  break;
                default:
                  title = "Treino";
                  cardColor = Colors.grey.shade100;
              }
              
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                elevation: 3,
                color: cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Taxa de sucesso:"),
                          Text(
                            "${successRate.toStringAsFixed(1)}%",
                            style: TextStyle(
                              color: _getColorForSuccessRate(successRate),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: LinearProgressIndicator(
                          value: successRate / 100,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getColorForSuccessRate(successRate),
                          ),
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatChip(
                            Icons.check_circle,
                            Colors.green,
                            "Acertos",
                            successes.toString(),
                          ),
                          _buildStatChip(
                            Icons.cancel,
                            Colors.red,
                            "Erros",
                            errors.toString(),
                          ),
                          _buildStatChip(
                            Icons.list,
                            Colors.blue,
                            "Total",
                            totalAttempts.toString(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildStatChip(IconData icon, Color color, String label, String value) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: color,
              size: 14,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
  
  Color _getColorForSuccessRate(double rate) {
    if (rate >= 90) return Colors.green[700]!;
    if (rate >= 70) return Colors.green[400]!;
    if (rate >= 50) return Colors.amber[700]!;
    if (rate >= 30) return Colors.orange[700]!;
    return Colors.red[400]!;
  }
  
  void _showClearProgressDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Limpar todo o progresso?"),
        content: const Text(
          "Essa ação não pode ser desfeita. Todos os seus dados de progresso serão excluídos permanentemente."
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              setState(() {
                _isLoading = true;
              });
              
              await ProgressService.clearAllProgress();
              
              if (_mounted) {
                await _loadProgressData();
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Todo o progresso foi apagado"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text(
              "Limpar",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}