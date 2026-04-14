import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/api_service.dart';
import '../services/user_session.dart';
import '../utils/date_utils.dart';

class AdminScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  final VoidCallback onLogout;
  final String adminId;

  const AdminScreen({
    super.key,
    required this.user,
    required this.onLogout,
    required this.adminId,
  });

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List<Map<String, dynamic>> _jogos = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadJogos();
  }

  Future<void> _loadJogos() async {
    setState(() => _loading = true);
    final jogos = await ApiService.getJogos();
    setState(() {
      _jogos = jogos;
      _loading = false;
    });
  }

  void _adicionarJogo() {
    final idjogoController = TextEditingController();
    final datjogController = TextEditingController();
    final timeaaController = TextEditingController();
    final siglaaController = TextEditingController();
    final timebbController = TextEditingController();
    final siglbbController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Adicionar Novo Jogo'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: idjogoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'ID do Jogo',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: datjogController,
                decoration: const InputDecoration(
                  labelText: 'Data/Hora (DD/MM/AAAA HH:MM)',
                  hintText: '31/12/2026 20:30',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: timeaaController,
                      decoration: const InputDecoration(
                        labelText: 'Time A',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: siglaaController,
                      maxLength: 3,
                      textCapitalization: TextCapitalization.characters,
                      decoration: const InputDecoration(
                        labelText: 'Sigla',
                        counterText: '',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: timebbController,
                      decoration: const InputDecoration(
                        labelText: 'Time B',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: siglbbController,
                      maxLength: 3,
                      textCapitalization: TextCapitalization.characters,
                      decoration: const InputDecoration(
                        labelText: 'Sigla',
                        counterText: '',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFCC0000)),
            onPressed: () async {
              final idjogo = idjogoController.text.trim();
              final datjog = datjogController.text.trim();
              final timeaa = timeaaController.text.trim();
              final siglaa = siglaaController.text.trim();
              final timebb = timebbController.text.trim();
              final siglbb = siglbbController.text.trim();

              if (idjogo.isEmpty || datjog.isEmpty || timeaa.isEmpty || siglaa.isEmpty || timebb.isEmpty || siglbb.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Preencha todos os campos para adicionar o jogo')),
                );
                return;
              }

              final success = await ApiService.salvarJogoAdmin(
                idjogo: idjogo,
                datjog: datjog,
                timeaa: timeaa,
                siglaa: siglaa,
                timebb: timebb,
                siglbb: siglbb,
                plcraa: '',
                plcrbb: '',
              );

              if (!mounted) return;
              if (success) {
                Navigator.pop(context);
                await _loadJogos();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Jogo salvo com sucesso')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Erro ao salvar o jogo')),
                );
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _editarResultado(Map<String, dynamic> jogo) {
    final plcraaController = TextEditingController(
      text: jogo['plcraa']?.toString() ?? '',
    );
    final plcrbbController = TextEditingController(
      text: jogo['plcrbb']?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('${jogo['timeaa'] ?? jogo['time1']} x ${jogo['timebb'] ?? jogo['time2']}'),
        content: Row(
          children: [
            Expanded(
              child: TextField(
                controller: plcraaController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  labelText: jogo['siglaa'] ?? jogo['sigla1'] ?? 'Time A',
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('X', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: TextField(
                controller: plcrbbController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  labelText: jogo['siglbb'] ?? jogo['sigla2'] ?? 'Time B',
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFCC0000)),
            onPressed: () async {
              final gol1 = int.tryParse(plcraaController.text);
              final gol2 = int.tryParse(plcrbbController.text);
              final idjogo = jogo['idjogo']?.toString() ?? jogo['id']?.toString() ?? '';
              final datjog = jogo['datjog']?.toString() ?? jogo['dataHora']?.toString() ?? '';
              final timeaa = jogo['timeaa']?.toString() ?? jogo['time1']?.toString() ?? '';
              final siglaa = jogo['siglaa']?.toString() ?? jogo['sigla1']?.toString() ?? '';
              final timebb = jogo['timebb']?.toString() ?? jogo['time2']?.toString() ?? '';
              final siglbb = jogo['siglbb']?.toString() ?? jogo['sigla2']?.toString() ?? '';

              if (gol1 != null && gol2 != null && idjogo.isNotEmpty && datjog.isNotEmpty && timeaa.isNotEmpty && siglaa.isNotEmpty && timebb.isNotEmpty && siglbb.isNotEmpty) {
                final success = await ApiService.salvarJogoAdmin(
                  idjogo: idjogo,
                  datjog: datjog,
                  timeaa: timeaa,
                  siglaa: siglaa,
                  timebb: timebb,
                  siglbb: siglbb,
                  plcraa: gol1.toString(),
                  plcrbb: gol2.toString(),
                );

                if (!mounted) return;
                if (success) {
                  Navigator.pop(context);
                  await _loadJogos();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Resultado salvo com sucesso')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Erro ao salvar resultado'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Preencha um placar válido'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header fixo vermelho
          Container(
            color: const Color(0xFFCC0000),
            padding: const EdgeInsets.all(16),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "ADMIN",
                      style: TextStyle(
                        color: Color(0xFFCC0000),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Olá, ${widget.user['nome'] ?? 'Admin'}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () {
                      UserSession.clear();
                      widget.onLogout();
                    },
                    icon: const Icon(Icons.logout, size: 18),
                    label: const Text('Sair'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFFCC0000),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Título e botão adicionar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.sports_soccer, color: Color(0xFFCC0000)),
                const SizedBox(width: 12),
                const Text(
                  'Gerenciar Jogos',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: _adicionarJogo,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Adicionar Jogo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCC0000),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Lista de jogos
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFFCC0000)),
                  )
                : _jogos.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.sports_soccer, size: 60, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhum jogo cadastrado',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadJogos,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _jogos.length,
                      itemBuilder: (context, index) {
                        final jogo = _jogos[index];
                        final dataHoraString = jogo['datjog'] ?? jogo['dataHora'] ?? '';
                        final dataHora = DateTime.tryParse(dataHoraString) ?? DateTime.now();
                        final finalizado = jogo['plcraa'] != null && jogo['plcrbb'] != null;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Text('${jogo['timeaa'] ?? jogo['time1']} x ${jogo['timebb'] ?? jogo['time2']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('${jogo['fase'] ?? ''} - ${formatDate(dataHora)}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: finalizado ? Colors.green : Colors.grey,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    finalizado ? '${jogo['plcraa']} x ${jogo['plcrbb']}' : 'Pendente',
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Color(0xFFCC0000)),
                                  onPressed: () => _editarResultado(jogo),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
