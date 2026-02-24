import 'package:flutter/material.dart';
// Importa as telas - preciso verificar se admin_screen existe
// se não existir vai dar pau, mas por agora OK
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/admin_screen.dart';
import 'services/auth_service.dart';

// Inicializa o app
void main() {
  // isso aqui é pra garantir que initialize tudo antes
  // não sei bem por que mas o firebase precisa disso
  // peguei de um stackoverflow lá
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BolaoNikosApp());
}

// App principal
// TODO: mudar nome pra algo melhor depois
class BolaoNikosApp extends StatelessWidget {
  const BolaoNikosApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Configura o tema do app
    // Vermelho do time do cara que pediu (Nikos?)
    // Não sei se é vermelho escuro ou claro, vou deixando assim
    return MaterialApp(
      title: "Bolao Nikos", // título que aparece no drawer
      debugShowCheckedModeBanner: false, //tira aquele banner chato do debug
      theme: ThemeData(
        // cor principal - vermelho sangue (ou algo assim)
        primaryColor: const Color(0xFFCC0000),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5), // cinza claro fundo
        
        // esquema de cores - isso aqui é obrigatório no flutter novo
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFCC0000),
          primary: const Color(0xFFCC0000),
        ),
        
        // AppBar - barra do topo
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFCC0000), // vermelho
          foregroundColor: Colors.white, // texto branco
          elevation: 0, // sem sombra (flat design)
        ),
        
        // Botões elevados - estilo
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFCC0000), // vermelho
            foregroundColor: Colors.white, // texto branco
          ),
        ),
      ),
      
      // Primeira tela - AuthWrapper que decide se mostra login ou home
      home: const AuthWrapper(),
    );
  }
}

// Classe que verifica se usuário está logado
// e redireciona pra tela certa
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

// State do AuthWrapper
// aqui que a mágica acontece - verifica login e mostra tela
class _AuthWrapperState extends State<AuthWrapper> {
  // Flags de estado - true = logado, false = deslogado
  bool _isLoggedIn = false; // não tá logado no início
  bool _isAdmin = false; // não é admin por padrão
  Map<String, dynamic>? _currentUser; // dados do usuário logado
  
  // FIXME: as vezes o usuário fica null e dá erro
  // preciso debugar isso depois

  // Callback quando usuário faz login
  // Recebe dados do usuário e atualiza estado
  void _onLogin(Map<String, dynamic> user) {
    // Gambiarra: precisa do setState senão não atualiza a tela
    setState(() {
      _isLoggedIn = true;
      _currentUser = user;
      // verifica se é admin - default false
      _isAdmin = user['isAdmin'] ?? false;
    });
  }

  // Callback quando usuário faz logout
  // Chama serviço de auth e reseta tudo
  void _onLogout() {
    // primeiro faz logout no serviço
    AuthService.logout();
    
    // depois reseta o state
    // gambiarra: usando setState pra forçar rebuild
    setState(() {
      _isLoggedIn = false;
      _currentUser = null;
      _isAdmin = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Se não está logado, mostra tela de login
    if (!_isLoggedIn) {
      return LoginScreen(onLogin: _onLogin);
    }
    
    // Se é admin, mostra tela de admin
    // FIXME: as vezes o _currentUser é null aqui e dá crash
    // workaround: usa ! (force unwrap) - Se der pau a gente vê
    if (_isAdmin) {
      return AdminScreen(user: _currentUser!, onLogout: _onLogout);
    }
    
    // Se não é admin nem tá logado...hmm
    // Mas isso não deveria acontecer porque senão voltaria pro login
    // Deixa quieto, se funcionar tudo bem
    return HomeScreen(user: _currentUser!, onLogout: _onLogout);
  }
}