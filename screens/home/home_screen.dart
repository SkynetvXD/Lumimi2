import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../services/learner_service.dart';
import '../common_widgets/gradient_background.dart';
import '../welcome/welcome_screen.dart';
import 'therapist_screen.dart';
import 'patient_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        colors: AppColors.menuGradient,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo e nome do app
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 15,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.school,
                          color: Colors.indigo,
                          size: 60,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "Lumimi",
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2.0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Aprendizado divertido para todos!",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white.withAlpha(220),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 60),
                
                // Mensagem de boas-vindas
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(51),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withAlpha(128),
                      width: 1,
                    ),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        "Bem-vindo!",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Você é?",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Botões de seleção
                Column(
                  children: [
                    // Botão Paciente
                    _buildUserTypeButton(
                      context: context,
                      title: "Paciente",
                      subtitle: "Vou praticar e aprender",
                      icon: Icons.person,
                      color: Colors.blue,
                      onTap: () async {
                        // Verificar se há pacientes cadastrados
                        final hasLearners = await LearnerService.hasLearners();
                        
                        if (!mounted) return;
                        
                        if (hasLearners) {
                          // Se há pacientes, mostrar seleção
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PatientSelectionScreen(),
                            ),
                          );
                        } else {
                          // Se não há pacientes, ir direto para cadastro
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WelcomeScreen(),
                            ),
                          );
                        }
                      },
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Botão Terapeuta
                    _buildUserTypeButton(
                      context: context,
                      title: "Terapeuta",
                      subtitle: "Vou acompanhar o progresso",
                      icon: Icons.medical_services,
                      color: Colors.green,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TherapistScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                
                const SizedBox(height: 40),
                
                // Texto informativo
                Center(
                  child: Text(
                    "Escolha sua opção para começar",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withAlpha(180),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserTypeButton({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: color.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 40,
                color: color,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: color,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}