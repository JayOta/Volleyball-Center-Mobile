import 'package:firebase_auth/firebase_auth.dart';
import 'package:volleyball_center_mobile/services/auth_service.dart';

class UserUtils {
  static final AuthService _authService = AuthService();

  // ✅ Pegar usuário atual básico (Authentication)
  static User? getCurrentUser() {
    return _authService.currentUser;
  }

  // ✅ Verificar se usuário está logado
  static bool isLoggedIn() {
    return _authService.currentUser != null;
  }

  // ✅ Pegar email do usuário
  static String getUserEmail() {
    return _authService.currentUser?.email ?? 'Email não disponível';
  }

  // ✅ Pegar UID do usuário
  static String getUserUID() {
    return _authService.currentUser?.uid ?? '';
  }

  // ✅ Pegar nome do usuário (do Authentication)
  static String getUserDisplayName() {
    return _authService.currentUser?.displayName ?? 'Usuário';
  }

  // ✅ Pegar dados completos do Firestore
  static Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      return await _authService.getUserProfile();
    } catch (e) {
      print('Erro ao buscar perfil: $e');
      return null;
    }
  }

  // ✅ Pegar nome do usuário (prioriza Firestore, fallback para Authentication)
  static Future<String> getUserName() async {
    try {
      final profile = await getUserProfile();
      return profile?['name'] ?? getUserDisplayName();
    } catch (e) {
      return getUserDisplayName();
    }
  }

  // ✅ Fazer saudação personalizada
  static Future<String> getGreeting() async {
    final name = await getUserName();
    final hour = DateTime.now().hour;
    
    String greeting;
    if (hour < 12) {
      greeting = 'Bom dia';
    } else if (hour < 18) {
      greeting = 'Boa tarde';
    } else {
      greeting = 'Boa noite';
    }
    
    return '$greeting, $name!';
  }

  // ✅ Verificar se email está verificado
  static bool isEmailVerified() {
    return _authService.currentUser?.emailVerified ?? false;
  }

  // ✅ Pegar tempo como usuário
  static String getMemberSince() {
    final creationTime = _authService.currentUser?.metadata.creationTime;
    if (creationTime == null) return 'Data não disponível';
    
    final now = DateTime.now();
    final difference = now.difference(creationTime);
    
    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return 'Membro há $years ano${years > 1 ? 's' : ''}';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return 'Membro há $months mês${months > 1 ? 'es' : ''}';
    } else if (difference.inDays > 0) {
      return 'Membro há ${difference.inDays} dia${difference.inDays > 1 ? 's' : ''}';
    } else {
      return 'Novo membro';
    }
  }

  // ✅ Atualizar dados do usuário
  static Future<bool> updateUserProfile(Map<String, dynamic> updates) async {
    try {
      await _authService.updateUserProfile(updates);
      return true;
    } catch (e) {
      print('Erro ao atualizar perfil: $e');
      return false;
    }
  }

  // ✅ Fazer logout
  static Future<void> logout() async {
    await _authService.signOut();
  }
}