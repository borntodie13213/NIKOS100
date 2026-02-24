import '../services/auth_service.dart';

class DataService {
  static final List<Map<String, dynamic>> _jogos = _gerarJogosDemonstracao();
  static final List<Map<String, dynamic>> _palpites = [];
  static final List<Map<String, dynamic>> _logs = [];
  static DateTime? _rankingCacheTime;

  static List<Map<String, dynamic>> _gerarJogosDemonstracao() {
    final jogos = <Map<String, dynamic>>[];
    int jogoId = 1;
    
    final grupos = {
      'A': [
        {'time': 'Catar', 'bandeira': 'QA'},
        {'time': 'Equador', 'bandeira': 'EC'},
        {'time': 'Senegal', 'bandeira': 'SN'},
        {'time': 'Holanda', 'bandeira': 'NL'},
      ],
      'B': [
        {'time': 'Inglaterra', 'bandeira': 'GB'},
        {'time': 'Ira', 'bandeira': 'IR'},
        {'time': 'EUA', 'bandeira': 'US'},
        {'time': 'Pais de Gales', 'bandeira': 'GB'},
      ],
      'C': [
        {'time': 'Argentina', 'bandeira': 'AR'},
        {'time': 'Arabia Saudita', 'bandeira': 'SA'},
        {'time': 'Mexico', 'bandeira': 'MX'},
        {'time': 'Polonia', 'bandeira': 'PL'},
      ],
      'D': [
        {'time': 'Franca', 'bandeira': 'FR'},
        {'time': 'Australia', 'bandeira': 'AU'},
        {'time': 'Dinamarca', 'bandeira': 'DK'},
        {'time': 'Tunisia', 'bandeira': 'TN'},
      ],
      'E': [
        {'time': 'Espanha', 'bandeira': 'ES'},
        {'time': 'Costa Rica', 'bandeira': 'CR'},
        {'time': 'Alemanha', 'bandeira': 'DE'},
        {'time': 'Japao', 'bandeira': 'JP'},
      ],
      'F': [
        {'time': 'Belgica', 'bandeira': 'BE'},
        {'time': 'Canada', 'bandeira': 'CA'},
        {'time': 'Marrocos', 'bandeira': 'MA'},
        {'time': 'Croacia', 'bandeira': 'HR'},
      ],
      'G': [
        {'time': 'Brasil', 'bandeira': 'BR'},
        {'time': 'Servia', 'bandeira': 'RS'},
        {'time': 'Suica', 'bandeira': 'CH'},
        {'time': 'Camaroes', 'bandeira': 'CM'},
      ],
      'H': [
        {'time': 'Portugal', 'bandeira': 'PT'},
        {'time': 'Gana', 'bandeira': 'GH'},
        {'time': 'Uruguai', 'bandeira': 'UY'},
        {'time': 'Coreia do Sul', 'bandeira': 'KR'},
      ],
    };

    var dataBase = DateTime.now().add(const Duration(days: 1));
    int jogoNum = 0;

    grupos.forEach((grupo, times) {
      for (int i = 0; i < times.length; i++) {
        for (int j = i + 1; j < times.length; j++) {
          final time1 = times[i];
          final time2 = times[j];
          final isBrasil = time1['time'] == 'Brasil' || time2['time'] == 'Brasil';
          
          jogos.add({
            'id': '${jogoId++}',
            'time1': time1['time'],
            'time2': time2['time'],
            'bandeira1': time1['bandeira'],
            'bandeira2': time2['bandeira'],
            'dataHora': dataBase.add(Duration(hours: jogoNum * 4)).toIso8601String(),
            'fase': 'Fase de Grupos',
            'grupo': 'Grupo $grupo',
            'golsTime1': null,
            'golsTime2': null,
            'finalizado': false,
            'dobroPontos': isBrasil,
            'jogoDoBrasil': isBrasil,
          });
          jogoNum++;
        }
      }
    });

    for (int i = 0; i < 8; i++) {
      jogos.add({
        'id': '${jogoId++}',
        'time1': '1o Grupo ${String.fromCharCode(65 + i)}',
        'time2': '2o Grupo ${String.fromCharCode(65 + ((i + 1) % 8))}',
        'bandeira1': '',
        'bandeira2': '',
        'dataHora': dataBase.add(Duration(hours: jogoNum * 4)).toIso8601String(),
        'fase': 'Oitavas de Final',
        'grupo': '',
        'golsTime1': null,
        'golsTime2': null,
        'finalizado': false,
        'dobroPontos': false,
        'jogoDoBrasil': false,
      });
      jogoNum++;
    }

    for (int i = 0; i < 4; i++) {
      jogos.add({
        'id': '${jogoId++}',
        'time1': 'Vencedor Oitavas ${i * 2 + 1}',
        'time2': 'Vencedor Oitavas ${i * 2 + 2}',
        'bandeira1': '',
        'bandeira2': '',
        'dataHora': dataBase.add(Duration(hours: jogoNum * 4)).toIso8601String(),
        'fase': 'Quartas de Final',
        'grupo': '',
        'golsTime1': null,
        'golsTime2': null,
        'finalizado': false,
        'dobroPontos': false,
        'jogoDoBrasil': false,
      });
      jogoNum++;
    }

    for (int i = 0; i < 2; i++) {
      jogos.add({
        'id': '${jogoId++}',
        'time1': 'Vencedor Quartas ${i * 2 + 1}',
        'time2': 'Vencedor Quartas ${i * 2 + 2}',
        'bandeira1': '',
        'bandeira2': '',
        'dataHora': dataBase.add(Duration(hours: jogoNum * 4)).toIso8601String(),
        'fase': 'Semifinal',
        'grupo': '',
        'golsTime1': null,
        'golsTime2': null,
        'finalizado': false,
        'dobroPontos': false,
        'jogoDoBrasil': false,
      });
      jogoNum++;
    }

    jogos.add({
      'id': '${jogoId++}',
      'time1': 'Perdedor Semi 1',
      'time2': 'Perdedor Semi 2',
      'bandeira1': '',
      'bandeira2': '',
      'dataHora': dataBase.add(Duration(hours: jogoNum * 4)).toIso8601String(),
      'fase': 'Disputa 3o Lugar',
      'grupo': '',
      'golsTime1': null,
      'golsTime2': null,
      'finalizado': false,
      'dobroPontos': false,
      'jogoDoBrasil': false,
    });
    jogoNum++;

    jogos.add({
      'id': '${jogoId++}',
      'time1': 'Vencedor Semi 1',
      'time2': 'Vencedor Semi 2',
      'bandeira1': '',
      'bandeira2': '',
      'dataHora': dataBase.add(Duration(hours: jogoNum * 4)).toIso8601String(),
      'fase': 'Final',
      'grupo': '',
      'golsTime1': null,
      'golsTime2': null,
      'finalizado': false,
      'dobroPontos': true,
      'jogoDoBrasil': false,
    });

    return jogos;
  }

  static List<Map<String, dynamic>> getJogos() => _jogos;

  static void updateJogo(Map<String, dynamic> jogo) {
    final index = _jogos.indexWhere((j) => j['id'] == jogo['id']);
    if (index != -1) {
      _jogos[index] = jogo;
    }
  }

  static void addJogo(Map<String, dynamic> jogo) {
    _jogos.add(jogo);
  }

  static void deleteJogo(String jogoId) {
    _jogos.removeWhere((j) => j['id'] == jogoId);
  }

  static List<Map<String, dynamic>> getPalpites() => _palpites;

  static Map<String, dynamic>? getPalpiteByUserAndJogo(String userId, String jogoId) {
    try {
      return _palpites.firstWhere(
        (p) => p['usuarioId'] == userId && p['jogoId'] == jogoId,
      );
    } catch (_) {
      return null;
    }
  }

  static void savePalpite(Map<String, dynamic> palpite) {
    final index = _palpites.indexWhere(
      (p) => p['usuarioId'] == palpite['usuarioId'] && p['jogoId'] == palpite['jogoId'],
    );
    
    if (index != -1) {
      _palpites[index] = palpite;
    } else {
      _palpites.add(palpite);
    }
  }

  static List<Map<String, dynamic>> getRanking({bool forceRefresh = false}) {
    final users = AuthService.getAllUsers();
    users.sort((a, b) => (b['pontos'] as int).compareTo(a['pontos'] as int));
    
    final ranking = <Map<String, dynamic>>[];
    for (int i = 0; i < users.length; i++) {
      ranking.add({
        'posicao': i + 1,
        'nome': users[i]['nome'],
        'pontos': users[i]['pontos'],
        'userId': users[i]['id'],
      });
    }
    
    _rankingCacheTime = DateTime.now();
    return ranking;
  }

  static DateTime? getRankingCacheTime() => _rankingCacheTime;

  static void addLog(String action, String details, String adminId) {
    _logs.insert(0, {
      'id': '${_logs.length + 1}',
      'action': action,
      'details': details,
      'adminId': adminId,
      'timestamp': DateTime.now().toIso8601String(),
    });
    
    if (_logs.length > 100) {
      _logs.removeRange(100, _logs.length);
    }
  }

  static List<Map<String, dynamic>> getLogs() => _logs;
}
