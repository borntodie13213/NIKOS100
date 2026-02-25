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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            // BARRA DE FILTRO - Selecionar fase do jogo
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
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
                  const Text(
                    'Filtrar por fase: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: _filtroFase,
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: _fases
                            .map(
                              (fase) => DropdownMenuItem(
                                value: fase,
                                child: Text(fase),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _filtroFase = value);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Divisinha entre filtro e lista
            Container(height: 1, color: Colors.grey.shade200),

            // LISTA DE JOGOS
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _jogosFiltrados.length,
                itemBuilder: (context, index) => _buildJogoCard(_jogosFiltrados[index]),
              ),
            ),
          ],
        ),

        // TELA DE CARREGAMENTO - Aparece quando usuario clica muitas vezes
        if (showProcessingBug)
          Container(
            color: Colors.black54,
            child: Center(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      const Text(
                        'Aguarde processando...',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  // GAMBIARRA: Metodo que constroi o card de cada jogo
  Widget _buildJogoCard(Map<String, dynamic> jogo) {
    final dataHora = DateTime.parse(jogo['dataHora']);
    final palpite = _palpites[jogo['id']];
    final finalizado = jogo['finalizado'] == true;

    final gole1Controller = TextEditingController(
      text: palpite?['golsTime1']?.toString() ?? '',
    );
    final gole2Controller = TextEditingController(
      text: palpite?['golsTime2']?.toString() ?? '',
    );

    // Verifica se e jogo do Brasil ou final (pontos em dobro)
    final ehJogoDobro = jogo['dobroPontos'] == true || jogo['jogoDoBrasil'] == true;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          // CABECALHO DO CARD - Fase, grupo e data
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: ehJogoDobro ? Colors.amber.shade100 : Colors.grey.shade100,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      jogo['fase'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    if (jogo['grupo']?.isNotEmpty == true) ...[
                      const Text(' - ', style: TextStyle(fontSize: 12)),
                      Text(jogo['grupo'], style: const TextStyle(fontSize: 12)),
                    ],
                  ],
                ),
                Row(
                  children: [
                    // Badge de pontos em dobro
                    if (ehJogoDobro)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.amber.shade200,
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: const Text(
                          '2X PONTOS',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    Text(
                      date_utils.formatDate(dataHora),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // CORPO DO CARD - Times e campos de palpite
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // times e placar
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Time 1 (esquerda)
                    Expanded(
                      child: Column(
                        children: [
                          // Bandeira ou icone do time
                          Container(
                            width: 50,
                            height: 35,
                            alignment: Alignment.center,
                            child: Text(
                              jogo['bandeira1']?.isNotEmpty == true ? jogo['bandeira1'] : '?',
                              style: const TextStyle(fontSize: 28),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            jogo['time1'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),

                    // CAMPO DE PALPITE ou PLACAR
                    if (!finalizado && _jogoLiberado(jogo['id']) && !_jogoBloqueado(jogo))
                      Row(
                        children: [
                          // Gols time 1
                          SizedBox(
                            width: 50,
                            child: TextField(
                              controller: gole1Controller,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(2),
                              ],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                hintText: '-',
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              'X',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          // Gols time 2
                          SizedBox(
                            width: 50,
                            child: TextField(
                              controller: gole2Controller,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(2),
                              ],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                hintText: '-',
                              ),
                            ),
                          ),
                        ],
                      )
                    else if (palpite != null)
                      // Ja tem palpite salvo - mostra o placar
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${palpite['golsTime1']} X ${palpite['golsTime2']}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFCC0000),
                          ),
                        ),
                      )
                    else
                      // Ainda nao fez palpite
                      const Text(
                        '- X -',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),

                    // Time 2 (direita)
                    Expanded(
                      child: Column(
                        children: [
                          // Bandeira ou icone do time
                          Container(
                            width: 50,
                            height: 35,
                            alignment: Alignment.center,
                            child: Text(
                              jogo['bandeira2']?.isNotEmpty == true ? jogo['bandeira2'] : '?',
                              style: const TextStyle(fontSize: 28),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            jogo['time2'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // MENSAGEM DE STATUS ou BOTAO DE SALVAR
                if (!_jogoLiberado(jogo['id']))
                  // Jogo nao liberado - precisa pagar
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lock,
                          color: Colors.orange.shade700,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Jogo nao liberado - Pague R\$ 5,00',
                          style: TextStyle(
                            color: Colors.orange.shade700,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                else if (_jogoBloqueado(jogo) && !finalizado)
                  // Jogo ja comecou - palpites bloqueados
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.timer_off,
                          color: Colors.red.shade700,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Palpites bloqueados',
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                else if (!finalizado)
                  // Jogo liberado - pode fazer palpite
                  ElevatedButton.icon(
                    onPressed: () {
                      final palpite = {
                        'id': _palpites[jogo['id']]?['id'] ?? '${DateTime.now().millisecondsSinceEpoch}',
                        'usuarioId': widget.user['id'],
                        'jogoId': jogo['id'],
                        'golsTime1': int.tryParse(gole1Controller.text) ?? 0,
                        'golsTime2': int.tryParse(gole2Controller.text) ?? 0,
                        'dataCriacao': DateTime.now().toIso8601String(),
                      };

                      DataService.savePalpite(palpite);

                      setState(() {
                        _palpites[jogo['id']] = palpite;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Palpite salvo com sucesso!'),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(Icons.save, size: 18),
                    label: const Text('SALVAR PALPITE'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCC0000),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
