import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/data_service.dart';
import '../services/auth_service.dart';
import '../utils/date_utils.dart' as date_utils;

class AdminScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  final VoidCallback onLogout;

  const AdminScreen({super.key, required this.user, required this.onLogout});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _selectedTab = 0;
  final List<String> _tabs = ['Jogos', 'Usuarios', 'Pagamentos', 'Logs'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
              child: const Text("ADMIN", style: TextStyle(color: Color(0xFFCC0000), fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            const SizedBox(width: 8),
            const Text('Painel Administrativo', style: TextStyle(fontSize: 14)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: widget.onLogout, tooltip: 'Sair'),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Row(
              children: List.generate(_tabs.length, (index) {
                final isSelected = _selectedTab == index;
                return Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _selectedTab = index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: isSelected ? const Color(0xFFCC0000) : Colors.transparent, width: 3)),
                      ),
                      child: Text(
                        _tabs[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(color: isSelected ? const Color(0xFFCC0000) : Colors.grey.shade600, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: IndexedStack(
              index: _selectedTab,
              children: [
                _JogosTab(adminId: widget.user['id']),
                const _UsuariosTab(),
                const _PagamentosTab(),
                const _LogsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _JogosTab extends StatefulWidget {
  final String adminId;
  const _JogosTab({required this.adminId});

  @override
  State<_JogosTab> createState() => _JogosTabState();
}

class _JogosTabState extends State<_JogosTab> {
  List<Map<String, dynamic>> _jogos = [];
  String _filtroFase = 'Todos';

  @override
  void initState() {
    super.initState();
    _loadJogos();
  }

  void _loadJogos() {
    setState(() {
      _jogos = DataService.getJogos();
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

  void _editarResultado(Map<String, dynamic> jogo) {
    final gols1Controller = TextEditingController(text: jogo['golsTime1']?.toString() ?? '');
    final gols2Controller = TextEditingController(text: jogo['golsTime2']?.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${jogo['time1']} x ${jogo['time2']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: gols1Controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(labelText: jogo['time1'], border: const OutlineInputBorder()),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('X', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: TextField(
                    controller: gols2Controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(labelText: jogo['time2'], border: const OutlineInputBorder()),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              final gols1 = int.tryParse(gols1Controller.text);
              final gols2 = int.tryParse(gols2Controller.text);
              
              if (gols1 != null && gols2 != null) {
                final updatedJogo = {...jogo, 'golsTime1': gols1, 'golsTime2': gols2, 'finalizado': true};
                DataService.updateJogo(updatedJogo);
                DataService.addLog('RESULTADO', '${jogo['time1']} $gols1 x $gols2 ${jogo['time2']}', widget.adminId);
                _loadJogos();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Resultado salvo!'), backgroundColor: Colors.green),
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
    return Column(
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
                  items: _fases.map((fase) => DropdownMenuItem(value: fase, child: Text(fase))).toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _filtroFase = value);
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _jogosFiltrados.length,
            itemBuilder: (context, index) {
              final jogo = _jogosFiltrados[index];
              final dataHora = DateTime.parse(jogo['dataHora']);
              
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text('${jogo['time1']} x ${jogo['time2']}'),
                  subtitle: Text('${jogo['fase']} - ${date_utils.formatDate(dataHora)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (jogo['finalizado'] == true)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(4)),
                          child: Text('${jogo['golsTime1']} x ${jogo['golsTime2']}', style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold)),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(4)),
                          child: const Text('Pendente', style: TextStyle(color: Colors.grey)),
                        ),
                      IconButton(icon: const Icon(Icons.edit), onPressed: () => _editarResultado(jogo)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _UsuariosTab extends StatelessWidget {
  const _UsuariosTab();

  @override
  Widget build(BuildContext context) {
    final users = AuthService.getAllUsers();
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFFCC0000),
              child: Text(user['nome'][0], style: const TextStyle(color: Colors.white)),
            ),
            title: Text(user['nome']),
            subtitle: Text('CPF: ${user['cpf']} | Pontos: ${user['pontos']}'),
            trailing: user['todosJogosLiberados'] == true
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(4)),
                    child: Text('COMPLETO', style: TextStyle(color: Colors.green.shade700, fontSize: 10)),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(4)),
                    child: Text('PARCIAL', style: TextStyle(color: Colors.orange.shade700, fontSize: 10)),
                  ),
          ),
        );
      },
    );
  }
}

class _PagamentosTab extends StatelessWidget {
  const _PagamentosTab();

  @override
  Widget build(BuildContext context) {
    final pagamentos = [
      {'usuario': 'Bernardo Zilli', 'valor': 520.00, 'tipo': 'Todos os jogos', 'data': '15/01/2026', 'status': 'Confirmado'},
      {'usuario': 'Luis Antonio', 'valor': 520.00, 'tipo': 'Todos os jogos', 'data': '16/01/2026', 'status': 'Confirmado'},
      {'usuario': 'Ramon Zilli', 'valor': 520.00, 'tipo': 'Todos os jogos', 'data': '17/01/2026', 'status': 'Confirmado'},
      {'usuario': 'Carlos Silva', 'valor': 25.00, 'tipo': '5 jogos', 'data': '18/01/2026', 'status': 'Confirmado'},
      {'usuario': 'Maria Santos', 'valor': 520.00, 'tipo': 'Todos os jogos', 'data': '19/01/2026', 'status': 'Confirmado'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: pagamentos.length,
      itemBuilder: (context, index) {
        final pag = pagamentos[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.attach_money, color: Colors.white),
            ),
            title: Text(pag['usuario'] as String),
            subtitle: Text('${pag['tipo']} - ${pag['data']}'),
            trailing: Text('R\$ ${(pag['valor'] as double).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
          ),
        );
      },
    );
  }
}

class _LogsTab extends StatelessWidget {
  const _LogsTab();

  @override
  Widget build(BuildContext context) {
    final logs = DataService.getLogs();
    
    if (logs.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Nenhum log registrado', style: TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        final timestamp = DateTime.parse(log['timestamp']);
        
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Icon(Icons.history, color: Colors.blue.shade700),
            ),
            title: Text(log['action']),
            subtitle: Text(log['details']),
            trailing: Text(date_utils.formatDateFull(timestamp), style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ),
        );
      },
    );
  }
}
