import 'package:flutter/material.dart';
import '../services/data_service.dart';

class ContaTab extends StatelessWidget {
  final Map<String, dynamic> user;
  final VoidCallback onLogout;

  const ContaTab({super.key, required this.user, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    // Pegando os palpites do cara e os jogos
    final palpites = DataService.getPalpites().where((p) => p['usuarioId'] == user['id']).toList();
    final jogos = DataService.getJogos();

    // Calculando quantos jogos já acabaram
    int jogosFinalizados = jogos.where((j) => j['finalizado'] == true).length;
    int palpitesFeitos = palpites.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // CABEÇALHO VERMELHÃO - foto do cara e nome
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFCC0000), Color(0xFF990000)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.shade200,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Foto de perfil - primeira letra do nome
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Text(
                    user['nome']?[0] ?? 'U',
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFCC0000)),
                  ),
                ),
                const SizedBox(height: 16),
                // Nome dele
                Text(
                  user['nome'] ?? 'Usuario',
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                // CPF mascarado (só mostra os 3 primeiros e 2 últimos)
                Text('CPF: ${_formatCPF(user['cpf'])}', style: const TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // CARDS DE ESTATÍSTICA - linha 1
          Row(
            children: [
              Expanded(
                child: _buildStatCard(icon: Icons.sports_soccer, label: 'Palpites Feitos', value: '$palpitesFeitos'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(icon: Icons.stars, label: 'Pontos Atuais', value: '${user['pontos']}'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // CARDS DE ESTATÍSTICA - linha 2
          Row(
            children: [
              Expanded(
                child: _buildStatCard(icon: Icons.check_circle, label: 'Jogos Finalizados', value: '$jogosFinalizados'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(icon: Icons.schedule, label: 'Jogos Restantes', value: '${jogos.length - jogosFinalizados}'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // BOX DE STATUS - se ele pagou tudo ou não
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 6, offset: const Offset(0, 3))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('STATUS DA INSCRICAO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    // Ícone grande de status
                    Icon(
                      user['todosJogosLiberados'] == true ? Icons.check_circle : Icons.warning,
                      color: user['todosJogosLiberados'] == true ? Colors.green : Colors.orange,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Texto grande do status
                          Text(
                            user['todosJogosLiberados'] == true ? 'Inscricao Completa' : 'Inscricao Parcial',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: user['todosJogosLiberados'] == true ? Colors.green : Colors.orange,
                            ),
                          ),
                          // Texto pequeno explicativo
                          Text(
                            user['todosJogosLiberados'] == true ? 'Voce tem acesso a todos os 104 jogos' : 'Voce tem acesso apenas aos jogos pagos',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // BOX DE INFORMAÇÕES - dados do usuário
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 6, offset: const Offset(0, 3))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('INFORMACOES DA CONTA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 16),
                _buildInfoRow('Nome completo', user['nome'] ?? '-'),
                _buildInfoRow('CPF', _formatCPF(user['cpf'])),
                _buildInfoRow('Data de nascimento', _formatData(user['dataNascimento'])),
                _buildInfoRow('ID do usuario', user['id'] ?? '-'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // BOTÃO DE SAIR - vermelho outline
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onLogout,
              icon: const Icon(Icons.logout, color: Color(0xFFCC0000)),
              label: const Text(
                'SAIR DA CONTA',
                style: TextStyle(color: Color(0xFFCC0000), fontWeight: FontWeight.bold),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFCC0000), width: 2),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // CARD DE ESTATÍSTICA - reutilizável em qualquer lugar
  Widget _buildStatCard({required IconData icon, required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 6, offset: const Offset(0, 3))],
      ),
      child: Column(
        children: [
          // Ícone vermelho no meio
          Icon(icon, color: const Color(0xFFCC0000), size: 32),
          const SizedBox(height: 8),
          // Número grande
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          // Label pequeno
          Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
        ],
      ),
    );
  }

  // LINHA DE INFORMAÇÃO - label + valor
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // FORMATA CPF - 12345678900 -> 123.456.789-00
  // se não der, devolve o que veio ou traço
  String _formatCPF(String? cpf) {
    if (cpf == null || cpf.length != 11) return cpf ?? '-';
    return '${cpf.substring(0, 3)}.${cpf.substring(3, 6)}.${cpf.substring(6, 9)}-${cpf.substring(9)}';
  }

  // FORMATA DATA - 2000-01-15 -> 15/01/2000
  // nem sei se tá funcionando direito
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
