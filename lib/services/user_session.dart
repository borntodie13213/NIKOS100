// sessão global do usuário - armazena credenciais para requisição
class UserSession {
  static String? cgccpf;
  static String? nascimento;
  static int? maxPalpites;
  static int palpitesFeitos = 0;
  
  static void setSession({
    required String cpf,
    required String dataNascimento,
    required int maxPalp,
  }) {
    cgccpf = cpf;
    nascimento = dataNascimento;
    maxPalpites = maxPalp;
    palpitesFeitos = 0;
  }
  
  static void clear() {
    cgccpf = null;
    nascimento = null;
    maxPalpites = null;
    palpitesFeitos = 0;
  }
  
  static bool get isLoggedIn => cgccpf != null && nascimento != null;
  
  static bool canMakePalpite() {
    if (maxPalpites == null) return false;
    return palpitesFeitos < maxPalpites!;
  }
}
