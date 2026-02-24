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
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFFCC0000), Color(0xFF990000)]),
          ),
          child: Column(
            children: [
              const Text('SUA POSICAO', style: TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 2)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                    child: Text(_userPosition > 0 ? '${_userPosition}o' : '-', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFCC0000))),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.user['nome'] ?? 'Usuario', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('$_userPontos pontos', style: const TextStyle(color: Colors.white70, fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          color: Colors.amber.shade50,
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.amber.shade700, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'O ranking atualiza a cada 5 minutos. Ultima: ${_lastUpdate != null ? "${_lastUpdate!.hour.toString().padLeft(2, '0')}:${_lastUpdate!.minute.toString().padLeft(2, '0')}" : "-"}',
                  style: TextStyle(color: Colors.amber.shade800, fontSize: 12),
                ),
              ),
              TextButton(onPressed: () => _loadRanking(force: true), child: const Text('Atualizar')),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: const Text('RANKING DOS MELHORES COLOCADOS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _ranking.length > 20 ? 20 : _ranking.length,
            itemBuilder: (context, index) {
              final item = _ranking[index];
              final isCurrentUser = item['userId'] == widget.user['id'];
              
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isCurrentUser ? const Color(0xFFCC0000).withAlpha(25) : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: isCurrentUser ? const Color(0xFFCC0000) : Colors.grey.shade200, width: isCurrentUser ? 2 : 1),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(color: _getPosicaoColor(item['posicao']), shape: BoxShape.circle),
                      child: Center(child: Text('${item['posicao']}', style: TextStyle(color: item['posicao'] <= 3 ? Colors.white : Colors.black87, fontWeight: FontWeight.bold))),
                    ),
                    const SizedBox(width: 16),
                    Expanded(child: Text(item['nome'], style: TextStyle(fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal, fontSize: 16))),
                    if (item['posicao'] == 1) const Text('1o', style: TextStyle(fontSize: 24, color: Colors.amber))
                    else if (item['posicao'] == 2) const Text('2o', style: TextStyle(fontSize: 24, color: Colors.grey))
                    else if (item['posicao'] == 3) const Text('3o', style: TextStyle(fontSize: 24, color: Colors.brown)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Color _getPosicaoColor(int posicao) {
    switch (posicao) {
      case 1: return Colors.amber;
      case 2: return Colors.grey.shade400;
      case 3: return Colors.brown.shade300;
      default: return Colors.grey.shade200;
    }
  }
}
