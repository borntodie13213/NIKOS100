import 'package:flutter/material.dart';
import '../services/data_service.dart';

class RankingTab extends StatefulWidget {
  final Map<String, dynamic> user;

  const RankingTab({super.key, required this.user});

  @override
  State<RankingTab> createState() => _RankingTabState();
}

class _RankingTabState extends State<RankingTab> {
  List<Map<String, dynamic>> _ranking = [];
  DateTime? _lastUpdate;
  int _userPosition = 0;
  int _userPontos = 0;

  @override
  void initState() {
    super.initState();
    _loadRanking();
  }

  void _loadRanking({bool force = false}) {
    final ranking = DataService.getRanking(forceRefresh: force);

    int pos = 0;
    int pontos = 0;
    for (var item in ranking) {
      if (item['userId'] == widget.user['id']) {
        pos = item['posicao'];
        pontos = item['pontos'];
        break;
      }
    }

    setState(() {
      _ranking = ranking;
      _userPosition = pos;
      _userPontos = pontos;
      _lastUpdate = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // CABECALHO - Mostra a posicao do usuario com gradiente vermelho
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFCC0000), Color(0xFF990000)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.red.shade200,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                'SUA POSICAO',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Numero da posicao (destaque branco)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      _userPosition > 0 ? '${_userPosition}o' : '-',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFCC0000),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.user['nome'] ?? 'Usuario',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$_userPontos pontos',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        // BARRA DE ATUALIZACAO - Aviso que atualiza a cada 5 minutos
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            border: Border(
              bottom: BorderSide(color: Colors.amber.shade200),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.amber.shade700, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'O ranking atualiza a cada 5 minutos. Ultima: ${_lastUpdate != null ? "${_lastUpdate!.hour.toString().padLeft(2, '0')}:${_lastUpdate!.minute.toString().padLeft(2, '0')}" : "-"}',
                  style: TextStyle(
                    color: Colors.amber.shade800,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => _loadRanking(force: true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Atualizar'),
              ),
            ],
          ),
        ),

        // TITULO DO RANKING
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Row(
            children: const [
              Text(
                'RANKING DOS MELHORES COLOCADOS',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),

        // LISTA DO RANKING - Top 20
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _ranking.length > 20 ? 20 : _ranking.length,
            itemBuilder: (context, index) {
              final item = _ranking[index];
              final isCurrentUser = item['userId'] == widget.user['id'];

              return _buildRankingItem(item, isCurrentUser);
            },
          ),
        ),
      ],
    );
  }

  // GAMBIARRA: Metodo que constroi cada item da lista
  // Feito de madrugada mas funciona que uma beleza
  Widget _buildRankingItem(Map<String, dynamic> item, bool isCurrentUser) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCurrentUser ? const Color(0xFFCC0000).withAlpha(30) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrentUser ? const Color(0xFFCC0000) : Colors.grey.shade200,
          width: isCurrentUser ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Numero da posicao com cor diferente para top 3
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _getPosicaoColor(item['posicao']),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '${item['posicao']}',
                style: TextStyle(
                  color: item['posicao'] <= 3 ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Nome do usuario
          Expanded(
            child: Text(
              item['nome'],
              style: TextStyle(
                fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.w500,
                fontSize: 16,
                color: isCurrentUser ? const Color(0xFFCC0000) : Colors.black87,
              ),
            ),
          ),

          // Medalha para top 3
          _buildMedalha(item['posicao']),
        ],
      ),
    );
  }

  // GAMBIARRA: Metodo que constroi a medalinha do top 3
  Widget _buildMedalha(int posicao) {
    if (posicao == 1) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.amber,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.amber.shade200,
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Icon(
          Icons.emoji_events,
          color: Colors.white,
          size: 24,
        ),
      );
    } else if (posicao == 2) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade400,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Icon(
          Icons.emoji_events,
          color: Colors.white,
          size: 24,
        ),
      );
    } else if (posicao == 3) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.brown.shade400,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.brown.shade200,
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Icon(
          Icons.emoji_events,
          color: Colors.white,
          size: 24,
        ),
      );
    }

    return const SizedBox.shrink();
  }

  // CORES DAS POSICOES - Top 3 tem cores especiais
  Color _getPosicaoColor(int posicao) {
    switch (posicao) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey.shade400;
      case 3:
        return Colors.brown.shade400;
      default:
        return Colors.grey.shade200;
    }
  }
}
