import 'package:flutter/material.dart';

// Widget principal da tela de regulamento
// Se não funcionar, deu ruim
class RegulamentoTab extends StatelessWidget {
  const RegulamentoTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CABEÇALHO - O famoso retângulo vermelho
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFCC0000), Color(0xFF990000)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
              // Gambiarra: sombra avermelhada para dar "glow"
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
                // Ícone do martelo (parece que vai processar alguém)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.gavel, color: Colors.white, size: 48),
                ),
                const SizedBox(height: 12),
                const Text(
                  'REGULAMENTO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Leia com atenção todas as regras',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Seções do regulamento - cada uma com seu método próprio
          // (deixa o código mais organizado sei la)
          _buildSection(
            titulo: '1. INSCRIÇÃO',
            icone: Icons.app_registration,
            items: [
              'Inscrição mediante pagamento de R\$ 5,00 por jogo ou R\$ 520,00 para todos os 104 jogos.',
              'O pagamento deve ser feito via PIX ou diretamente no RH.',
            ],
          ),
          _buildSection(
            titulo: '2. JOGOS',
            icone: Icons.sports_soccer,
            items: [
              'O bolão contempla todos os 104 jogos da Copa do Mundo 2026.',
              '72 jogos da fase de grupos.',
              '32 jogos da fase eliminatória (oitavas, quartas, semi, disputa 3º e final).',
            ],
          ),
          _buildSection(
            titulo: '3. PALPITES',
            icone: Icons.touch_app,
            items: [
              'Os palpites podem ser registrados até 1 hora antes do início de cada jogo.',
              'Após esse prazo, o sistema bloqueia automaticamente os palpites.',
              'Cada participante pode alterar seu palpite quantas vezes quiser até o bloqueio.',
            ],
          ),
          _buildSection(
            titulo: '4. PONTUAÇÃO',
            icone: Icons.stars,
            items: [
              'Acerto do placar exato: 20 pontos.',
              'Acerto do vencedor/empate (sem acertar o placar): 10 pontos.',
              'Jogos do Brasil e a Final valem PONTUAÇÃO EM DOBRO.',
            ],
            destaque: true, //GAMBIARRA: parâmetro para destacar seções importantes
          ),
          _buildSection(
            titulo: '5. RANKING',
            icone: Icons.leaderboard,
            items: [
              'O ranking é atualizado a cada 5 minutos.',
              'Exibe os Top 20 colocados (sem mostrar a pontuação dos outros).',
              'Cada participante vê sua própria posição e pontuação.',
            ],
          ),
          _buildSection(
            titulo: '6. PREMIAÇÃO',
            icone: Icons.card_giftcard,
            items: [
              '1º Lugar: R\$ 5.000,00 via PIX.',
              '2º Lugar: TV 50 Polegadas Smart LED.',
              '3º Lugar: R\$ 1.000,00 em compras no Nikos.',
              '4º Lugar: R\$ 500,00 em compras no Nikos.',
              '5º Lugar: R\$ 250,00 em compras no Nikos.',
            ],
            destaque: true,
          ),
          _buildSection(
            titulo: '7. DESEMPATE',
            icone: Icons.balance,
            items: [
              'Em caso de empate na pontuação final, o critério de desempate será:',
              '1. Maior número de placares exatos.',
              '2. Maior número de acertos de vencedor/empate.',
              '3. Sorteio entre os empatados.',
            ],
          ),
          _buildSection(
            titulo: '8. DISPOSIÇÕES GERAIS',
            icone: Icons.info,
            items: [
              'Casos omissos serão resolvidos pela comissão organizadora.',
              'A participação implica na aceitação integral deste regulamento.',
              'Qualquer tentativa de fraude resulta em desclassificação imediata.',
            ],
          ),
          const SizedBox(height: 24),

          // Rodapé com contato - porque alguém vai ter dúvidas
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.help_outline, color: Colors.grey.shade600, size: 24),
                    const SizedBox(width: 8),
                    const Text(
                      'Dúvidas?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Entre em contato com o RH ou envie e-mail para',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () {
                    // TODO: Implementar envio de e-mail
                    // Se não funcionar, mande um pombo
                  },
                  child: Text(
                    'bolao@nikos.com.br',
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
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

  // GAMBIARRA: Método genérico que constrói qualquer seção
  // Feito às 3 da manhã, mas funciona PERFEITAMENTE
  Widget _buildSection({
    required String titulo,
    required List<String> items,
    required IconData icone,
    bool destaque = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
        // Gambiarra: borda vermelha se for seção importante
        border: destaque ? Border.all(color: Colors.red.shade300, width: 1) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho da seção com gradiente
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: destaque ? [Color(0xFFE53935), Color(0xFFCC0000)] : [Color(0xFFCC0000), Color(0xFF990000)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Row(
              children: [
                Icon(icone, color: Colors.white, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    titulo,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Lista de itens
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items.asMap().entries.map((entrada) {
                final indice = entrada.key;
                final item = entrada.value;
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: indice < items.length - 1 ? 10 : 0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Bullet point personalizado (círculo vermelho)
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.red.shade700,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
