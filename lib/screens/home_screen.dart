import 'package:flutter/material.dart';
import '../widgets/palpites_tab.dart';
import '../widgets/ranking_tab.dart';
import '../widgets/premiacao_tab.dart';
import '../widgets/regulamento_tab.dart';
import '../widgets/conta_tab.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  final VoidCallback onLogout;

  const HomeScreen({super.key, required this.user, required this.onLogout});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<String> _tabTitles = ['Palpites', 'Ranking', 'Premiacao', 'Regulamento', 'Conta'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
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
              child: Image.asset(
  'assets/logo_nikos.png',
  width: 40,
),
            ),
            const Spacer(),
            Text('Ola, ${widget.user['nome']?.split(' ').first ?? 'Usuario'}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: widget.onLogout,
            tooltip: 'Sair',
          ),
        ],
      ),

      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_tabTitles.length, (index) {
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

          Container(height: 1, color: Colors.grey.shade200),

          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
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

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        color: const Color(0xFFCC0000),
        child: const Text(
          '2026 NIKO\'\$ - Todos os direitos reservados',
          style: TextStyle(color: Colors.white70, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}