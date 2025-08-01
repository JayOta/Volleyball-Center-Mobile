import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Criar perfil do usuário no Firestore
  Future<void> createUserProfile({
    required String uid,
    required String name,
    required String email,
  }) async {
    try {
      print('Criando perfil do usuário no Firestore...'); // Debug log
      
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isActive': true,
      });
      
      print('Perfil do usuário criado com sucesso no Firestore'); // Debug log
    } on FirebaseException catch (e) {
      print('Erro Firebase ao criar perfil: ${e.code} - ${e.message}'); // Debug log
      
      if (e.code == 'permission-denied') {
        throw 'Erro de permissão: Verifique as regras de segurança do Firestore. As regras atuais não permitem escrita para usuários autenticados.';
      } else if (e.code == 'unavailable') {
        throw 'Firestore temporariamente indisponível. Tente novamente.';
      } else {
        throw 'Erro do Firebase: ${e.message}';
      }
    } catch (e) {
      print('Erro geral ao criar perfil do usuário no Firestore: $e'); // Debug log
      throw 'Erro ao salvar dados do usuário: $e';
    }
  }

  // Buscar perfil do usuário
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      print('Buscando perfil do usuário no Firestore: $uid'); // Debug log
      
      if (uid.isEmpty) {
        print('UID está vazio'); // Debug log
        return null;
      }
      
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      
      print('Documento existe: ${doc.exists}'); // Debug log
      
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>?;
        print('Dados encontrados: $data'); // Debug log
        return data;
      } else {
        print('Documento não existe para UID: $uid'); // Debug log
        return null;
      }
    } catch (e) {
      print('Erro ao buscar perfil do usuário: $e'); // Debug log
      print('Stack trace: ${StackTrace.current}'); // Debug stack trace
      return null; // Retorna null em vez de throw para não quebrar o app
    }
  }

  // Atualizar perfil do usuário
  Future<void> updateUserProfile({
    required String uid,
    Map<String, dynamic>? updates,
  }) async {
    try {
      if (updates != null) {
        updates['updatedAt'] = FieldValue.serverTimestamp();
        
        await _firestore.collection('users').doc(uid).update(updates);
        print('Perfil do usuário atualizado com sucesso'); // Debug log
      }
    } on FirebaseException catch (e) {
      print('Erro Firebase ao atualizar perfil: ${e.code} - ${e.message}'); // Debug log
      
      if (e.code == 'permission-denied') {
        throw 'Erro de permissão: As regras do Firestore não permitem atualização para este usuário. Configure as regras de segurança.';
      } else if (e.code == 'not-found') {
        throw 'Perfil do usuário não encontrado no Firestore.';
      } else if (e.code == 'unavailable') {
        throw 'Firestore temporariamente indisponível. Tente novamente.';
      } else {
        throw 'Erro do Firebase: ${e.message}';
      }
    } catch (e) {
      print('Erro geral ao atualizar perfil do usuário: $e'); // Debug log
      throw 'Erro ao atualizar dados do usuário: $e';
    }
  }

  // Deletar perfil do usuário (soft delete)
  Future<void> deleteUserProfile(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'isActive': false,
        'deletedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      print('Perfil do usuário deletado (soft delete)'); // Debug log
    } catch (e) {
      print('Erro ao deletar perfil do usuário: $e'); // Debug log
      throw 'Erro ao deletar dados do usuário: $e';
    }
  }

  // Buscar todos os usuários (para admin)
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Erro ao buscar todos os usuários: $e'); // Debug log
      throw 'Erro ao buscar usuários: $e';
    }
  }

  // Verificar se o usuário existe no Firestore
  Future<bool> userExists(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      return doc.exists;
    } catch (e) {
      print('Erro ao verificar se usuário existe: $e'); // Debug log
      return false;
    }
  }
}