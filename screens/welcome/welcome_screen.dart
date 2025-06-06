import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../models/learner.dart';
import '../../services/learner_service.dart';
import '../common_widgets/gradient_background.dart';
import '../menu/menu_trainings_page.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _diagnosisController = TextEditingController();
  DateTime? _selectedBirthDate;
  bool _isLoading = false;
  String? _dateErrorText;

  @override
  void dispose() {
    _nameController.dispose();
    _diagnosisController.dispose();
    super.dispose();
  }
  
  // Método simplificado para atualizar a data de nascimento
  void _updateBirthDate(String value) {
    // Verifica o formato da data (DD/MM/AAAA)
    if (RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(value)) {
      try {
        final parts = value.split('/');
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        
        // Verificação básica de validade
        if (day >= 1 && day <= 31 && month >= 1 && month <= 12 && year >= 1900 && year <= DateTime.now().year) {
          // Criar um objeto DateTime válido
          final date = DateTime(year, month, day);
          
          // Verificar se a data é igual à do objeto criado (validação de dias por mês)
          final newDay = date.day;
          final newMonth = date.month;
          final newYear = date.year;
          
          if (day == newDay && month == newMonth && year == newYear) {
            setState(() {
              _selectedBirthDate = date;
              _dateErrorText = null;
            });
            return;
          }
        }
        
        setState(() {
          _dateErrorText = 'Data inválida';
          _selectedBirthDate = null;
        });
      } catch (e) {
        setState(() {
          _dateErrorText = 'Data inválida';
          _selectedBirthDate = null;
        });
      }
    } else if (value.isNotEmpty) {
      setState(() {
        _dateErrorText = 'Formato inválido. Use DD/MM/AAAA';
        _selectedBirthDate = null;
      });
    } else {
      setState(() {
        _dateErrorText = null;
        _selectedBirthDate = null;
      });
    }
  }

  // Função para registrar um novo aprendiz
  Future<void> _registerLearner() async {
    if (_formKey.currentState!.validate() && _selectedBirthDate != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Criar um novo aprendiz
        final newLearner = Learner(
          id: LearnerService.generateUniqueId(),
          name: _nameController.text.trim(),
          birthDate: _selectedBirthDate!,
          diagnosis: _diagnosisController.text.trim().isNotEmpty 
              ? _diagnosisController.text.trim() 
              : null,
          createdAt: DateTime.now(),
          lastAccess: DateTime.now(),
        );

        // Adicionar o aprendiz
        final success = await LearnerService.addLearner(newLearner);

        if (success) {
          // Navegação para a tela principal
          if (!mounted) return;
          
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MenuTrainingsPage()),
          );
        } else {
          if (!mounted) return;
          
          // Mostrar erro caso não consiga adicionar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erro ao registrar aprendiz. Tente novamente.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        colors: AppColors.menuGradient,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  
                  // Logo e título
                  Center(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.school,
                          color: Colors.white,
                          size: 80,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Lumimi",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Aprendizado divertido!",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white.withAlpha(220),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Card com formulário
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Vamos começar!",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Preencha os dados do aprendiz para continuar",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            // Campo de nome
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: "Nome do Aprendiz",
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().length < 2) {
                                  return "Por favor, informe um nome válido";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            
                            // Campo de data de nascimento simplificado (entrada de texto)
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "Data de Nascimento",
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.calendar_today),
                                hintText: 'DD/MM/AAAA',
                                errorText: _dateErrorText,
                                helperText: 'Exemplo: 30/12/2000',
                              ),
                              keyboardType: TextInputType.datetime,
                              onChanged: _updateBirthDate,
                              validator: (value) {
                                if (_selectedBirthDate == null) {
                                  return "Por favor, informe uma data válida";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            
                            // Campo de diagnóstico (opcional)
                            TextFormField(
                              controller: _diagnosisController,
                              decoration: const InputDecoration(
                                labelText: "Diagnóstico (opcional)",
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.medical_information),
                              ),
                              maxLines: 2,
                            ),
                            const SizedBox(height: 24),
                            
                            // Botão de cadastro
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _registerLearner,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: _isLoading
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : const Text(
                                        "CADASTRAR",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}