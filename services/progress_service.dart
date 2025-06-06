import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/training_stats.dart';

class ProgressService {
  static const String _colorTrainingKey = 'color_training_stats';
  static const String _shapeTrainingKey = 'shape_training_stats';
  static const String _sequenceTrainingKey = 'sequence_training_stats';
  static const String _imageAssociationKey = 'image_association_stats';
  static const String _quantityTrainingKey = 'quantity_training_stats';
  static const String _puzzleTrainingKey = 'puzzle_training_stats';
  static const String _overallProgressKey = 'overall_progress';

  // Salvar estatísticas de treinamento de cores
  static Future<bool> saveColorTrainingStats(TrainingStats stats) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Converter para mapa e depois para JSON
    final statsMap = {
      'successes': stats.successes,
      'errors': stats.errors,
      'totalAttempts': stats.totalAttempts,
      'date': DateTime.now().toIso8601String(),
    };
    
    // Obter a lista atual se existir
    List<String> statsList = prefs.getStringList(_colorTrainingKey) ?? [];
    
    // Adicionar nova entrada
    statsList.add(jsonEncode(statsMap));
    
    // Salvar lista atualizada
    return await prefs.setStringList(_colorTrainingKey, statsList);
  }

  // Obter todas as estatísticas de treinamento de cores
  static Future<List<Map<String, dynamic>>> getColorTrainingStats() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Obter a lista de JSON
    List<String> statsList = prefs.getStringList(_colorTrainingKey) ?? [];
    
    // Converter para lista de mapas
    return statsList.map((statsJson) => 
      Map<String, dynamic>.from(jsonDecode(statsJson))).toList();
  }

  // Obter a última estatística de treinamento de cores
  static Future<TrainingStats?> getLastColorTrainingStats() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Obter a lista de JSON
    List<String> statsList = prefs.getStringList(_colorTrainingKey) ?? [];
    
    if (statsList.isEmpty) {
      return null;
    }
    
    // Pegar o último item e converter para TrainingStats
    final lastStatsMap = jsonDecode(statsList.last);
    return TrainingStats(
      successes: lastStatsMap['successes'],
      errors: lastStatsMap['errors'],
      totalAttempts: lastStatsMap['totalAttempts'],
    );
  }

  // Calcular estatísticas médias para treinamento de cores
  static Future<TrainingStats?> getAverageColorTrainingStats() async {
    final statsList = await getColorTrainingStats();
    
    if (statsList.isEmpty) {
      return null;
    }
    
    int totalSuccesses = 0;
    int totalErrors = 0;
    int totalAttempts = 0;
    
    for (var stats in statsList) {
      totalSuccesses += stats['successes'] as int;
      totalErrors += stats['errors'] as int;
      totalAttempts += stats['totalAttempts'] as int;
    }
    
    return TrainingStats(
      successes: totalSuccesses ~/ statsList.length,
      errors: totalErrors ~/ statsList.length,
      totalAttempts: totalAttempts ~/ statsList.length,
    );
  }

  // Salvar estatísticas de treinamento de formas
  static Future<bool> saveShapeTrainingStats(TrainingStats stats) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Converter para mapa e depois para JSON
    final statsMap = {
      'successes': stats.successes,
      'errors': stats.errors,
      'totalAttempts': stats.totalAttempts,
      'date': DateTime.now().toIso8601String(),
    };
    
    // Obter a lista atual se existir
    List<String> statsList = prefs.getStringList(_shapeTrainingKey) ?? [];
    
    // Adicionar nova entrada
    statsList.add(jsonEncode(statsMap));
    
    // Salvar lista atualizada
    return await prefs.setStringList(_shapeTrainingKey, statsList);
  }

  // Obter todas as estatísticas de treinamento de formas
  static Future<List<Map<String, dynamic>>> getShapeTrainingStats() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Obter a lista de JSON
    List<String> statsList = prefs.getStringList(_shapeTrainingKey) ?? [];
    
    // Converter para lista de mapas
    return statsList.map((statsJson) => 
      Map<String, dynamic>.from(jsonDecode(statsJson))).toList();
  }

  // Obter a última estatística de treinamento de formas
  static Future<TrainingStats?> getLastShapeTrainingStats() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Obter a lista de JSON
    List<String> statsList = prefs.getStringList(_shapeTrainingKey) ?? [];
    
    if (statsList.isEmpty) {
      return null;
    }
    
    // Pegar o último item e converter para TrainingStats
    final lastStatsMap = jsonDecode(statsList.last);
    return TrainingStats(
      successes: lastStatsMap['successes'],
      errors: lastStatsMap['errors'],
      totalAttempts: lastStatsMap['totalAttempts'],
    );
  }
  
  // Salvar estatísticas de treinamento de quantidades
  static Future<bool> saveQuantityTrainingStats(TrainingStats stats) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Converter para mapa e depois para JSON
    final statsMap = {
      'successes': stats.successes,
      'errors': stats.errors,
      'totalAttempts': stats.totalAttempts,
      'date': DateTime.now().toIso8601String(),
    };
    
    // Obter a lista atual se existir
    List<String> statsList = prefs.getStringList(_quantityTrainingKey) ?? [];
    
    // Adicionar nova entrada
    statsList.add(jsonEncode(statsMap));
    
    // Salvar lista atualizada
    return await prefs.setStringList(_quantityTrainingKey, statsList);
  }

  // Obter todas as estatísticas de treinamento de quantidades
  static Future<List<Map<String, dynamic>>> getQuantityTrainingStats() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Obter a lista de JSON
    List<String> statsList = prefs.getStringList(_quantityTrainingKey) ?? [];
    
    // Converter para lista de mapas
    return statsList.map((statsJson) => 
      Map<String, dynamic>.from(jsonDecode(statsJson))).toList();
  }

  // Obter a última estatística de treinamento de quantidades
  static Future<TrainingStats?> getLastQuantityTrainingStats() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Obter a lista de JSON
    List<String> statsList = prefs.getStringList(_quantityTrainingKey) ?? [];
    
    if (statsList.isEmpty) {
      return null;
    }
    
    // Pegar o último item e converter para TrainingStats
    final lastStatsMap = jsonDecode(statsList.last);
    return TrainingStats(
      successes: lastStatsMap['successes'],
      errors: lastStatsMap['errors'],
      totalAttempts: lastStatsMap['totalAttempts'],
    );
  }

  // Obter progresso geral (todos os treinamentos combinados)
  static Future<Map<String, dynamic>> getOverallProgress() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Obter o progresso geral se existir
    String? progressJson = prefs.getString(_overallProgressKey);
    
    if (progressJson == null) {
      return {
        'completedTrainings': 0,
        'totalStars': 0,
        'colorTrainingCompleted': false,
        'shapeTrainingCompleted': false,
        'sequenceTrainingCompleted': false,
        'imageAssociationCompleted': false,
        'quantityTrainingCompleted': false,
        'puzzleTrainingCompleted': false,
      };
    }
    
    // Ensure all fields exist in the returned map
    final Map<String, dynamic> progressMap = Map<String, dynamic>.from(jsonDecode(progressJson));
    
    // Add missing fields with defaults if necessary
    if (!progressMap.containsKey('colorTrainingCompleted')) {
      progressMap['colorTrainingCompleted'] = false;
    }
    if (!progressMap.containsKey('shapeTrainingCompleted')) {
      progressMap['shapeTrainingCompleted'] = false;
    }
    if (!progressMap.containsKey('sequenceTrainingCompleted')) {
      progressMap['sequenceTrainingCompleted'] = false;
    }
    if (!progressMap.containsKey('imageAssociationCompleted')) {
      progressMap['imageAssociationCompleted'] = false;
    }
    if (!progressMap.containsKey('quantityTrainingCompleted')) {
      progressMap['quantityTrainingCompleted'] = false;
    }
    if (!progressMap.containsKey('puzzleTrainingCompleted')) {
      progressMap['puzzleTrainingCompleted'] = false;
    }
    
    return progressMap;
  }

  // Atualizar progresso geral
  static Future<bool> updateOverallProgress(Map<String, dynamic> progress) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_overallProgressKey, jsonEncode(progress));
  }

  // Atualizar status de conclusão para o treinamento de cores
  static Future<bool> markColorTrainingCompleted() async {
    final progress = await getOverallProgress();
    
    // Se já estiver marcado como concluído, não faz nada
    if (progress['colorTrainingCompleted'] == true) {
      return true;
    }
    
    // Atualizar valores
    progress['colorTrainingCompleted'] = true;
    progress['completedTrainings'] = (progress['completedTrainings'] as int) + 1;
    
    // Adicionar estrelas com base na média de desempenho
    final avgStats = await getAverageColorTrainingStats();
    if (avgStats != null) {
      int stars = 0;
      double successRate = avgStats.successPercentage;
      
      if (successRate >= 90) {
        stars = 3;
      } else if (successRate >= 70) stars = 2;
      else stars = 1;
      
      progress['totalStars'] = (progress['totalStars'] as int) + stars;
    }
    
    return await updateOverallProgress(progress);
  }

  // Atualizar status de conclusão para o treinamento de formas
  static Future<bool> markShapeTrainingCompleted() async {
    final progress = await getOverallProgress();
    
    // Se já estiver marcado como concluído, não faz nada
    if (progress['shapeTrainingCompleted'] == true) {
      return true;
    }
    
    // Atualizar valores
    progress['shapeTrainingCompleted'] = true;
    progress['completedTrainings'] = (progress['completedTrainings'] as int) + 1;
    
    // Adicionar estrelas com base na média de desempenho
    final avgStats = await getLastShapeTrainingStats();
    if (avgStats != null) {
      int stars = 0;
      double successRate = avgStats.successPercentage;
      
      if (successRate >= 90) {
        stars = 3;
      } else if (successRate >= 70) stars = 2;
      else stars = 1;
      
      progress['totalStars'] = (progress['totalStars'] as int) + stars;
    }
    
    return await updateOverallProgress(progress);
  }
  
  // Atualizar status de conclusão para o treinamento de quantidades
  static Future<bool> markQuantityTrainingCompleted() async {
    final progress = await getOverallProgress();
    
    // Se já estiver marcado como concluído, não faz nada
    if (progress['quantityTrainingCompleted'] == true) {
      return true;
    }
    
    // Atualizar valores
    progress['quantityTrainingCompleted'] = true;
    progress['completedTrainings'] = (progress['completedTrainings'] as int) + 1;
    
    // Adicionar estrelas com base na média de desempenho
    final avgStats = await getLastQuantityTrainingStats();
    if (avgStats != null) {
      int stars = 0;
      double successRate = avgStats.successPercentage;
      
      if (successRate >= 90) {
        stars = 3;
      } else if (successRate >= 70) stars = 2;
      else stars = 1;
      
      progress['totalStars'] = (progress['totalStars'] as int) + stars;
    }
    
    return await updateOverallProgress(progress);
  }

  // Limpar todos os dados de progresso
  static Future<bool> clearAllProgress() async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.remove(_colorTrainingKey);
    await prefs.remove(_shapeTrainingKey);
    await prefs.remove(_sequenceTrainingKey);
    await prefs.remove(_imageAssociationKey);
    await prefs.remove(_quantityTrainingKey);
    await prefs.remove(_puzzleTrainingKey);
    await prefs.remove(_overallProgressKey);
    
    return true;
  }
  
  // Função para gerar mensagem personalizada de acordo com o desempenho
  static String getPerformanceMessage(double successPercentage) {
    if (successPercentage >= 90) {
      return "Incrível! Você é um verdadeiro expert! 🌟";
    } else if (successPercentage >= 70) {
      return "Muito bom! Você tem um ótimo conhecimento! 😃";
    } else if (successPercentage >= 50) {
      return "Bom trabalho! Continue praticando para melhorar! 👍";
    } else {
      return "Vamos praticar mais! A cada tentativa você vai melhorar! 💪";
    }
  }
}