import 'package:flutter/material.dart';

class RegulamentoTab extends StatelessWidget {
  const RegulamentoTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFCC0000), Color(0xFF990000)]),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              children: [
                Icon(Icons.gavel, color: Colors.white, size: 48),
                SizedBox(height: 8),
                Text('REGULAMENTO', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2)),
                SizedBox(height: 4),
                Text('Leia com atencao todas as regras', style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSection(
            titulo: '1. INSCRICAO',
            items: [
              'Participacao exclusiva para funcionarios e familiares da empresa Nikos.',
              'Inscricao mediante pagamento de R\$ 5,00 por jogo ou R\$ 520,00 para todos os 104 jogos.',
              'O pagamento deve ser feito via PIX ou diretamente no RH.',
            ],
          ),
          _buildSection(
            titulo: '2. JOGOS',
            items: [
              'O bolao contempla todos os 104 jogos da Copa do Mundo 2026.',
              '72 jogos da fase de grupos.',
              '32 jogos da fase eliminatoria (oitavas, quartas, semi, disputa 3o e final).',
            ],
          ),
          _buildSection(
            titulo: '3. PALPITES',
            items: [
              'Os palpites podem ser registrados ate 1 hora antes do inicio de cada jogo.',
              'Apos esse prazo, o sistema bloqueia automaticamente os palpites.',
              'Cada participante pode alterar seu palpite quantas vezes quiser ate o bloqueio.',
            ],
          ),
          _buildSection(
            titulo: '4. PONTUACAO',
            items: [
              'Acerto do placar exato: 20 pontos.',
              'Acerto do vencedor/empate (sem acertar o placar): 10 pontos.',
              'Jogos do Brasil e a Final valem PONTUACAO EM DOBRO.',
            ],
          ),
          _buildSection(
            titulo: '5. RANKING',
            items: [
              'O ranking e atualizado a cada 5 minutos.',
              'Exibe os Top 20 colocados (sem mostrar a pontuacao dos outros).',
              'Cada participante ve sua propria posicao e pontuacao.',
            ],
          ),
          _buildSection(
            titulo: '6. PREMIACAO',
            items: [
              '1o Lugar: R\$ 5.000,00 via PIX.',
              '2o Lugar: TV 50 Polegadas Smart LED.',
              '3o Lugar: R\$ 1.000,00 em compras no Nikos.',
              '4o Lugar: R\$ 500,00 em compras no Nikos.',
              '5o Lugar: R\$ 250,00 em compras no Nikos.',
            ],
          ),
          _buildSection(
            titulo: '7. DESEMPATE',
            items: [
              'Em caso de empate na pontuacao final, o criterio de desempate sera:',
              '1. Maior numero de placares exatos.',
              '2. Maior numero de acertos de vencedor/empate.',
              '3. Sorteio entre os empatados.',
            ],
          ),
          _buildSection(
            titulo: '8. DISPOSICOES GERAIS',
            items: [
              'Casos omissos serao resolvidos pela comissao organizadora.',
              'A participacao implica na aceitacao integral deste regulamento.',
              'Qualquer tentativa de fraude resulta em desclassificacao imediata.',
            ],
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Column(
              children: [
                Text('Duvidas?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 8),
                Text('Entre em contato com o RH ou envie email para bolao@nikos.com.br', style: TextStyle(color: Colors.grey, fontSize: 14), textAlign: TextAlign.center),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String titulo, required List<String> items}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFCC0000),
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Text(titulo, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('- ', style: TextStyle(fontWeight: FontWeight.bold)),
                    Expanded(child: Text(item, style: const TextStyle(height: 1.4))),
                  ],
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
