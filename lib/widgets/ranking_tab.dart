import 'package:flutter/material.dart';
import '../services/data_service.dart';

class RankingTab extends StatefulWidget {
  final Map<String, dynamic> user;

  const RankingTab({super.key, required this.user});

  @override
  State<RankingTab> createState() => _RankingTabState();
}

class _RankingTabState extends State<RankingTab> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> _ranking = [];
  DateTime? _lastUpdate;
  int _userPosition = 0;
  int _userPontos = 0;

  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _loadRanking();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
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

    _animController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header 3D com posicao do usuario
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFCC0000), Color(0xFF8B0000), Color(0xFF660000)],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.red.shade300,
                blurRadius: 20,
                offset: const Offset(0, 8),
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
                  letterSpacing: 3,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Posicao com efeito 3D
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                        const BoxShadow(
                          color: Colors.white,
                          blurRadius: 0,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          _userPosition > 0 ? '${_userPosition}º' : '-',
                          style: const TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFCC0000),
                          ),
                        ),
                        Text(
                          'lugar',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.user['nome'] ?? 'Usuario',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.amber.shade300,
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.stars, color: Colors.white, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              '$_userPontos pts',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        // Info de atualizacao
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.amber.shade50, Colors.amber.shade100],
            ),
            border: Border(
              bottom: BorderSide(color: Colors.amber.shade200),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.info_outline, color: Colors.amber.shade800, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Atualiza a cada 5 min. Ultima: ${_lastUpdate != null ? "${_lastUpdate!.hour.toString().padLeft(2, '0')}:${_lastUpdate!.minute.toString().padLeft(2, '0')}" : "-"}',
                  style: TextStyle(
                    color: Colors.amber.shade800,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _loadRanking(force: true),
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Atualizar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber.shade600,
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shadowColor: Colors.amber.shade300,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Titulo
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFCC0000), Color(0xFF990000)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.leaderboard, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              const Text(
                'TOP 5 COLOCADOS',
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

        // Lista do ranking
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _ranking.length > 5 ? 5 : _ranking.length,
            itemBuilder: (context, index) {
              final item = _ranking[index];
              final isCurrentUser = item['userId'] == widget.user['id'];

              return AnimatedBuilder(
                animation: _animController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                      0,
                      (1 - _animController.value) * 20 * (index + 1).clamp(0, 5),
                    ),
                    child: Opacity(
                      opacity: _animController.value,
                      child: child,
                    ),
                  );
                },
                child: _buildRankingItem(item, isCurrentUser),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRankingItem(Map<String, dynamic> item, bool isCurrentUser) {
    final posicao = item['posicao'] as int;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: isCurrentUser
            ? const LinearGradient(
                colors: [Color(0xFFCC0000), Color(0xFF990000)],
              )
            : null,
        color: isCurrentUser ? null : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isCurrentUser ? Colors.red.shade300 : Colors.grey.shade200,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Posicao
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _getPosicaoGradient(posicao, isCurrentUser),
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: _getPosicaoColor(posicao).withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '$posicao',
                  style: TextStyle(
                    color: posicao <= 3 || isCurrentUser ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Nome
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['nome'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isCurrentUser ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item['pontos']} pts',
                    style: TextStyle(
                      fontSize: 13,
                      color: isCurrentUser ? Colors.white70 : Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            // Medalha para top 3
            _buildMedalha(posicao, isCurrentUser),
          ],
        ),
      ),
    );
  }

  Widget _buildMedalha(int posicao, bool isCurrentUser) {
    if (posicao > 3) return const SizedBox.shrink();

    final colors = {
      1: [Colors.amber, Colors.amber.shade700],
      2: [Colors.grey.shade400, Colors.grey.shade600],
      3: [Colors.brown.shade400, Colors.brown.shade600],
    };

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors[posicao]!,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: colors[posicao]![0].withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Icon(
        Icons.emoji_events,
        color: Colors.white,
        size: 22,
      ),
    );
  }

  List<Color> _getPosicaoGradient(int posicao, bool isCurrentUser) {
    if (isCurrentUser) {
      return [Colors.white.withOpacity(0.3), Colors.white.withOpacity(0.1)];
    }
    switch (posicao) {
      case 1:
        return [Colors.amber.shade300, Colors.orange.shade700];
      case 2:
        return [Colors.grey.shade400, Colors.grey.shade600];
      case 3:
        return [Colors.brown.shade400, Colors.brown.shade600];
      default:
        return [Colors.grey.shade200, Colors.grey.shade300];
    }
  }

  Color _getPosicaoColor(int posicao) {
    switch (posicao) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey;
      case 3:
        return Colors.brown;
      default:
        return Colors.grey.shade400;
    }
  }
}
