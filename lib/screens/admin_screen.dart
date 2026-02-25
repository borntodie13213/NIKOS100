import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/data_service.dart';
import '../services/auth_service.dart';
import '../utils/date_utils.dart' as date_utils;

// TELA DE ADMIN - onde o chefão gerencia tudo
// So admins acessam isso aqui
class AdminScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  final VoidCallback onLogout;

  const AdminScreen({super.key, required this.user, required this.onLogout});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  // Aba selecionada (0 = Jogos, 1 = Usuarios, etc)
  int _selectedTab = 0;
  // Nome das abas
  final List<String> _tabs = ['Jogos', 'Usuarios', 'Pagamentos', 'Logs'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // BARRA DO TOPO
      appBar: AppBar(
        title: Row(
          children: [
            // LOGO ADMIN (caixinha branca)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: const Text(
                "ADMIN", 
                style: TextStyle(
                  color: Color(0xFFCC0000), 
                  fontWeight: FontWeight.bold, 
                  fontSize: 16
                )
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Painel Administrativo', 
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)
            ),
          ],
        ),
        actions: [
          // Botao de sair
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: widget.onLogout, 
            tooltip: 'Sair',
          ),
        ],
      ),
      
      // CORPO
      body: Column(
        children: [
          // BARRA DE ABAS
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
                        border: Border(
                          bottom: BorderSide(
                            color: isSelected ? const Color(0xFFCC0000) : Colors.transparent,
                            width: isSelected ? 3 : 0,
                          ),
                        ),
                      ),
                      child: Text(
                        _tabs[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected ? const Color(0xFFCC0000) : Colors.grey.shade600,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          
          // Divisinha
          Container(height: 1, color: Colors.grey.shade200),
          
          // CONTEUDO DAS ABAS
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

// ============================================
// TAB DE JOGOS - admin pode editar resultados
// ============================================
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

  // Dialogo pra editar resultado do jogo
  void _editarResultado(Map<String, dynamic> jogo) {
    final Controller = TextEditingController(text: jogo['golsTime1']?.toString() ?? '');
    final Controller2 = TextEditingController(text: jogo['golsTime2']?.toString() ?? '');

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
                    controller: Controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: jogo['time1'], 
                      border: const OutlineInputBorder()
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('X', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: TextField(
                    controller: Controller2,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: jogo['time2'], 
                      border: const OutlineInputBorder()
                    ),
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
              final Controller1 = int.tryParse(Controller.text);
              final Controller2 = int.tryParse(Controller2.text);
              
              if (Controller1 != null && Controller2 != null) {
                final updatedJogo = {
                  ...jogo, 
                  'golsTime1': Controller1, 
                  'golsTime2': Controller2, 
                  'finalizado': true
                };
                DataService.updateJogo(updatedJogo);
                DataService.addLog(
                  'RESULTADO', 
                  '${jogo['time1']} $Controller1 x $Controller2 ${jogo['time2']}', 
                  widget.adminId
                );
                _loadJogos();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Resultado salvo!'), 
                    backgroundColor: Colors.green
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
    return Column(
      children: [
        // FILTRO DE FASES
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              const Text(
                'Filtrar: ', 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: DropdownButton<String>(
                    value: _filtroFase,
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: _fases.map((fase) => DropdownMenuItem(
                      value: fase, 
                      child: Text(fase)
                    )).toList(),
                    onChanged: (value) {
                      if (value != null) setState(() => _filtroFase = value);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // LISTA DE JOGOS
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _jogosFiltrados.length,
            itemBuilder: (context, index) {
              final jogo = _jogosFiltrados[index];
              final dataHora = DateTime.parse(jogo['dataHora']);
              
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  title: Text(
                    '${jogo['time1']} x ${jogo['time2']}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    '${jogo['fase']} - ${date_utils.formatDate(dataHora)}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Status do jogo (finalizado ou pendente)
                      if (jogo['finalizado'] == true)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100, 
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${jogo['golsTime1']} x ${jogo['golsTime2']}', 
                            style: TextStyle(
                              color: Colors.green.shade700, 
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200, 
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Pendente', 
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ),
                      const SizedBox(width: 8),
                      // Botao de editar
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.grey.shade700),
                        onPressed: () => _editarResultado(jogo),
                      ),
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

// ============================================
// TAB DE USUARIOS - lista de usuarios cadastrados
// ============================================
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
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFFCC0000),
              child: Text(
                user['nome'][0], 
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
              ),
            ),
            title: Text(
              user['nome'],
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'CPF: ${user['cpf']} | Pontos: ${user['pontos']}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            trailing: user['todosJogosLiberados'] == true
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100, 
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'COMPLETO', 
                      style: TextStyle(
                        color: Colors.green.shade700, 
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100, 
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'PARCIAL', 
                      style: TextStyle(
                        color: Colors.orange.shade700, 
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}

// ============================================
// TAB DE PAGAMENTOS - lista de pagamentos (fake por enquanto)
// ============================================
class _PagamentosTab extends StatelessWidget {
  const _PagamentosTab();

  @override
  Widget build(BuildContext context) {
    // Dados fake de pagamentos (simulacao)
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
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green.shade100,
              child: Icon(Icons.attach_money, color: Colors.green.shade700),
            ),
            title: Text(
              pag['usuario'] as String,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              '${pag['tipo']} - ${pag['data']}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            trailing: Text(
              'R\$ ${(pag['valor'] as double).toStringAsFixed(2)}', 
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                color: Colors.green.shade700,
                fontSize: 14,
              ),
            ),
          ),
        );
      },
    );
  }
}

// ============================================
// TAB DE LOGS - historico de acoes do admin
// ============================================
class _LogsTab extends StatelessWidget {
  const _LogsTab();

  @override
  Widget build(BuildContext context) {
    final logs = DataService.getLogs();
    
    // Se nao tem logs, mostra mensagem
    if (logs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'Nenhum log registrado', 
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16)
            ),
          ],
        ),
      );
    }
    
    // Lista de logs
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        final timestamp = DateTime.parse(log['timestamp']);
        
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Icon(Icons.history, color: Colors.blue.shade700),
            ),
            title: Text(
              log['action'],
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              log['details'],
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            trailing: Text(
              date_utils.formatDateFull(timestamp), 
              style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
            ),
          ),
        );
      },
    );
  }
}