import 'package:flutter/material.dart';
import 'services/learner_service.dart';
import 'app.dart';
import 'screens/home/home_screen.dart';

void main() async {
  // Garante que os widgets Flutter estejam inicializados
  WidgetsFlutterBinding.ensureInitialized();
  
  // Verifica se já há aprendizes cadastrados
  final hasLearners = await LearnerService.hasLearners();
  
  // Se houver aprendizes, atualiza o último acesso do aprendiz atual
  if (hasLearners) {
    await LearnerService.updateCurrentLearnerLastAccess();
  }
  
  // Inicia o app sempre com a tela inicial
  runApp(MyAppWrapper());
}

class MyAppWrapper extends StatelessWidget {
  const MyAppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      home: const HomeScreen(),
    );
  }
}