import 'package:flutter/material.dart';
import '../services/data_service.dart';

class ContaTab extends StatelessWidget {
  final Map<String, dynamic> user;
  final VoidCallback onLogout;

  const ContaTab({super.key, required this.user, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final palpites = DataService.getPalpites().where((p) => p['usuarioId'] == user['id']).toList();
    final jogos = DataService.getJogos();

    int jogosFinalizados = jogos.where((j) => j['finalizado'] == true).length;
    int palpitesFeitos = palpites.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header do perfil com efeito 3D
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFCC0000), Color(0xFF8B0000), Color(0xFF660000)],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.shade300,
                  blurRadius: 25,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              children: [
                // Avatar 3D
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Colors.white, Colors.white70],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color(0xFFCC0000),
                    child: Text(
                      user['nome']?[0] ?? 'U',
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  user['nome'] ?? 'Usuario',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'CPF: ${_formatCPF(user['cpf'])}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.sports_soccer),
              label: const Text(
                "VER MEUS PALPITES",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCC0000),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MeusPalpitesScreen(user: user),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // Estatisticas
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.sports_soccer,
                  label: 'Palpites',
                  value: '$palpitesFeitos',
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.stars,
                  label: 'Pontos',
                  value: '${user['pontos']}',
                  color: Colors.amber,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.check_circle,
                  label: 'Finalizados',
                  value: '$jogosFinalizados',
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.schedule,
                  label: 'Restantes',
                  value: '${jogos.length - jogosFinalizados}',
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Status da inscricao
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: user['todosJogosLiberados'] == true ? Colors.green.shade50 : Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        user['todosJogosLiberados'] == true ? Icons.verified : Icons.warning,
                        color: user['todosJogosLiberados'] == true ? Colors.green.shade600 : Colors.orange.shade600,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'STATUS DA INSCRICAO',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user['todosJogosLiberados'] == true ? 'Inscricao Completa' : 'Inscricao Parcial',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: user['todosJogosLiberados'] == true ? Colors.green.shade700 : Colors.orange.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, size: 18, color: Colors.grey.shade600),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          user['todosJogosLiberados'] == true ? 'Voce tem acesso a todos os 104 jogos' : 'Voce tem acesso apenas aos jogos pagos',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Informacoes da conta
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.person_outline, color: Color(0xFFCC0000)),
                    SizedBox(width: 10),
                    Text(
                      'INFORMACOES DA CONTA',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildInfoRow('Nome completo', user['nome'] ?? '-'),
                _buildInfoRow('CPF', _formatCPF(user['cpf'])),
                _buildInfoRow('Data de nascimento', _formatData(user['dataNascimento'])),
                _buildInfoRow('ID do usuario', user['id'] ?? '-'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Botao de logout
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onLogout,
              icon: const Icon(Icons.logout),
              label: const Text(
                'SAIR DA CONTA',
                style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade800,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 8,
                shadowColor: Colors.grey.shade400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCPF(String? cpf) {
    if (cpf == null || cpf.length != 11) return cpf ?? '-';
    return '${cpf.substring(0, 3)}.${cpf.substring(3, 6)}.${cpf.substring(6, 9)}-${cpf.substring(9)}';
  }

  String _formatData(String? data) {
    if (data == null) return '-';
    try {
      final parts = data.split('-');
      return '${parts[2]}/${parts[1]}/${parts[0]}';
    } catch (_) {
      return data;
    }
  }
}

// esta com um bug de palpite ver isso com eles essa duvida. deixa em stand by para resolver depois
class MeusPalpitesScreen extends StatelessWidget {
  final Map<String, dynamic> user;

  const MeusPalpitesScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final palpites = DataService.getPalpites().where((p) => p['usuarioId'] == user['id']).toList();

    final jogos = DataService.getJogos();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus Palpites"),
        backgroundColor: const Color(0xFFCC0000),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: palpites.length,
        itemBuilder: (context, index) {
          final palpite = palpites[index];
          final jogo = jogos.firstWhere(
            (j) => j['id'] == palpite['jogoId'],
            orElse: () => {},
          );

          final gol1 = palpite['gol1'] ?? 0;
          final gol2 = palpite['gol2'] ?? 0;

          final temPalpite = gol1 != 0 && gol2 != 0;
          final jogoFinalizado = jogo['finalizado'] == true;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${jogo['time1']} x ${jogo['time2']}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 10),

                /// PALPITE DO USUARIO
                if (temPalpite) ...[
                  Row(
                    children: [
                      const Icon(Icons.sports_soccer, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        "Seu palpite: $gol1 x $gol2",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ] else if (!jogoFinalizado) ...[
                  const Row(
                    children: [
                      Icon(Icons.hourglass_empty, size: 18),
                      SizedBox(width: 6),
                      Text(
                        "Você ainda não fez palpite",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  const Row(
                    children: [
                      Icon(Icons.hourglass_empty, size: 18),
                      SizedBox(width: 6),
                      Text(
                        "Sem palpite ainda",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
