# 📊 Como Usar Dados do Usuário no Seu App

## 🎯 **Arquivos Criados para Você:**

1. **`lib/pages/profile_page.dart`** → Página completa de perfil
2. **`lib/utils/user_utils.dart`** → Funções úteis para pegar dados
3. **`lib/widgets/user_greeting.dart`** → Widgets prontos para usar

## 🚀 **Exemplos Práticos de Uso:**

### **1. Pegar Dados Básicos (Simples)**

```dart
import 'package:volleyball_center_mobile/utils/user_utils.dart';

// Verificar se usuário está logado
if (UserUtils.isLoggedIn()) {
  // Usuário está logado
}

// Pegar email
String email = UserUtils.getUserEmail();

// Pegar nome (do Authentication)
String nome = UserUtils.getUserDisplayName();

// Pegar UID
String uid = UserUtils.getUserUID();
```

### **2. Pegar Dados do Firestore (Avançado)**

```dart
// Pegar dados completos do Firestore
final profile = await UserUtils.getUserProfile();
if (profile != null) {
  String nome = profile['name'] ?? 'N/A';
  String email = profile['email'] ?? 'N/A';
  bool ativo = profile['isActive'] ?? false;
  // etc...
}

// Pegar nome (prioriza Firestore)
String nome = await UserUtils.getUserName();
```

### **3. Saudação Personalizada**

```dart
// Gerar saudação automaticamente
String saudacao = await UserUtils.getGreeting();
// Resultado: "Bom dia, João!" ou "Boa tarde, Maria!"

// Usar no seu widget:
Text(saudacao)
```

### **4. Widget de Saudação Pronto**

```dart
import 'package:volleyball_center_mobile/widgets/user_greeting.dart';

// Uso simples
UserGreeting()

// Com detalhes
UserGreeting(
  showDetails: true,
  textStyle: TextStyle(fontSize: 24, color: Colors.blue),
)
```

### **5. Avatar do Usuário**

```dart
import 'package:volleyball_center_mobile/widgets/user_greeting.dart';

// Avatar pequeno
UserAvatar(size: 40)

// Avatar grande
UserAvatar(size: 80)
```

## 📱 **Exemplos para Seu App Volleyball Center:**

### **Na Tela Principal (main.dart):**

```dart
// No AppBar
AppBar(
  title: Text('Volleyball Center'),
  actions: [
    Padding(
      padding: EdgeInsets.all(8),
      child: UserAvatar(size: 35),
    ),
  ],
)

// No corpo da tela
Column(
  children: [
    UserGreeting(showDetails: true),
    // resto do conteúdo...
  ],
)
```

### **Na Navbar:**

```dart
// Mostrar nome do usuário
class Navbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: UserUtils.isLoggedIn() 
        ? UserGreeting()
        : Text('Volleyball Center'),
    );
  }
}
```

### **Personalizar Conteúdo por Usuário:**

```dart
// Mostrar conteúdo diferente para usuários logados
Widget build(BuildContext context) {
  if (UserUtils.isLoggedIn()) {
    return Column(
      children: [
        UserGreeting(showDetails: true),
        Text('Bem-vindo de volta!'),
        // conteúdo personalizado...
      ],
    );
  } else {
    return Column(
      children: [
        Text('Faça login para ver mais conteúdo'),
        ElevatedButton(
          onPressed: () => Navigator.push(...Login()),
          child: Text('Login'),
        ),
      ],
    );
  }
}
```

## 🔧 **Atualizar Dados do Usuário:**

```dart
// Atualizar dados no Firestore
bool sucesso = await UserUtils.updateUserProfile({
  'name': 'Novo Nome',
  'telefone': '11999999999',
  // qualquer campo que quiser...
});

if (sucesso) {
  print('Dados atualizados!');
}
```

## 📝 **Verificações Úteis:**

```dart
// Verificar se email está verificado
if (UserUtils.isEmailVerified()) {
  // Email verificado
} else {
  // Mostrar banner para verificar email
}

// Tempo como membro
String tempoMembro = UserUtils.getMemberSince();
// "Membro há 2 meses" ou "Novo membro"
```

## 🎯 **Como Integrar na Sua Navbar Atual:**

Modifique seu arquivo `navbar.dart`:

```dart
import 'package:volleyball_center_mobile/widgets/user_greeting.dart';
import 'package:volleyball_center_mobile/utils/user_utils.dart';

class Navbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFF14276B),
      title: UserUtils.isLoggedIn() 
        ? UserGreeting(
            textStyle: TextStyle(color: Colors.white),
          )
        : Text('Volleyball Center'),
      actions: [
        if (UserUtils.isLoggedIn())
          Padding(
            padding: EdgeInsets.all(8),
            child: UserAvatar(size: 35),
          ),
      ],
    );
  }
}
```

## 🔥 **Dicas Importantes:**

1. **Sempre verifique se o usuário está logado** antes de usar os dados
2. **Use await** para funções que buscam dados do Firestore
3. **Trate erros** quando necessário
4. **UserUtils** é uma classe estática, use diretamente

## 🎯 **Próximos Passos:**

1. ✅ Teste os widgets criados
2. ✅ Integre na sua navbar
3. ✅ Use saudações personalizadas
4. ✅ Adicione página de perfil completa

**Agora você tem controle total sobre os dados dos usuários! Use os exemplos acima em qualquer lugar do seu app.** 🚀