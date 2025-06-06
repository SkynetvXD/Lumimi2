import 'package:flutter/material.dart';
import 'services/learner_service.dart';
import 'app.dart';
import 'screens/welcome/welcome_screen.dart';

void main() async {
  // Garante que os widgets Flutter estejam inicializados
  WidgetsFlutterBinding.ensureInitialized();
  
  // Verifica se já há aprendizes cadastrados
  final hasLearners = await LearnerService.hasLearners();
  
  // Se houver aprendizes, atualiza o último acesso do aprendiz atual
  if (hasLearners) {
    await LearnerService.updateCurrentLearnerLastAccess();
  }
  
  // Inicia o app com a tela apropriada
  runApp(MyAppWrapper(hasLearners: hasLearners));
}

class MyAppWrapper extends StatelessWidget {
  final bool hasLearners;
  
  const MyAppWrapper({super.key, required this.hasLearners});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      home: hasLearners ? const MyApp() : const WelcomeScreen(),
    );
  }
}