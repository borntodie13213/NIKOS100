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
  bool showProcessingBug = false;

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

 // metodo pra pegar a bandeira
  Widget _getBandeira(String codigo) {
    if (codigo.isEmpty) return const Text('?', style: TextStyle(fontSize: 28));
    return Image.network(
      'https://flagcdn.com/w80/${codigo.toLowerCase()}.png',
      width: 50,
      height: 35,
      errorBuilder: (_, __, ___) => const Text('?', style: TextStyle(fontSize: 28)),
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
                  const Text('Filtrar: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButton<String>(
                      value: _filtroFase,
                      isExpanded: true,
                      items: _fases.map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
                      onChanged: (v) => setState(() => _filtroFase = v!),
                    ),
                  ),
                ],
              ),
            ),
            Container(height: 1, color: Colors.grey.shade200),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _jogosFiltrados.length,
                itemBuilder: (ctx, i) => _buildJogoCard(_jogosFiltrados[i]),
              ),
            ),
          ],
        ),
        if (showProcessingBug)
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
                      Text('Processando...'),
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
    final palpite = _palpites[jogo['id']];
    final finalized = jogo['finalizado'] == true;

    final gole1Controller = TextEditingController(text: palpite?['golsTime1']?.toString() ?? '');
    final gole2Controller = TextEditingController(text: palpite?['golsTime2']?.toString() ?? '');

    final ehJogoDobro = jogo['dobroPontos'] == true || jogo['jogoDoBrasil'] == true;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: ehJogoDobro ? Colors.amber.shade100 : Colors.grey.shade100,
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
                    if (ehJogoDobro)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(4)),
                        child: const Text('2X', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    Text(date_utils.formatDate(dataHora), style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                  ],
                ),
              ],
            ),
          ),
fiz algumas alterações no codigo que voce fez, mas enfim quero que voce bote uma animação 3D deixe um pouco mais 
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
                          SizedBox(width: 50, height: 35, child: _getBandeira(jogo['bandeira1'])),
                          const SizedBox(height: 4),
                          Text(jogo['time1'], style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                        ],
                      ),
                    ),

                    if (!finalized && _jogoLiberado(jogo['id']) && !_jogoBloqueado(jogo))
                      Row(
                        children: [
                          SizedBox(
                            width: 50,
                            child: TextField(
                              controller: gole1Controller,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)],
                              decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(vertical: 8)),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('X', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                          SizedBox(
                            width: 50,
                            child: TextField(
                              controller: gole2Controller,
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
                          SizedBox(width: 50, height: 35, child: _getBandeira(jogo['bandeira2'])),
                          const SizedBox(height: 4),
                          Text(jogo['time2'], style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                if (!_jogoLiberado(jogo['id']))
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.orange.shade200)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock, color: Colors.orange.shade700, size: 18),
                        const SizedBox(width: 8),
                        Text('Nao liberado - R\$ 5,00', style: TextStyle(color: Colors.orange.shade700, fontSize: 12)),
                      ],
                    ),
                  )
                else if (_jogoBloqueado(jogo) && !finalized)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.red.shade200)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.timer_off, color: Colors.red.shade700, size: 18),
                        const SizedBox(width: 8),
                        Text('Bloqueado', style: TextStyle(color: Colors.red.shade700, fontSize: 12)),
                      ],
                    ),
                  )
                else if (!finalized)
                  ElevatedButton.icon(
                    onPressed: () {
                      final palpiteData = {
                        'id': _palpites[jogo['id']]?['id'] ?? '${DateTime.now().millisecondsSinceEpoch}',
                        'usuarioId': widget.user['id'],
                        'jogoId': jogo['id'],
                        'golsTime1': int.tryParse(gole1Controller.text) ?? 0,
                        'golsTime2': int.tryParse(gole2Controller.text) ?? 0,
                        'dataCriacao': DateTime.now().toIso8601String(),
                      };

                      DataService.savePalpite(palpiteData);
                      setState(() => _palpites[jogo['id']] = palpiteData);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Salvo!'), backgroundColor: Colors.green),
                      );
                    },
                    icon: const Icon(Icons.save, size: 18),
                    label: const Text('SALVAR'),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFCC0000)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}