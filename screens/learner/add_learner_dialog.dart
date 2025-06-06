import 'package:flutter/material.dart';
import '../../models/learner.dart';
import '../../services/learner_service.dart';

class AddLearnerDialog extends StatefulWidget {
  const AddLearnerDialog({Key? key}) : super(key: key);

  @override
  State<AddLearnerDialog> createState() => _AddLearnerDialogState();
}

class _AddLearnerDialogState extends State<AddLearnerDialog> {
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
          if (!mounted) return;
          
          // Retornar true indicando que foi adicionado com sucesso
          Navigator.of(context).pop(true);
        } else {
          if (!mounted) return;
          
          // Mostrar erro caso não consiga adicionar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erro ao registrar aprendiz. Tente novamente.'),
              backgroundColor: Colors.red,
            ),
          );
          
          setState(() {
            _isLoading = false;
          });
        }
      } catch (e) {
        if (!mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao registrar aprendiz. Tente novamente.'),
            backgroundColor: Colors.red,
          ),
        );
        
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Adicionar Aprendiz'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(false),
          child: const Text('CANCELAR'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _registerLearner,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text('ADICIONAR'),
        ),
      ],
    );
  }
}