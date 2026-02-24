import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/data_service.dart';
import '../utils/date_utils.dart' as date_utils;

class PalpitesTab extends StatefulWidget {
  final Map<String, dynamic> user;

  const PalpitesTab({super.key, required this.user});

  @override
  State<PalpitesTab> createState() => _PalpitesTabState();
}

class _PalpitesTabState extends State<PalpitesTab> {
  List<Map<String, dynamic>> _jogos = [];
  Map<String, Map<String, dynamic>> _palpites = {};
  String _filtroFase = 'Todos';
  int _clickCount = 0;
  bool _showProcessingBug = false;
  DateTime? _lastClickTime;
  bool _waitingSecondClick = false;
  String? _pendingSaveJogoId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final jogos = DataService.getJogos();
    final palpites = DataService.getPalpites();
    
    final userPalpites = <String, Map<String, dynamic>>{};
    for (var p in palpites) {
      if (p['usuarioId'] == widget.user['id']) {
        userPalpites[p['jogoId']] = p;
      }
    }
    
    setState(() {
      _jogos = jogos;
      _palpites = userPalpites;
    });
  }

  List<Map<String, dynamic>> get _jogosFiltrados {
    if (_filtroFase == 'Todos') return _jogos;
    return _jogos.where((j) => j['fase'] == _filtroFase).toList();
  }

  List<String> get _fases {
    final fases = _jogos.map((j) => j['fase'] as String).toSet().toList();
    return ['Todos', ...fases];
  }

  bool _jogoLiberado(String jogoId) {
    if (widget.user['todosJogosLiberados'] == true) return true;
    final liberados = widget.user['jogosLiberados'] as List? ?? [];
    return liberados.contains(jogoId);
  }

  bool _jogoBloqueado(Map<String, dynamic> jogo) {
    final dataHora = DateTime.parse(jogo['dataHora']);
    return DateTime.now().isAfter(dataHora.subtract(const Duration(hours: 1)));
  }

  void _handleSaveClick(String jogoId, int gols1, int gols2) {
    final now = DateTime.now();
    
    if (_lastClickTime != null && now.difference(_lastClickTime!).inMilliseconds < 500) {
      _clickCount++;
      if (_clickCount >= 10) {
        setState(() => _showProcessingBug = true);
        return;
      }
    } else {
      _clickCount = 1;
    }
    _lastClickTime = now;
    
    if (_waitingSecondClick && _pendingSaveJogoId == jogoId) {
      _savePalpite(jogoId, gols1, gols2);
      _waitingSecondClick = false;
      _pendingSaveJogoId = null;
    } else {
      _waitingSecondClick = true;
      _pendingSaveJogoId = jogoId;
      
      Future.delayed(const Duration(milliseconds: 500), () {
        if (_pendingSaveJogoId == jogoId) {
          _waitingSecondClick = false;
          _pendingSaveJogoId = null;
        }
      });
    }
  }

  void _savePalpite(String jogoId, int gols1, int gols2) {
    final palpite = {
      'id': _palpites[jogoId]?['id'] ?? '${DateTime.now().millisecondsSinceEpoch}',
      'usuarioId': widget.user['id'],
      'jogoId': jogoId,
      'golsTime1': gols1,
      'golsTime2': gols2,
      'dataCriacao': DateTime.now().toIso8601String(),
    };
    
    DataService.savePalpite(palpite);
    
    setState(() {
      _palpites[jogoId] = palpite;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Palpite salvo com sucesso!'), backgroundColor: Colors.green, duration: Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                children: [
                  const Text('Filtrar por fase: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButton<String>(
                      value: _filtroFase,
                      isExpanded: true,
                      items: _fases.map((fase) => DropdownMenuItem(value: fase, child: Text(fase))).toList(),
                      onChanged: (value) {
                        if (value != null) setState(() => _filtroFase = value);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _jogosFiltrados.length,
                itemBuilder: (context, index) => _buildJogoCard(_jogosFiltrados[index]),
              ),
            ),
          ],
        ),
        if (_showProcessingBug)
          Container(
            color: Colors.black54,
            child: const Center(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Aguarde processando...', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildJogoCard(Map<String, dynamic> jogo) {
    final dataHora = DateTime.parse(jogo['dataHora']);
    final bloqueado = _jogoBloqueado(jogo);
    final liberado = _jogoLiberado(jogo['id']);
    final palpite = _palpites[jogo['id']];
    final finalizado = jogo['finalizado'] == true;
    
    final gols1Controller = TextEditingController(text: palpite?['golsTime1']?.toString() ?? '');
    final gols2Controller = TextEditingController(text: palpite?['golsTime2']?.toString() ?? '');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: jogo['dobroPontos'] == true || jogo['jogoDoBrasil'] == true ? Colors.amber.shade100 : Colors.grey.shade100,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(jogo['fase'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    if (jogo['grupo']?.isNotEmpty == true) ...[
                      const Text(' - ', style: TextStyle(fontSize: 12)),
                      Text(jogo['grupo'], style: const TextStyle(fontSize: 12)),
                    ],
                  ],
                ),
                Row(
                  children: [
                    if (jogo['dobroPontos'] == true || jogo['jogoDoBrasil'] == true)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(4)),
                        child: const Text('2X PONTOS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    Text(date_utils.formatDate(dataHora), style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(jogo['bandeira1']?.isNotEmpty == true ? jogo['bandeira1'] : 'X', style: const TextStyle(fontSize: 24)),
                          const SizedBox(height: 4),
                          Text(jogo['time1'], style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                    if (!finalizado && liberado && !bloqueado)
                      Row(
                        children: [
                          SizedBox(
                            width: 50,
                            child: TextField(
                              controller: gols1Controller,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)],
                              decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(vertical: 8)),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text('X', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            width: 50,
                            child: TextField(
                              controller: gols2Controller,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)],
                              decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(vertical: 8)),
                            ),
                          ),
                        ],
                      )
                    else if (palpite != null)
                      Text('${palpite['golsTime1']} X ${palpite['golsTime2']}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFCC0000)))
                    else
                      const Text('- X -', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey)),
                    Expanded(
                      child: Column(
                        children: [
                          Text(jogo['bandeira2']?.isNotEmpty == true ? jogo['bandeira2'] : 'X', style: const TextStyle(fontSize: 24)),
                          const SizedBox(height: 4),
                          Text(jogo['time2'], style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (!liberado)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.orange.shade200)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock, color: Colors.orange.shade700, size: 18),
                        const SizedBox(width: 8),
                        Text('Jogo nao liberado - Pague R\$ 5,00', style: TextStyle(color: Colors.orange.shade700, fontSize: 12)),
                      ],
                    ),
                  )
                else if (bloqueado && !finalizado)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.red.shade200)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.timer_off, color: Colors.red.shade700, size: 18),
                        const SizedBox(width: 8),
                        Text('Palpites bloqueados', style: TextStyle(color: Colors.red.shade700, fontSize: 12)),
                      ],
                    ),
                  )
                else if (!finalizado)
                  ElevatedButton.icon(
                    onPressed: () {
                      final gols1 = int.tryParse(gols1Controller.text) ?? 0;
                      final gols2 = int.tryParse(gols2Controller.text) ?? 0;
                      _handleSaveClick(jogo['id'], gols1, gols2);
                    },
                    icon: const Icon(Icons.save, size: 18),
                    label: const Text('SALVAR PALPITE'),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFCC0000), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
