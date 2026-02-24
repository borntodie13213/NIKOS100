import 'package:flutter/material.dart';

class PremiacaoTab extends StatelessWidget {
  const PremiacaoTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
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
                Icon(Icons.emoji_events, color: Colors.amber, size: 48),
                SizedBox(height: 8),
                Text('PREMIACAO', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2)),
                SizedBox(height: 4),
                Text('Bolao Nikos - Copa do Mundo 2026', style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildPremioCard(posicao: 1, premio: 'R\$ 5.000,00', descricao: 'via PIX', cor: Colors.amber, icone: '1o'),
          _buildPremioCard(posicao: 2, premio: 'TV 50 Polegadas', descricao: 'Smart TV LED', cor: Colors.grey.shade400, icone: '2o'),
          _buildPremioCard(posicao: 3, premio: 'R\$ 1.000,00', descricao: 'em compras no Nikos', cor: Colors.brown.shade300, icone: '3o'),
          _buildPremioCard(posicao: 4, premio: 'R\$ 500,00', descricao: 'em compras no Nikos', cor: Colors.grey.shade300, icone: '4o'),
          _buildPremioCard(posicao: 5, premio: 'R\$ 250,00', descricao: 'em compras no Nikos', cor: Colors.grey.shade200, icone: '5o'),
        ],
      ),
    );
  }

  Widget _buildPremioCard({required int posicao, required String premio, required String descricao, required Color cor, required String icone}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 80, padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: cor, borderRadius: const BorderRadius.horizontal(left: Radius.circular(8))),
            child: Center(child: Text(icone, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${posicao}o Colocado', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(premio, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFCC0000))),
                  Text(descricao, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
