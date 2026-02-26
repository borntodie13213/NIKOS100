import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/admin_screen.dart';
import 'services/auth_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BolaoNikosApp());
}

class BolaoNikosApp extends StatelessWidget {
  const BolaoNikosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Bolao Nikos",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFCC0000),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFCC0000),
          primary: const Color(0xFFCC0000),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFCC0000),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFCC0000),
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoggedIn = false;
  bool _isAdmin = false;
  Map<String, dynamic>? _currentUser;

  void _onLogin(Map<String, dynamic> user) {
    setState(() {
      _isLoggedIn = true;
      _currentUser = user;
      _isAdmin = user['isAdmin'] ?? false;
    });
  }

  void _onLogout() {
    AuthService.logout();
    setState(() {
      _isLoggedIn = false;
      _currentUser = null;
      _isAdmin = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      return LoginScreen(onLogin: _onLogin);
    }

    if (_isAdmin) {
      return AdminScreen(user: _currentUser!, onLogout: _onLogout);
    }

    return HomeScreen(user: _currentUser!, onLogout: _onLogout);
  }
}