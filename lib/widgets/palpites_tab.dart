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

class _PalpitesTabState extends State<PalpitesTab> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> _jogos = [];
  Map<String, Map<String, dynamic>> _palpites = {};
  String _filtroFase = 'Todos';

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

  Widget _getBandeira(String codigo) {
    if (codigo.isEmpty) {
      return Container(
        width: 50,
        height: 35,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Icon(Icons.flag, color: Colors.grey, size: 20),
      );
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.network(
          'https://flagcdn.com/w80/${codigo.toLowerCase()}.png',
          width: 50,
          height: 35,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            width: 50,
            height: 35,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.flag, color: Colors.grey, size: 20),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            // Filtro com design 3D
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFCC0000), Color(0xFF990000)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.filter_list, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Text('Filtrar:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _filtroFase,
                          isExpanded: true,
                          items: _fases.map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
                          onChanged: (v) => setState(() => _filtroFase = v!),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Lista de jogos
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _jogosFiltrados.length,
                itemBuilder: (ctx, i) => _buildJogoCard(_jogosFiltrados[i]),
              ),
            ),
          ],
        ),

        // Bug do processing
        Container(
          color: Colors.black54,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Color(0xFFCC0000)),
                  SizedBox(height: 20),
                  Text('Processando...', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
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
    final liberado = _jogoLiberado(jogo['id']);
    final bloqueado = _jogoBloqueado(jogo);

    final gol1Controller = TextEditingController(text: palpite?['golsTime1']?.toString() ?? '');
    final gol2Controller = TextEditingController(text: palpite?['golsTime2']?.toString() ?? '');

    final ehJogoDobro = jogo['dobroPontos'] == true || jogo['jogoDoBrasil'] == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: ehJogoDobro ? Colors.amber.shade200 : Colors.grey.shade200,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header do card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: ehJogoDobro ? [Colors.amber.shade100, Colors.amber.shade200] : [Colors.grey.shade100, Colors.grey.shade200],
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.sports_soccer,
                      size: 16,
                      color: ehJogoDobro ? Colors.amber.shade700 : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      jogo['fase'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: ehJogoDobro ? Colors.amber.shade800 : Colors.grey.shade700,
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
                    if (ehJogoDobro)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFD700), Color(0xFFFFAA00)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.amber.shade300,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.star, size: 12, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              '2X',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.schedule, size: 12, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            date_utils.formatDate(dataHora),
                            style: const TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Conteudo do card
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Times e placar
                Row(
                  children: [
                    // Time 1
                    Expanded(
                      child: Column(
                        children: [
                          _getBandeira(jogo['bandeira1']),
                          const SizedBox(height: 8),
                          Text(
                            jogo['time1'],
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    // Placar / Input
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: !finalized && liberado && !bloqueado
                          ? Row(
                              children: [
                                _buildScoreInput(gol1Controller),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    'X',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                _buildScoreInput(gol2Controller),
                              ],
                            )
                          : palpite != null
                          ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFCC0000), Color(0xFF990000)],
                                ),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.red.shade200,
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Text(
                                '${palpite['golsTime1']} X ${palpite['golsTime2']}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Text(
                                '- X -',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                    ),

                    // Time 2
                    Expanded(
                      child: Column(
                        children: [
                          _getBandeira(jogo['bandeira2']),
                          const SizedBox(height: 8),
                          Text(
                            jogo['time2'],
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Status / Botao
                if (!liberado)
                  _buildStatusContainer(
                    icon: Icons.lock,
                    text: 'Nao liberado - R\$ 5,00',
                    color: Colors.orange,
                  )
                else if (bloqueado && !finalized)
                  _buildStatusContainer(
                    icon: Icons.timer_off,
                    text: 'Palpites bloqueados',
                    color: Colors.red,
                  )
                else if (!finalized)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final palpiteData = {
                          'id': _palpites[jogo['id']]?['id'] ?? '${DateTime.now().millisecondsSinceEpoch}',
                          'usuarioId': widget.user['id'],
                          'jogoId': jogo['id'],
                          'golsTime1': int.tryParse(gol1Controller.text) ?? 0,
                          'golsTime2': int.tryParse(gol2Controller.text) ?? 0,
                          'dataCriacao': DateTime.now().toIso8601String(),
                        };

                        DataService.savePalpite(palpiteData);
                        setState(() => _palpites[jogo['id']] = palpiteData);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.white),
                                SizedBox(width: 10),
                                Text('Palpite salvo!'),
                              ],
                            ),
                            backgroundColor: Colors.green.shade600,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFCC0000),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 8,
                        shadowColor: Colors.red.shade300,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.save, size: 20),
                          SizedBox(width: 10),
                          Text(
                            'SALVAR PALPITE',
                            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
                          ),
                        ],
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

  Widget _buildScoreInput(TextEditingController controller) {
    return Container(
      width: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(2),
        ],
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFFCC0000),
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFCC0000), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildStatusContainer({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
