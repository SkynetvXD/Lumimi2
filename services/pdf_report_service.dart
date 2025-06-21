import 'dart:io';
import 'package:intl/intl.dart';
import '../models/learner.dart';
import '../models/training_stats.dart';
import 'progress_service.dart';

class PdfReportService {
  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  // Versão simplificada que gera um relatório em texto
  // Depois pode ser atualizada para PDF quando as dependências estiverem instaladas
  static Future<File> generateWeeklyReport({
    required Learner learner,
    required DateTime startDate,
    required DateTime endDate,
    required String therapistName,
  }) async {
    // Carregar dados de progresso
    final colorStats = await ProgressService.getColorTrainingStats();
    final shapeStats = await ProgressService.getShapeTrainingStats();
    final quantityStats = await ProgressService.getQuantityTrainingStats();

    // Filtrar dados por período
    final weekColorStats = _filterStatsByWeek(colorStats, startDate, endDate);
    final weekShapeStats = _filterStatsByWeek(shapeStats, startDate, endDate);
    final weekQuantityStats = _filterStatsByWeek(quantityStats, startDate, endDate);

    // Calcular estatísticas da semana
    final weeklyAnalysis = _calculateWeeklyAnalysis(
      weekColorStats, 
      weekShapeStats, 
      weekQuantityStats
    );

    // Gerar conteúdo do relatório em texto
    final reportContent = _generateReportContent(
      learner,
      startDate,
      endDate,
      therapistName,
      weeklyAnalysis,
      weekColorStats,
      weekShapeStats,
      weekQuantityStats,
    );

    // Salvar como arquivo de texto temporariamente
    final fileName = 'relatorio_${learner.name.replaceAll(' ', '_')}_${_dateFormat.format(DateTime.now()).replaceAll('/', '_')}.txt';
    
    try {
      // Tentar salvar no diretório de documentos do aplicativo
      final directory = Directory.systemTemp;
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(reportContent);
      return file;
    } catch (e) {
      // Fallback: tentar criar arquivo no diretório atual
      try {
        final file = File(fileName);
        await file.writeAsString(reportContent);
        return file;
      } catch (e2) {
        // Último fallback: criar um arquivo temporário com timestamp
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final fallbackFile = File('relatorio_$timestamp.txt');
        await fallbackFile.writeAsString(reportContent);
        return fallbackFile;
      }
    }
  }

  static List<Map<String, dynamic>> _filterStatsByWeek(
    List<Map<String, dynamic>> stats,
    DateTime startDate,
    DateTime endDate,
  ) {
    return stats.where((stat) {
      final statDate = DateTime.parse(stat['date']);
      return statDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
             statDate.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  static Map<String, dynamic> _calculateWeeklyAnalysis(
    List<Map<String, dynamic>> colorStats,
    List<Map<String, dynamic>> shapeStats,
    List<Map<String, dynamic>> quantityStats,
  ) {
    final totalSessions = colorStats.length + shapeStats.length + quantityStats.length;
    
    int totalSuccesses = 0;
    int totalErrors = 0;
    int totalAttempts = 0;
    double totalDuration = 0;

    for (var stat in [...colorStats, ...shapeStats, ...quantityStats]) {
      totalSuccesses += stat['successes'] as int;
      totalErrors += stat['errors'] as int;
      totalAttempts += stat['totalAttempts'] as int;
      // Duração estimada: 1-2 minutos por tentativa
      totalDuration += (stat['totalAttempts'] as int) * 1.5;
    }

    final successRate = totalAttempts > 0 ? (totalSuccesses / totalAttempts) * 100 : 0.0;
    final averageDuration = totalSessions > 0 ? totalDuration / totalSessions : 0.0;

    return {
      'totalSessions': totalSessions,
      'totalSuccesses': totalSuccesses,
      'totalErrors': totalErrors,
      'totalAttempts': totalAttempts,
      'successRate': successRate,
      'averageDuration': averageDuration,
      'colorSessions': colorStats.length,
      'shapeSessions': shapeStats.length,
      'quantitySessions': quantityStats.length,
    };
  }

  static String _generateReportContent(
    Learner learner,
    DateTime startDate,
    DateTime endDate,
    String therapistName,
    Map<String, dynamic> analysis,
    List<Map<String, dynamic>> colorStats,
    List<Map<String, dynamic>> shapeStats,
    List<Map<String, dynamic>> quantityStats,
  ) {
    final buffer = StringBuffer();
    
    // Cabeçalho
    buffer.writeln('═══════════════════════════════════════════');
    buffer.writeln('               LUMIMI');
    buffer.writeln('        Relatório Semanal de Progresso');
    buffer.writeln('═══════════════════════════════════════════');
    buffer.writeln('');
    
    // I. DADOS DE IDENTIFICAÇÃO
    buffer.writeln('I. DADOS DE IDENTIFICAÇÃO');
    buffer.writeln('─────────────────────────────────────────');
    buffer.writeln('Nome: ${learner.name}');
    buffer.writeln('Nascimento: ${_dateFormat.format(learner.birthDate)}');
    buffer.writeln('Idade: ${learner.age} anos');
    if (learner.diagnosis != null && learner.diagnosis!.isNotEmpty) {
      buffer.writeln('Diagnóstico: ${learner.diagnosis}');
    }
    buffer.writeln('Equipe Responsável: $therapistName');
    buffer.writeln('Data do Relatório: ${_dateFormat.format(DateTime.now())}');
    buffer.writeln('');
    
    // II. DESEMPENHO SEMANAL
    buffer.writeln('II. DESEMPENHO SEMANAL');
    buffer.writeln('─────────────────────────────────────────');
    
    final totalSessions = analysis['totalSessions'] as int;
    final successRate = analysis['successRate'] as double;
    final averageDuration = analysis['averageDuration'] as double;
    
    buffer.writeln('No período de ${_dateFormat.format(startDate)} até ${_dateFormat.format(endDate)}, '
                  'o aprendiz ${learner.name} realizou $totalSessions sessões de treino, '
                  'com duração média de ${averageDuration.toStringAsFixed(1)} minutos por sessão, '
                  'apresentando uma taxa geral de acerto de ${successRate.toStringAsFixed(1)}%.');
    buffer.writeln('');
    
    // Detalhes por tipo de treino
    if (colorStats.isNotEmpty) {
      buffer.writeln(_buildTrainingDetails('Treino de Cores', colorStats));
      buffer.writeln('');
    }
    
    if (shapeStats.isNotEmpty) {
      buffer.writeln(_buildTrainingDetails('Treino de Formas', shapeStats));
      buffer.writeln('');
    }
    
    if (quantityStats.isNotEmpty) {
      buffer.writeln(_buildTrainingDetails('Treino de Quantidades', quantityStats));
      buffer.writeln('');
    }
    
    // Tabela de progresso
    buffer.writeln(_buildProgressTable(colorStats, shapeStats, quantityStats));
    buffer.writeln('');
    
    // III. CONCLUSÃO E RECOMENDAÇÕES
    buffer.writeln('III. CONCLUSÃO E RECOMENDAÇÕES');
    buffer.writeln('─────────────────────────────────────────');
    buffer.writeln(_buildConclusionSection(learner, analysis));
    
    buffer.writeln('');
    buffer.writeln('═══════════════════════════════════════════');
    buffer.writeln('Relatório gerado automaticamente pelo Lumimi');
    buffer.writeln('Data: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}');
    buffer.writeln('═══════════════════════════════════════════');
    
    return buffer.toString();
  }

  static String _buildTrainingDetails(String trainingType, List<Map<String, dynamic>> stats) {
    int totalSuccesses = 0;
    int totalErrors = 0;
    int totalAttempts = 0;

    for (var stat in stats) {
      totalSuccesses += stat['successes'] as int;
      totalErrors += stat['errors'] as int;
      totalAttempts += stat['totalAttempts'] as int;
    }

    final successRate = totalAttempts > 0 ? (totalSuccesses / totalAttempts) * 100 : 0.0;
    final averageSuccesses = stats.isNotEmpty ? totalSuccesses / stats.length : 0.0;
    final averageErrors = stats.isNotEmpty ? totalErrors / stats.length : 0.0;

    final buffer = StringBuffer();
    buffer.writeln('$trainingType:');
    buffer.writeln('• Sessões realizadas: ${stats.length}');
    buffer.writeln('• Total de acertos: $totalSuccesses (média de ${averageSuccesses.toStringAsFixed(1)} por sessão)');
    buffer.writeln('• Total de erros: $totalErrors (média de ${averageErrors.toStringAsFixed(1)} por sessão)');
    buffer.writeln('• Taxa de acerto: ${successRate.toStringAsFixed(1)}%');
    
    return buffer.toString();
  }

  static String _buildProgressTable(
    List<Map<String, dynamic>> colorStats,
    List<Map<String, dynamic>> shapeStats,
    List<Map<String, dynamic>> quantityStats,
  ) {
    // Combinar todos os stats e ordenar por data
    final allStats = <Map<String, dynamic>>[];
    
    for (var stat in colorStats) {
      allStats.add({...stat, 'type': 'Cores'});
    }
    for (var stat in shapeStats) {
      allStats.add({...stat, 'type': 'Formas'});
    }
    for (var stat in quantityStats) {
      allStats.add({...stat, 'type': 'Quantidades'});
    }
    
    allStats.sort((a, b) => DateTime.parse(a['date']).compareTo(DateTime.parse(b['date'])));

    if (allStats.isEmpty) {
      return 'Nenhum dado disponível para análise';
    }

    final buffer = StringBuffer();
    buffer.writeln('Resumo das Sessões de Treino:');
    buffer.writeln('┌──────────┬──────────────┬─────────┬──────────┐');
    buffer.writeln('│   Data   │     Tipo     │ Acertos │ Taxa (%) │');
    buffer.writeln('├──────────┼──────────────┼─────────┼──────────┤');
    
    // Mostrar últimas 10 sessões
    for (var stat in allStats.take(10)) {
      final date = DateTime.parse(stat['date']);
      final successes = stat['successes'] as int;
      final totalAttempts = stat['totalAttempts'] as int;
      final successRate = totalAttempts > 0 ? (successes / totalAttempts) * 100 : 0.0;
      
      final dateStr = DateFormat('dd/MM').format(date).padRight(8);
      final typeStr = (stat['type'] as String).padRight(12);
      final attemptsStr = '$successes/$totalAttempts'.padRight(7);
      final rateStr = '${successRate.toStringAsFixed(1)}%'.padLeft(8);
      
      buffer.writeln('│ $dateStr │ $typeStr │ $attemptsStr │ $rateStr │');
    }
    
    buffer.writeln('└──────────┴──────────────┴─────────┴──────────┘');
    
    return buffer.toString();
  }

  static String _buildConclusionSection(Learner learner, Map<String, dynamic> analysis) {
    final successRate = analysis['successRate'] as double;
    final totalSessions = analysis['totalSessions'] as int;
    
    String performanceText;
    String recommendations;
    
    if (successRate >= 80) {
      performanceText = 'excelente progresso';
      recommendations = 'Recomendamos continuar com os treinos atuais e considerar aumentar '
                       'gradualmente a dificuldade. O aprendiz demonstra estar pronto para '
                       'desafios mais complexos e aplicação das habilidades em diferentes contextos.';
    } else if (successRate >= 60) {
      performanceText = 'bom progresso';
      recommendations = 'Recomendamos manter a frequência atual dos treinos e focar nos '
                       'tipos de atividades onde há maior dificuldade. Aplicar estratégias '
                       'de reforço positivo para consolidar as habilidades adquiridas.';
    } else if (successRate >= 40) {
      performanceText = 'progresso moderado';
      recommendations = 'Recomendamos revisar as estratégias de ensino e considerar '
                       'simplificar as atividades temporariamente. Aumentar a frequência '
                       'dos treinos e utilizar mais dicas visuais e verbais.';
    } else {
      performanceText = 'necessidade de ajustes na metodologia';
      recommendations = 'Recomendamos uma revisão completa da abordagem terapêutica. '
                       'Considerar avaliação adicional das habilidades pré-requisito '
                       'e implementar estratégias mais individualizadas.';
    }

    final buffer = StringBuffer();
    buffer.writeln('Nesta semana, o aprendiz ${learner.name} apresentou $performanceText, '
                  'realizando $totalSessions sessões com uma taxa média de acerto de '
                  '${successRate.toStringAsFixed(1)}%. Baseando-se nos dados obtidos, '
                  'observa-se desenvolvimento nas habilidades de discriminação, atenção '
                  'e seguimento de instruções.');
    buffer.writeln('');
    buffer.writeln(recommendations);
    buffer.writeln('');
    buffer.writeln('Observações Adicionais:');
    buffer.writeln('• Aplicar os treinos em ambiente controlado para melhor concentração');
    buffer.writeln('• Considerar a generalização das habilidades para ambiente natural');
    buffer.writeln('• Manter registro contínuo do progresso para ajustes futuros');
    buffer.writeln('• Envolver família/cuidadores no processo de aprendizagem');
    
    return buffer.toString();
  }

  static Future<void> shareReport(File reportFile) async {
    // Mostrar informações sobre o arquivo criado
    print('📄 Relatório gerado com sucesso!');
    print('📁 Localização: ${reportFile.path}');
    print('📊 Tamanho: ${await reportFile.length()} bytes');
    
    // Para desenvolvimento: mostrar conteúdo parcial
    try {
      final content = await reportFile.readAsString();
      print('📋 Primeiras linhas do relatório:');
      print(content.split('\n').take(5).join('\n'));
      print('...');
    } catch (e) {
      print('❌ Erro ao ler arquivo: $e');
    }
  }
}