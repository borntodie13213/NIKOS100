import '../services/auth_service.dart';

// SERVICO PRINCIPAL DE DADOS - gerencia jogos, palpites, ranking e logs
class DataService {
  // Variaveis estaticas (ficam na memoria enquanto o app ta aberto)
  static final List<Map<String, dynamic>> _jogos = _gerarJogosDemonstracao();
  static final List<Map<String, dynamic>> _palpites = [];
  static final List<Map<String, dynamic>> _logs = [];
  static DateTime? _rankingCacheTime;

  // ============================================
  // GERADOR DE JOGOS DE DEMONSTRACAO
  // Cria os 104 jogos da Copa do Mundo 2026
  // (ou pelo menos os que a gente precisa pra testar)
  // ============================================
  static List<Map<String, dynamic>> _gerarJogosDemonstracao() {
    final jogos = <Map<String, dynamic>>[];
    int jogoId = 1;
    
    // Definicao dos grupos e times (8 grupos com 4 times cada)
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

    // Data base comecando amanha (pra dar tempo de fazer palpites)
    var dataBase = DateTime.now().add(const Duration(days: 1));
    int jogoNum = 0;

    // ============================================
    // FASE DE GRUPOS - 48 jogos (8 grupos x 6 jogos)
    // Cada time joga contra os outros 3 do grupo
    // ============================================
    grupos.forEach((grupo, times) {
      for (int i = 0; i < times.length; i++) {
        for (int j = i + 1; j < times.length; j++) {
          final time1 = times[i];
          final time2 = times[j];
          // Se um dos times for o Brasil, dobra os pontos
          final isBrasil = time1['time'] == 'Brasil' || time2['time'] == 'Brasil';
          
          jogos.add({
            'id': '${jogoId++}',
            'time1': time1['time'],
            'time2': time2['time'],
            'bandeira1': time1['bandeira'],
            'bandeira2': time2['bandeira'],
            // Cada jogo 4 horas depois do anterior
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

    // ============================================
    // OITAVAS DE FINAL - 8 jogos
    // nem sei quem vai ganhar, por isso fica generico
  
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

    // ============================================
    // QUARTAS DE FINAL - 4 jogos
    // ============================================
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

    // ============================================
    // SEMIFINAIS - 2 jogos
    // ============================================
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

    // ============================================
    // DISPUTA 3o LUGAR - 1 jogo
    // (o jogo que ninguem quer jogar kkk)
    // ============================================
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

    // ============================================
    // FINAL - 1 jogo
    // (o mais importante de todos)
    // ============================================
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
      'dobroPontos': true, // Final sempre dobra pontos
      'jogoDoBrasil': false,
    });

    return jogos;
  }

  // ============================================
  // METODOS DE JOGOS
  // ============================================

  // Pega todos os jogos (nao mexer, ta funcionando)
  static List<Map<String, dynamic>> getJogos() => _jogos;

  // Atualiza um jogo especifico (acha pelo id)
  static void updateJogo(Map<String, dynamic> jogo) {
    final index = _jogos.indexWhere((j) => j['id'] == jogo['id']);
    if (index != -1) {
      _jogos[index] = jogo;
    }
  }

  // Adiciona um jogo novo (nao sei se isso vai ser usado)
  static void addJogo(Map<String, dynamic> jogo) {
    _jogos.add(jogo);
  }

  // Deleta um jogo (cuidado, nao tem confirmacao)
  static void deleteJogo(String jogoId) {
    _jogos.removeWhere((j) => j['id'] == jogoId);
  }

  // ============================================
  // METODOS DE PALPITES
  // ============================================

  // Pega todos os palpites (ta na memoria, nao ta persistido)
  static List<Map<String, dynamic>> getPalpites() => _palpites;

  // Pega um palpite especifico de um usuario em um jogo
  static Map<String, dynamic>? getPalpiteByUserAndJogo(String userId, String jogoId) {
    try {
      return _palpites.firstWhere(
        (p) => p['usuarioId'] == userId && p['jogoId'] == jogoId,
      );
    } catch (_) {
      return null; // Se nao achou, devolve null
    }
  }

  // Salva ou atualiza um palpite
  // Se ja existe, atualiza. Se nao, cria um novo.
  static void savePalpite(Map<String, dynamic> palpite) {
    final index = _palpites.indexWhere(
      (p) => p['usuarioId'] == palpite['usuarioId'] && p['jogoId'] == palpite['jogoId'],
    );
    
    if (index != -1) {
      // Ja tem palpite, atualiza
      _palpites[index] = palpite;
    } else {
      // Nao tem, adiciona novo
      _palpites.add(palpite);
    }
  }

  // ============================================
  // METODOS DE RANKING
  // ============================================

  // Gera o ranking baseado nos pontos dos usuarios
  // Ordena do maior pro menor ponto
  static List<Map<String, dynamic>> getRanking({bool forceRefresh = false}) {
    // Pega todos os usuarios
    final users = AuthService.getAllUsers();
    // Ordena por pontos (maior primeiro)
    users.sort((a, b) => (b['pontos'] as int).compareTo(a['pontos'] as int));
    
    // Monta a lista do ranking
    final ranking = <Map<String, dynamic>>[];
    for (int i = 0; i < users.length; i++) {
      ranking.add({
        'posicao': i + 1,
        'nome': users[i]['nome'],
        'pontos': users[i]['pontos'],
        'userId': users[i]['id'],
      });
    }
    
    // Salva o horario do cache (pra saber quando atualizar)
    _rankingCacheTime = DateTime.now();
    return ranking;
  }

  // Pega o horario do ultimo cache (pode ser null)
  static DateTime? getRankingCacheTime() => _rankingCacheTime;

  // ============================================
  // METODOS DE LOGS
  // (pra saber o que o admin andou fazendo)
  // ============================================

  // Adiciona um log no sistema
  static void addLog(String action, String details, String adminId) {
    _logs.insert(0, {
      'id': '${_logs.length + 1}',
      'action': action,
      'details': details,
      'adminId': adminId,
      'timestamp': DateTime.now().toIso8601String(),
    });
    
    // Se passou de 100 logs, apaga os mais antigos
    if (_logs.length > 100) {
      _logs.removeRange(100, _logs.length);
    }
  }

  // Pega todos os logs (do mais recente pro mais antigo)
  static List<Map<String, dynamic>> getLogs() => _logs;
} 