// lib/services/firestore_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Importa o modelo News que você atualizou
import 'package:volleyball_center_mobile/models/news.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _newsCollection = 'news'; // Coleção de Notícias

  // -----------------------------------------------------------------
  //                           CRUD DE NOTÍCIAS (ATUALIZADO)
  // -----------------------------------------------------------------

  // C: Criar Notícia
  // Recebe o objeto News para incluir todos os campos, inclusive imageUrl
  Future<void> addNews(News news) async {
    try {
      // Cria um Map para salvar no Firestore, usando FieldValue.serverTimestamp()
      final Map<String, dynamic> data = {
        'title': news.title,
        'content': news.content,
        'authorUid': FirebaseAuth.instance.currentUser!.uid,
        'imageUrl': news.imageUrl, // NOVO: URL da imagem
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection(_newsCollection).add(data);
    } catch (e) {
      print("Erro ao adicionar notícia: $e");
      throw 'Erro ao criar notícia: $e';
    }
  }

  // R: Buscar Todas as Notícias (para o Admin)
  Future<List<Map<String, dynamic>>> getAllNews() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_newsCollection)
          .orderBy('createdAt', descending: true)
          .get();

      // Mapeia os documentos para List<Map<String, dynamic>>, injetando o 'id'
      return querySnapshot.docs
          .map((doc) => {...doc.data() as Map<String, dynamic>, 'id': doc.id})
          .toList();
    } catch (e) {
      print("Erro ao buscar notícias: $e");
      throw 'Erro ao buscar notícias: $e';
    }
  }

  // U: Atualizar Notícia
  // Recebe o objeto News, obtém o ID e os campos de atualização
  Future<void> updateNews(News news) async {
    try {
      final Map<String, dynamic> updates = {
        'title': news.title,
        'content': news.content,
        'imageUrl': news.imageUrl, // NOVO: URL da imagem
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection(_newsCollection).doc(news.id).update(updates);
    } catch (e) {
      print("Erro ao atualizar notícia: $e");
      throw 'Erro ao atualizar notícia: $e';
    }
  }

  // D: Deletar Notícia
  // Agora só precisa do ID (o delete da imagem é feito no AdminNewsView)
  Future<void> deleteNews(String newsId) async {
    try {
      await _firestore.collection(_newsCollection).doc(newsId).delete();
    } catch (e) {
      print("Erro ao deletar notícia: $e");
      throw 'Erro ao deletar notícia: $e';
    }
  }

  // -----------------------------------------------------------------
  //                           CRUD DE USUÁRIOS
  // -----------------------------------------------------------------

  // Criar perfil do usuário no Firestore
  Future<void> createUserProfile({
    required String uid,
    required String name,
    required String email,
  }) async {
    try {
      // Debug log

      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isActive': true,
      });

      // Debug log
    } on FirebaseException catch (e) {
      // Debug log

      if (e.code == 'permission-denied') {
        throw 'Erro de permissão: Verifique as regras de segurança do Firestore. As regras atuais não permitem escrita para usuários autenticados.';
      } else if (e.code == 'unavailable') {
        throw 'Firestore temporariamente indisponível. Tente novamente.';
      } else {
        throw 'Erro do Firebase: ${e.message}';
      }
    } catch (e) {
      // Debug log
      throw 'Erro ao salvar dados do usuário: $e';
    }
  }

  // Buscar perfil do usuário
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      // Debug log

      if (uid.isEmpty) {
        // Debug log
        return null;
      }

      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();

      // Debug log

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>?;
        // Debug log
        return data;
      } else {
        // Debug log
        return null;
      }
    } catch (e) {
      // Debug log
      // Debug stack trace
      return null; // Retorna null em vez de throw para não quebrar o app
    }
  }

  // Atualizar perfil do usuário
  Future<void> updateUserProfile({
    required String uid,
    required Map<String, dynamic> updates, // Tornamos 'updates' obrigatório
  }) async {
    try {
      // Seu código anterior já tratava o 'updates != null',
      // mas ao torná-lo 'required', podemos simplificar.
      updates['updatedAt'] = FieldValue.serverTimestamp();

      await _firestore.collection('users').doc(uid).update(updates);
      // Debug log
    } on FirebaseException catch (e) {
      // Debug log

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
      // Debug log
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

      // Debug log
    } catch (e) {
      // Debug log
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
      // Debug log
      throw 'Erro ao buscar usuários: $e';
    }
  }

  // Verificar se o usuário existe no Firestore
  Future<bool> userExists(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      return doc.exists;
    } catch (e) {
      // Debug log
      return false;
    }
  }
}
