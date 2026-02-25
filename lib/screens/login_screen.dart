import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/auth_service.dart';

// TELA DE LOGIN - primeira coisa que o usuario ve
// Se nao logar, nao entra no app nao
class LoginScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onLogin;

  const LoginScreen({super.key, required this.onLogin});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers dos campos de texto
  final _cpfController = TextEditingController();
  final _diaController = TextEditingController();
  final _mesController = TextEditingController();
  final _anoController = TextEditingController();

  // Estados da tela
  bool _isLoading = false;
  String? _errorMessage;

  // ============================================
  // LOGIN - valida e loga o usuario
  // ============================================
  void _login() {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Limpa o CPF (tira pontos, tracos, espacos)
    final cpf = _cpfController.text.replaceAll(RegExp(r'[^0-9]'), '');
    // Formata a data (garante que tem 2 digitos no dia e mes)
    final dia = _diaController.text.padLeft(2, '0');
    final mes = _mesController.text.padLeft(2, '0');
    final ano = _anoController.text;

    // Valida CPF (tem que ter 11 digitos)
    if (cpf.length != 11) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'CPF deve ter 11 digitos';
      });
      return;
    }

    // Valida data (nao pode ter campo vazio e ano tem que ter 4 digitos)
    if (dia.isEmpty || mes.isEmpty || ano.isEmpty || ano.length != 4) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Data de nascimento invalida';
      });
      return;
    }

    // Monta a data no formato que o servico espera (AAAA-MM-DD)
    final dataNascimento = '$ano-$mes-$dia';
    // Chama o servico de login
    final user = AuthService.login(cpf, dataNascimento);

    // Se achou usuario, entra. Se nao, mostra erro.
    if (user != null) {
      widget.onLogin(user);
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'CPF ou data de nascimento incorretos';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fundo vermelho (cor do bolao)
      backgroundColor: const Color(0xFFCC0000),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              // Largura maxima pra nao esticar demais em telas grandes
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(50),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // TITULO BOLAO NIKOS
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFCC0000),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "BOLAO NIKOS",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Copa do Mundo 2026',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),

                  // CAMPO CPF
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('CPF', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _cpfController,
                    keyboardType: TextInputType.number,
                    // So aceita numeros e no maximo 11 digitos
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(11),
                    ],
                    decoration: InputDecoration(
                      hintText: '000.000.000-00',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // CAMPO DATA DE NASCIMENTO
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Data de Nascimento', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // DIA
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _diaController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)],
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: 'DD',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                            contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onChanged: (value) {
                            if (value.length >= 2) {
                              // TODO: NEXT FOCUS
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('/', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      // MES
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _mesController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)],
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: 'MM',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                            contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('/', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      // ANO
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: _anoController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: 'AAAA',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                            contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // MENSAGEM DE ERRO (so aparece quando tem erro)
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(_errorMessage!, style: TextStyle(color: Colors.red.shade700, fontSize: 14)),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 32),

                  // BOTAO ENTRAR
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFCC0000),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      child: _isLoading
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('ENTRAR', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // INFORMACOES EXTRAS
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Column(
                      children: [
                        Text(
                          'Acesso exclusivo para funcionarios Nikos',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'R\$ 5,00 por jogo ou R\$ 520,00 todos os jogos',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // USUARIOS DE TESTE (pra facilitar a vida de quem ta testando)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'USUARIOS DE TESTE:',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blue.shade700),
                        ),
                        const SizedBox(height: 4),
                        const Text('CPF: 12345678901 | Data: 15/05/1990', style: TextStyle(fontSize: 10)),
                        const Text('Admin: 00000000000 | Data: 01/01/1980', style: TextStyle(fontSize: 10)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // DISPOSE - limpa os controllers quando sai da tela
  // (importante pra nao dar memory leak)
  @override
  void dispose() {
    _cpfController.dispose();
    _diaController.dispose();
    _mesController.dispose();
    _anoController.dispose();
    super.dispose();
  }
}
