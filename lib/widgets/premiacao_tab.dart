import 'package:flutter/material.dart';

class PremiacaoTab extends StatelessWidget {
  const PremiacaoTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // CABECALHO - Titulo principal com gradiente vermelho
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
                // Icone de trofeu (amarelo para destacar)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.shade200,
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.emoji_events, color: Colors.white, size: 48),
                ),
                const SizedBox(height: 12),
                const Text(
                  'PREMIACAO',
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
                  'Bolao Nikos - Copa do Mundo 2026',
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
          
          // PREMIOS - Lista dos 5 primeiros lugares
          // GAMBIARRA: Parametro destaque para o primeiro lugar
          _buildPremioCard(
            posicao: 1,
            premio: 'R\$ 5.000,00',
            descricao: 'via PIX',
            cor: Colors.amber,
            icone: '1o',
            destaque: true,
          ),
          _buildPremioCard(
            posicao: 2,
            premio: 'TV 50 Polegadas',
            descricao: 'Smart TV LED',
            cor: Colors.grey.shade400,
            icone: '2o',
          ),
          _buildPremioCard(
            posicao: 3,
            premio: 'R\$ 1.000,00',
            descricao: 'em compras no Nikos',
            cor: Colors.brown.shade300,
            icone: '3o',
          ),
          _buildPremioCard(
            posicao: 4,
            premio: 'R\$ 500,00',
            descricao: 'em compras no Nikos',
            cor: Colors.grey.shade300,
            icone: '4o',
          ),
          _buildPremioCard(
            posicao: 5,
            premio: 'R\$ 250,00',
            descricao: 'em compras no Nikos',
            cor: Colors.grey.shade200,
            icone: '5o',
          ),
          
          const SizedBox(height: 16),
          
          // OBSERVACAO FINAL - Texto complementar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.grey.shade600, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Os premios serao entregues em ate 30 dias apos o termino do bolao.',
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
    );
  }

  // GAMBIARRA: Metodo generico que constroi qualquer card de premio
  // Feito de madruga mas ficou bonito oque acha ramon ? kkkk
  Widget _buildPremioCard({
    required int posicao,
    required String premio,
    required String descricao,
    required Color cor,
    required String icone,
    bool destaque = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: destaque
          ? Border.all(color: Colors.amber.shade300, width: 2)
          : null,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // LADO ESQUERDO - Numero da posicao com cor
          Container(
            width: 80,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cor,
              borderRadius: BorderRadius.horizontal(
                left: const Radius.circular(12),
                right: destaque ? Radius.zero : Radius.circular(0),
              ),
              // GAMBIARRA: Gradiente especial para primeiro lugar
              gradient: destaque
                ? LinearGradient(
                    colors: [Colors.amber.shade400, Colors.amber.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            ),
            child: Center(
              child: Text(
                icone,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: posicao <= 3 ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
          
          // LADO DIREITO - Detalhes do premio
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Texto "1o Colocado" etc
                  Text(
                    '${posicao}o Colocado',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  // Premio em destaque vermelho
                  Text(
                    premio,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: destaque ? Colors.amber.shade700 : const Color(0xFFCC0000),
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  // Descricao secundaria
                  Text(
                    descricao,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // ICONE DE TROFEU para primeiros lugares
          if (posicao <= 3)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Icon(
                Icons.emoji_events,
                color: cor,
                size: 28,
              ),
            ),
        ],
      ),
    );
  }
}