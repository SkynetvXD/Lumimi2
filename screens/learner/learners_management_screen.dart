import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants/colors.dart';
import '../../models/learner.dart';
import '../../services/learner_service.dart';
import '../common_widgets/gradient_background.dart';
import '../menu/menu_trainings_page.dart';
import 'add_learner_dialog.dart';

class LearnersManagementScreen extends StatefulWidget {
  const LearnersManagementScreen({Key? key}) : super(key: key);

  @override
  State<LearnersManagementScreen> createState() => _LearnersManagementScreenState();
}

class _LearnersManagementScreenState extends State<LearnersManagementScreen> {
  List<Learner> _learners = [];
  String? _currentLearnerId;
  bool _isLoading = true;
  final dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _loadLearners();
  }

  // Carregar a lista de aprendizes
  Future<void> _loadLearners() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final learners = await LearnerService.getAllLearners();
      final currentId = await LearnerService.getCurrentLearnerId();

      setState(() {
        _learners = learners;
        _currentLearnerId = currentId;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao carregar aprendizes'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Alternar para outro aprendiz
  Future<void> _switchLearner(String learnerId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await LearnerService.setCurrentLearnerId(learnerId);
      setState(() {
        _currentLearnerId = learnerId;
      });

      if (!mounted) return;
      
      // Navegar de volta para o menu principal
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MenuTrainingsPage()),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao alternar aprendiz'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Remover um aprendiz
  Future<void> _removeLearner(Learner learner) async {
    // Confirmar remoção
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remover aprendiz'),
        content: Text('Tem certeza que deseja remover ${learner.name}? Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('CANCELAR'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('REMOVER', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await LearnerService.removeLearner(learner.id);
      if (success) {
        await _loadLearners();
        
        if (_learners.isEmpty) {
          // Se não houver mais aprendizes, voltar para a tela de boas-vindas
          if (!mounted) return;
          Navigator.of(context).pop();
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao remover aprendiz'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao remover aprendiz'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Adicionar um novo aprendiz
  Future<void> _addNewLearner() async {
    if (_learners.length >= LearnerService.maxLearners) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Limite de 10 aprendizes atingido'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final added = await showDialog<bool>(
      context: context,
      builder: (context) => const AddLearnerDialog(),
    );

    if (added == true) {
      await _loadLearners();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Aprendizes'),
        centerTitle: true,
      ),
      body: GradientBackground(
        colors: [Colors.indigo.shade300, Colors.blue.shade300],
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : _learners.isEmpty
                ? _buildEmptyState()
                : _buildLearnersList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewLearner,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Interface para quando não há aprendizes
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people,
            size: 80,
            color: Colors.white.withAlpha(150),
          ),
          const SizedBox(height: 16),
          const Text(
            'Nenhum aprendiz cadastrado',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Toque no botão + para adicionar',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withAlpha(200),
            ),
          ),
        ],
      ),
    );
  }

  // Lista de aprendizes
  Widget _buildLearnersList() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Selecione um aprendiz',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        
        // Contador de aprendizes
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Total: ${_learners.length} de ${LearnerService.maxLearners} aprendizes',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withAlpha(200),
            ),
          ),
        ),
        
        const SizedBox(height: 8),
        
        Expanded(
          child: ListView.builder(
            itemCount: _learners.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final learner = _learners[index];
              final isCurrentLearner = learner.id == _currentLearnerId;
              
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: isCurrentLearner
                      ? BorderSide(color: Colors.blue.shade300, width: 2)
                      : BorderSide.none,
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: isCurrentLearner
                        ? Colors.blue.shade500
                        : Colors.grey.shade300,
                    radius: 25,
                    child: Text(
                      learner.name.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isCurrentLearner ? Colors.white : Colors.black54,
                      ),
                    ),
                  ),
                  title: Text(
                    learner.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.cake, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            '${dateFormat.format(learner.birthDate)} (${learner.age} anos)',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      if (learner.diagnosis != null && learner.diagnosis!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.medical_information, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                learner.diagnosis!,
                                style: const TextStyle(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 8),
                      
                      // Tag de "Atual" para o aprendiz selecionado
                      if (isCurrentLearner)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Atual',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Botão de remover
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => _removeLearner(learner),
                      ),
                      
                      // Botão de selecionar (apenas se não for o atual)
                      if (!isCurrentLearner)
                        IconButton(
                          icon: const Icon(Icons.check_circle_outline, color: Colors.green),
                          onPressed: () => _switchLearner(learner.id),
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
}