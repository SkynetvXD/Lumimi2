import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/learner.dart';

class LearnerService {
  static const String _learnersKey = 'learners';
  static const String _currentLearnerIdKey = 'current_learner_id';
  static const int maxLearners = 10;

  // Obter todos os aprendizes
  static Future<List<Learner>> getAllLearners() async {
    final prefs = await SharedPreferences.getInstance();
    final learnersList = prefs.getStringList(_learnersKey) ?? [];
    
    return learnersList
        .map((learnerJson) => Learner.fromJson(learnerJson))
        .toList();
  }

  // Adicionar um novo aprendiz
  static Future<bool> addLearner(Learner learner) async {
    final prefs = await SharedPreferences.getInstance();
    final learners = await getAllLearners();
    
    // Verificar se atingiu o limite de aprendizes
    if (learners.length >= maxLearners) {
      return false;
    }
    
    // Adicionar o novo aprendiz
    learners.add(learner);
    
    // Salvar a lista atualizada
    final learnersJsonList = learners.map((l) => l.toJson()).toList();
    final saved = await prefs.setStringList(_learnersKey, learnersJsonList);
    
    // Se é o primeiro aprendiz, defini-lo como atual
    if (learners.length == 1) {
      await setCurrentLearnerId(learner.id);
    }
    
    return saved;
  }

  // Atualizar um aprendiz existente
  static Future<bool> updateLearner(Learner learner) async {
    final prefs = await SharedPreferences.getInstance();
    final learners = await getAllLearners();
    
    // Encontrar o índice do aprendiz a ser atualizado
    final index = learners.indexWhere((l) => l.id == learner.id);
    if (index == -1) {
      return false;
    }
    
    // Atualizar o aprendiz
    learners[index] = learner;
    
    // Salvar a lista atualizada
    final learnersJsonList = learners.map((l) => l.toJson()).toList();
    return await prefs.setStringList(_learnersKey, learnersJsonList);
  }

  // Remover um aprendiz
  static Future<bool> removeLearner(String learnerId) async {
    final prefs = await SharedPreferences.getInstance();
    final learners = await getAllLearners();
    
    // Remover o aprendiz
    learners.removeWhere((l) => l.id == learnerId);
    
    // Salvar a lista atualizada
    final learnersJsonList = learners.map((l) => l.toJson()).toList();
    final saved = await prefs.setStringList(_learnersKey, learnersJsonList);
    
    // Se o aprendiz removido era o atual, definir outro como atual
    final currentId = await getCurrentLearnerId();
    if (currentId == learnerId && learners.isNotEmpty) {
      await setCurrentLearnerId(learners.first.id);
    } else if (learners.isEmpty) {
      await prefs.remove(_currentLearnerIdKey);
    }
    
    return saved;
  }

  // Obter o ID do aprendiz atual
  static Future<String?> getCurrentLearnerId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentLearnerIdKey);
  }

  // Definir o ID do aprendiz atual
  static Future<bool> setCurrentLearnerId(String learnerId) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_currentLearnerIdKey, learnerId);
  }

  // Obter o aprendiz atual
  static Future<Learner?> getCurrentLearner() async {
    final currentId = await getCurrentLearnerId();
    if (currentId == null) return null;
    
    final learners = await getAllLearners();
    // Erro estava na linha abaixo: expressão 'orElse' estava retornando 'null' que não é do tipo 'Learner'
    // mas estava dentro de um contexto onde o tipo de retorno esperado é 'Learner'
    return learners.firstWhere(
      (l) => l.id == currentId,
      orElse: () => learners.isNotEmpty ? learners.first : throw Exception("No learner found"),
    );
  }

  // Atualizar o último acesso do aprendiz atual
  static Future<bool> updateCurrentLearnerLastAccess() async {
    final currentLearner = await getCurrentLearner();
    if (currentLearner == null) return false;
    
    final updatedLearner = currentLearner.updateLastAccess();
    return await updateLearner(updatedLearner);
  }

  // Verificar se tem algum aprendiz cadastrado
  static Future<bool> hasLearners() async {
    final learners = await getAllLearners();
    return learners.isNotEmpty;
  }

  // Gerar um ID único para um novo aprendiz
  static String generateUniqueId() {
    final random = Random();
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(10, (_) => chars[random.nextInt(chars.length)]).join();
  }
}