import 'package:flutter/material.dart';
import '../widgets/palpites_tab.dart';
import '../widgets/ranking_tab.dart';
import '../widgets/premiacao_tab.dart';
import '../widgets/regulamento_tab.dart';
import '../widgets/conta_tab.dart';

// TELA PRINCIPAL DO APP - onde o usuario passa 90% do tempo
// Tem a barra deabas no topo e o conteudo embaixo
class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  final VoidCallback onLogout;

  const HomeScreen({super.key, required this.user, required this.onLogout});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Aba selecionada no momento (0 = Palpites, 1 = Ranking, etc)
  int _selectedIndex = 0;
  
  // Titulos das abas (na mesma ordem do IndexedStack)
  final List<String> _tabTitles = ['Palpites', 'Ranking', 'Premiacao', 'Regulamento', 'Conta'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // BARRA DO TOPO - titulo e botao de sair
      appBar: AppBar(
        title: Row(
          children: [
            // LOGO BOLAO NIKOS (caixinha branca com texto vermelho)
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
                "BOLAO NIKOS", 
                style: TextStyle(
                  color: Color(0xFFCC0000), 
                  fontWeight: FontWeight.bold, 
                  fontSize: 16
                )
              ),
            ),
            const Spacer(),
            // Saudacao com o primeiro nome do usuario
            Text(
              'Ola, ${widget.user['nome']?.split(' ').first ?? 'Usuario'}', 
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)
            ),
          ],
        ),
        actions: [
          // Botao de sair (logout)
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: widget.onLogout, 
            tooltip: 'Sair',
          ),
        ],
      ),
      
      // CORPO DA TELA - abas e conteudo
      body: Column(
        children: [
          // BARRA DE ABAS - scrollavel horizontalmente
          Container(
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_tabTitles.length, (index) {
                  // Verifica se essa aba ta selecionada
                  final isSelected = _selectedIndex == index;
                  return InkWell(
                    onTap: () => setState(() => _selectedIndex = index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isSelected ? const Color(0xFFCC0000) : Colors.transparent,
                            width: isSelected ? 3 : 0,
                          ),
                        ),
                      ),
                      child: Text(
                        _tabTitles[index],
                        style: TextStyle(
                          color: isSelected ? const Color(0xFFCC0000) : Colors.grey.shade600,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          
          // Divisinha entre abas e conteudo
          Container(height: 1, color: Colors.grey.shade200),
          
          // CONTEUDO DAS ABAS - IndexedStack pra nao recarregar
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                // Cada aba é um widget separado
                PalpitesTab(user: widget.user),
                RankingTab(user: widget.user),
                const PremiacaoTab(),
                const RegulamentoTab(),
                ContaTab(user: widget.user, onLogout: widget.onLogout),
              ],
            ),
          ),
        ],
      ),
      
      // BARRA DO RODAPE - copyright e tal
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        color: const Color(0xFFCC0000),
        child: const Text(
          '2026 Bolao Nikos - Todos os direitos reservados',
          style: TextStyle(
            color: Colors.white70, 
            fontSize: 12
          ), 
          textAlign: TextAlign.center
        ),
      ),
    );
  }
}