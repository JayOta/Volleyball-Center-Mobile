import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream para ouvir mudanças no estado de autenticação
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Usuário atual
  User? get currentUser => _auth.currentUser;

  // Cadastro com email e senha
  Future<UserCredential?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      print('Tentando criar usuário com email: $email'); // Debug log
      
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      print('Usuário criado com sucesso: ${result.user?.uid}'); // Debug log
      return result;
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.code} - ${e.message}'); // Debug log
      throw _handleAuthException(e);
    } catch (e) {
      print('Erro geral: $e'); // Debug log
      throw 'Erro inesperado ao criar conta: $e';
    }
  }

  // Login com email e senha
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      print('Tentando fazer login com email: $email'); // Debug log
      
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      print('Login realizado com sucesso: ${result.user?.uid}'); // Debug log
      return result;
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException no login: ${e.code} - ${e.message}'); // Debug log
      throw _handleAuthException(e);
    } catch (e) {
      print('Erro geral no login: $e'); // Debug log
      throw 'Erro inesperado no login: $e';
    }
  }

  // Logout
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print('Logout realizado com sucesso'); // Debug log
    } catch (e) {
      print('Erro no logout: $e'); // Debug log
      throw 'Erro ao fazer logout: $e';
    }
  }

  // Atualizar nome do usuário
  Future<void> updateDisplayName(String displayName) async {
    try {
      print('Atualizando nome do usuário para: $displayName'); // Debug log
      await currentUser?.updateDisplayName(displayName);
      await currentUser?.reload(); // Recarrega os dados do usuário
      print('Nome atualizado com sucesso'); // Debug log
    } catch (e) {
      print('Erro ao atualizar nome: $e'); // Debug log
      throw 'Erro ao atualizar nome: $e';
    }
  }

  // Redefinir senha
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      print('Enviando email de redefinição para: $email'); // Debug log
      await _auth.sendPasswordResetEmail(email: email);
      print('Email de redefinição enviado com sucesso'); // Debug log
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException no reset: ${e.code} - ${e.message}'); // Debug log
      throw _handleAuthException(e);
    } catch (e) {
      print('Erro geral no reset: $e'); // Debug log
      throw 'Erro inesperado ao enviar email: $e';
    }
  }

  // Tratamento de exceções do Firebase Auth
  String _handleAuthException(FirebaseAuthException e) {
    print('Tratando erro Firebase: ${e.code}'); // Debug log
    
    switch (e.code) {
      case 'weak-password':
        return 'A senha é muito fraca. Use pelo menos 6 caracteres.';
      case 'email-already-in-use':
        return 'Este email já está sendo usado por outra conta.';
      case 'invalid-email':
        return 'Email inválido. Verifique se digitou corretamente.';
      case 'user-not-found':
        return 'Usuário não encontrado. Verifique o email digitado.';
      case 'wrong-password':
        return 'Senha incorreta. Tente novamente.';
      case 'user-disabled':
        return 'Esta conta foi desabilitada.';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente mais tarde.';
      case 'operation-not-allowed':
        return 'Operação não permitida. Verifique as configurações do Firebase.';
      case 'network-request-failed':
        return 'Erro de conexão. Verifique sua internet.';
      case 'invalid-credential':
        return 'Credenciais inválidas. Verifique email e senha.';
      default:
        print('Código de erro não tratado: ${e.code}'); // Debug log
        return 'Erro de autenticação: ${e.message ?? e.code}';
    }
  }
}