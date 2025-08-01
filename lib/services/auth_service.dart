import 'package:firebase_auth/firebase_auth.dart';
import 'package:volleyball_center_mobile/services/firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  // Stream para ouvir mudanças no estado de autenticação
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Usuário atual
  User? get currentUser => _auth.currentUser;

  // Cadastro com email e senha
  Future<UserCredential?> registerWithEmailAndPassword(
      String email, String password, {String? displayName}) async {
    try {
      print('Tentando criar usuário com email: $email'); // Debug log
      
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      print('Usuário criado com sucesso: ${result.user?.uid}'); // Debug log
      
      // Salvar perfil no Firestore se fornecido o nome
      if (result.user != null && displayName != null && displayName.isNotEmpty) {
        await _firestoreService.createUserProfile(
          uid: result.user!.uid,
          name: displayName,
          email: email,
        );
        print('Dados do usuário salvos no Firestore'); // Debug log
      }
      
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
      
      // Verificar se o usuário existe no Firestore, se não, criar
      if (result.user != null) {
        bool userExists = await _firestoreService.userExists(result.user!.uid);
        if (!userExists) {
          await _firestoreService.createUserProfile(
            uid: result.user!.uid,
            name: result.user!.displayName ?? 'Usuário',
            email: result.user!.email ?? email,
          );
          print('Perfil criado no Firestore para usuário existente'); // Debug log
        }
      }
      
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
      
      // Atualizar também no Firestore
      if (currentUser != null) {
        await _firestoreService.updateUserProfile(
          uid: currentUser!.uid,
          updates: {'name': displayName},
        );
      }
      
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

  // Buscar perfil completo do usuário do Firestore
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      print('AuthService: Buscando perfil do usuário...'); // Debug log
      
      if (currentUser == null) {
        print('AuthService: Usuário não está logado'); // Debug log
        return null;
      }
      
      print('AuthService: UID do usuário: ${currentUser!.uid}'); // Debug log
      
      final profile = await _firestoreService.getUserProfile(currentUser!.uid);
      
      print('AuthService: Perfil retornado: $profile'); // Debug log
      
      return profile;
    } catch (e) {
      print('AuthService: Erro ao buscar perfil do usuário: $e'); // Debug log
      print('AuthService: Stack trace: ${StackTrace.current}'); // Debug stack trace
      return null;
    }
  }

  // Atualizar perfil completo
  Future<void> updateUserProfile(Map<String, dynamic> updates) async {
    try {
      if (currentUser != null) {
        await _firestoreService.updateUserProfile(
          uid: currentUser!.uid,
          updates: updates,
        );
      }
    } catch (e) {
      print('Erro ao atualizar perfil: $e'); // Debug log
      throw 'Erro ao atualizar perfil: $e';
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