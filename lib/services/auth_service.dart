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
      String email, String password,
      {String? displayName}) async {
    try {
      // Debug log

      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Debug log

      if (result.user != null) {
        // 1. Definir displayName no Authentication primeiro
        if (displayName != null && displayName.isNotEmpty) {
          // Debug log
          await result.user!.updateDisplayName(displayName);
          await result.user!.reload();
          // Debug log
        }

        // 2. Criar perfil no Firestore (com retry em caso de falha)
        if (displayName != null && displayName.isNotEmpty) {
          try {
            await _firestoreService.createUserProfile(
              uid: result.user!.uid,
              name: displayName,
              email: email,
            );
            // Debug log
          } catch (firestoreError) {
            // Debug log
            // Não falha todo o processo se Firestore der erro
            // O usuário ainda pode fazer login e o perfil pode ser criado depois
          }
        }
      }

      return result;
    } on FirebaseAuthException catch (e) {
      // Debug log
      throw _handleAuthException(e);
    } catch (e) {
      // Debug log
      throw 'Erro inesperado ao criar conta: $e';
    }
  }

  // Login com email e senha
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      // Debug log

      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Debug log

      // Verificar se o usuário existe no Firestore, se não, criar
      if (result.user != null) {
        bool userExists = await _firestoreService.userExists(result.user!.uid);
        if (!userExists) {
          await _firestoreService.createUserProfile(
            uid: result.user!.uid,
            name: result.user!.displayName ?? 'Usuário',
            email: result.user!.email ?? email,
          );
          // Debug log
        }
      }

      return result;
    } on FirebaseAuthException catch (e) {
      // Debug log
      throw _handleAuthException(e);
    } catch (e) {
      // Debug log
      throw 'Erro inesperado no login: $e';
    }
  }

  // Logout
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      // Debug log
    } catch (e) {
      // Debug log
      throw 'Erro ao fazer logout: $e';
    }
  }

  // RENOMEADO: Método updateUserName para corresponder à chamada no editar_perfil.dart
  Future<void> updateUserName(String newName) async {
    // Reutiliza a lógica existente, garantindo a atualização em Auth e Firestore
    return updateDisplayName(newName);
  }

  // Lógica de atualização de nome (método original)
  Future<void> updateDisplayName(String displayName) async {
    try {
      // Debug log

      if (currentUser == null) {
        throw 'Usuário não está logado';
      }

      // Atualizar no Authentication
      await currentUser!.updateDisplayName(displayName);
      await currentUser!.reload(); // Recarrega os dados do usuário
      // Debug log

      // Verificar se o perfil existe no Firestore
      bool userExists = await _firestoreService.userExists(currentUser!.uid);

      if (userExists) {
        // Se existe, atualizar
        await _firestoreService.updateUserProfile(
          uid: currentUser!.uid,
          updates: {'name': displayName},
        );
        // Debug log
      } else {
        // Se não existe, criar perfil completo
        await _firestoreService.createUserProfile(
          uid: currentUser!.uid,
          name: displayName,
          email: currentUser!.email ?? 'email@desconhecido.com',
        );
        // Debug log
      }

      // Debug log
    } catch (e) {
      // Debug log
      throw 'Erro ao atualizar nome: $e';
    }
  }

  // NOVO: Atualizar EMAIL do Usuário
  Future<void> updateUserEmail(String newEmail) async {
    try {
      // Debug log

      if (currentUser == null) {
        throw 'Usuário não está logado';
      }

      // 1. Atualizar no Firebase Authentication
      await currentUser!.updateEmail(newEmail);
      await currentUser!.reload();
      // Debug log

      // 2. Atualizar no Firestore
      await _firestoreService.updateUserProfile(
        uid: currentUser!.uid,
        updates: {'email': newEmail},
      );
      // Debug log

      // Debug log
    } on FirebaseAuthException catch (e) {
      // Debug log
      throw _handleAuthException(e);
    } catch (e) {
      // Debug log
      throw 'Erro ao atualizar email: $e';
    }
  }

  // NOVO: Método para Reautenticar o usuário
  Future<void> reauthenticateUser(String password) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw 'Usuário não está logado.';
    }

    if (user.email == null) {
      throw 'Não é possível reautenticar. O usuário não possui um email.';
    }

    try {
      // Debug log

      // Cria a credencial usando o email e a senha fornecida
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      // Tenta reautenticar o usuário atual
      await user.reauthenticateWithCredential(credential);

      // Debug log
    } on FirebaseAuthException catch (e) {
      // Debug log
      // Lançamos a exceção tratada para que o widget possa exibir a mensagem
      throw _handleAuthException(e);
    } catch (e) {
      // Debug log
      throw 'Erro inesperado na reautenticação: $e';
    }
  }

  // NOVO: Atualizar SENHA do Usuário
  Future<void> updatePassword(String newPassword) async {
    try {
      // Debug log

      if (currentUser == null) {
        throw 'Usuário não está logado';
      }

      // O Firebase tratará a reautenticação se necessária.
      await currentUser!.updatePassword(newPassword);
      // Debug log
    } on FirebaseAuthException catch (e) {
      // Debug log
      if (e.code == 'requires-recent-login') {
        // Mensagem clara para o usuário
        throw 'Sua sessão expirou. Por favor, saia (logout) e entre (login) novamente para alterar sua senha.';
      }
      throw _handleAuthException(e);
    } catch (e) {
      // Debug log
      throw 'Erro ao atualizar senha: $e';
    }
  }

  // Redefinir senha (Enviar email de reset)
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      // Debug log
      await _auth.sendPasswordResetEmail(email: email);
      // Debug log
    } on FirebaseAuthException catch (e) {
      // Debug log
      throw _handleAuthException(e);
    } catch (e) {
      // Debug log
      throw 'Erro inesperado ao enviar email: $e';
    }
  }

  // Buscar perfil completo do usuário do Firestore
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      // Debug log

      if (currentUser == null) {
        // Debug log
        return null;
      }

      // Debug log

      final profile = await _firestoreService.getUserProfile(currentUser!.uid);

      // Debug log

      return profile;
    } catch (e) {
      // Debug log
      // Debug stack trace
      return null;
    }
  }

  // Atualizar perfil completo (Chama o método do FirestoreService)
  Future<void> updateUserProfile(Map<String, dynamic> updates) async {
    try {
      if (currentUser != null) {
        await _firestoreService.updateUserProfile(
          uid: currentUser!.uid,
          updates: updates,
        );
      }
    } catch (e) {
      // Debug log
      throw 'Erro ao atualizar perfil: $e';
    }
  }

  // Tratamento de exceções do Firebase Auth
  String _handleAuthException(FirebaseAuthException e) {
    // Debug log

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
        // Debug log
        return 'Erro de autenticação: ${e.message ?? e.code}';
    }
  }
}
