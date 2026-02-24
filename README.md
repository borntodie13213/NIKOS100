# Bolao Nikos - Copa do Mundo 2026

Site de apostas para a Copa do Mundo 2026, desenvolvido 100% em Flutter Web.

## Requisitos

- Flutter SDK 3.10.0 ou superior
- Dart SDK 3.0.0 ou superior

## Como executar

1. **Instale as dependencias:**
   ```bash
   flutter pub get
   ```

2. **Execute em modo desenvolvimento:**
   ```bash
   flutter run -d chrome
   ```

3. **Compile para producao:**
   ```bash
   flutter build web
   ```
   Os arquivos compilados estarao em `build/web/`

## Estrutura do Projeto

```
lib/
├── main.dart              # Entrada da aplicacao
├── screens/
│   ├── login_screen.dart  # Tela de login
│   ├── home_screen.dart   # Tela principal (usuario)
│   └── admin_screen.dart  # Painel administrativo
├── widgets/
│   ├── palpites_tab.dart  # Aba de palpites
│   ├── ranking_tab.dart   # Aba de ranking
│   ├── premiacao_tab.dart # Aba de premiacao
│   ├── regulamento_tab.dart # Aba de regulamento
│   └── conta_tab.dart     # Aba de conta
├── services/
│   ├── auth_service.dart  # Servico de autenticacao (mockado)
│   └── data_service.dart  # Servico de dados (mockado)
└── utils/
    └── date_utils.dart    # Utilitarios de data
```

## Credenciais de Teste

### Usuario comum:
- CPF: `12345678901`
- Data de Nascimento: `15/05/1990`

### Administrador:
- CPF: `00000000000`
- Data de Nascimento: `01/01/1980`

## Funcionalidades

### Usuario
- Login com CPF + Data de Nascimento
- Visualizacao e cadastro de palpites
- Ranking com Top 20 (atualiza a cada 5 min)
- Informacoes de premiacao
- Regulamento completo
- Dados da conta

### Administrador
- Gerenciamento de jogos e resultados
- Lista de usuarios
- Visualizacao de pagamentos
- Logs de alteracoes

## Bugs Intencionais (Conforme Especificacao)

1. **Cache do Ranking:** Atualiza apenas a cada 5 minutos
2. **Duplo-clique no Salvar:** O botao requer um duplo-clique rapido (300ms) para salvar
3. **Bug do Processing:** Clicar 10 vezes seguidas no botao exibe "Processando..." que nunca desaparece

## Pontuacao

- Placar exato: 20 pontos
- Acerto do vencedor/empate: 10 pontos
- Jogos do Brasil e Final: Pontos em dobro

## Tecnologias

- Flutter Web 3.x
- Dart 3.x
- Dados 100% mockados (sem backend)

## Suporte

Duvidas: bolao@nikos.com.br
