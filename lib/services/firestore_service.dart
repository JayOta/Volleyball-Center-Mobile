// lib/services/firestore_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Importa o modelo News que você atualizou
import 'package:volleyball_center_mobile/models/news.dart'; // Certifique-se que o caminho está correto

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Coleções no Firestore
  final CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('products');
  final CollectionReference newsCollection =
      FirebaseFirestore.instance.collection('news');
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  // ====================================
  // FUNÇÕES DE PRODUTOS (LOJA/CARROSSEL)
  // ====================================

  // READ: LER PRODUTOS EM DESTAQUE (Para o Carrossel da Home) - ⭐️ ADICIONADO AQUI!
  Future<List<Map<String, dynamic>>> getFeaturedProducts(int limit) async {
    try {
      final snapshot = await productsCollection
          // Ordena por um campo relevante (name, ou um campo 'isFeatured' se existir)
          .orderBy('name', descending: false)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        // Prepara o preço formatado
        if (data['price'] is num) {
          data['preco_formatado'] =
              'R\$ ${data['price'].toStringAsFixed(2).replaceAll('.', ',')}';
        } else {
          data['preco_formatado'] = 'R\$ --';
        }
        return data;
      }).toList();
    } catch (e) {
      print("Erro ao carregar produtos em destaque: $e");
      return [];
    }
  }

  // READ: LER TODOS OS PRODUTOS (Para a Loja)
  Stream<List<Map<String, dynamic>>> getProductsStream() {
    return productsCollection
        .orderBy('name', descending: false) // Ordena por nome
        .snapshots() // Recebe atualizações em tempo real
        .map((snapshot) {
      // Mapeia os documentos para uma lista de Maps, incluindo o ID
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        // Conversão de preço
        if (data['price'] is num) {
          data['preco'] =
              'R\$ ${data['price'].toStringAsFixed(2).replaceAll('.', ',')}';
        }
        return data;
      }).toList();
    });
  }

  // CREATE/UPDATE: ADICIONAR OU ATUALIZAR PRODUTO (Para o Admin)
  Future<void> saveProduct(Map<String, dynamic> productData,
      {String? docId}) async {
    // Manter lógica de mapeamento se for necessária (verifique o seu AdminForm)
    // productData['image_url'] = productData['imagem'];
    // productData['name'] = productData['nome'];

    if (docId != null && docId.isNotEmpty) {
      // Update
      await productsCollection.doc(docId).update(productData);
    } else {
      // Create
      await productsCollection.add({
        ...productData,
        'created_at': FieldValue.serverTimestamp(),
      });
    }
  }

  // DELETE: DELETAR PRODUTO (Para o Admin)
  Future<void> deleteProduct(String docId) {
    return productsCollection.doc(docId).delete();
  }

  // ====================================
  // FUNÇÕES DE NOTÍCIAS (HOME/NOTICIAS)
  // ====================================

  // C: Criar Notícia
  Future<void> addNews(News news) async {
    try {
      final Map<String, dynamic> data = {
        'title': news.title,
        'content': news.content,
        'authorUid': FirebaseAuth.instance.currentUser!.uid,
        'imageUrl': news.imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };
      await newsCollection.add(data);
    } catch (e) {
      print("Erro ao adicionar notícia: $e");
      throw 'Erro ao criar notícia: $e';
    }
  }

  // R: Buscar Todas as Notícias (HOME/NOTICIAS)
  // Usa newsCollection que já está definido
  Future<List<Map<String, dynamic>>> getAllNews() async {
    try {
      QuerySnapshot querySnapshot =
          await newsCollection.orderBy('createdAt', descending: true).get();

      return querySnapshot.docs
          .map((doc) => {...doc.data() as Map<String, dynamic>, 'id': doc.id})
          .toList();
    } catch (e) {
      print("Erro ao buscar notícias: $e");
      throw 'Erro ao buscar notícias: $e';
    }
  }

  // U: Atualizar Notícia
  Future<void> updateNews(News news) async {
    try {
      final Map<String, dynamic> updates = {
        'title': news.title,
        'content': news.content,
        'imageUrl': news.imageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      await newsCollection.doc(news.id).update(updates);
    } catch (e) {
      print("Erro ao atualizar notícia: $e");
      throw 'Erro ao atualizar notícia: $e';
    }
  }

  // D: Deletar Notícia
  Future<void> deleteNews(String newsId) async {
    try {
      await newsCollection.doc(newsId).delete();
    } catch (e) {
      print("Erro ao deletar notícia: $e");
      throw 'Erro ao deletar notícia: $e';
    }
  }

  // ====================================
  // FUNÇÕES DE USUÁRIOS (ADMIN/PERFIL)
  // ====================================

  // READ: LER TODOS OS USUÁRIOS (Stream para Admin) - ⭐️ ADICIONADO AQUI!
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return usersCollection
        .orderBy('email', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  // Criar perfil do usuário no Firestore
  Future<void> createUserProfile({
    required String uid,
    required String name,
    required String email,
  }) async {
    try {
      await usersCollection.doc(uid).set({
        'uid': uid,
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isActive': true,
      });
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        throw 'Erro de permissão: Verifique as regras de segurança do Firestore.';
      } else {
        throw 'Erro do Firebase: ${e.message}';
      }
    } catch (e) {
      throw 'Erro ao salvar dados do usuário: $e';
    }
  }

  // Buscar perfil do usuário
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      if (uid.isEmpty) return null;
      DocumentSnapshot doc = await usersCollection.doc(uid).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // Atualizar perfil do usuário
  Future<void> updateUserProfile({
    required String uid,
    required Map<String, dynamic> updates,
  }) async {
    try {
      updates['updatedAt'] = FieldValue.serverTimestamp();
      await usersCollection.doc(uid).update(updates);
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        throw 'Erro de permissão: As regras do Firestore não permitem atualização.';
      } else {
        throw 'Erro do Firebase: ${e.message}';
      }
    } catch (e) {
      throw 'Erro ao atualizar dados do usuário: $e';
    }
  }

  // Deletar perfil do usuário (soft delete)
  Future<void> deleteUserProfile(String uid) async {
    try {
      await usersCollection.doc(uid).update({
        'isActive': false,
        'deletedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Erro ao deletar dados do usuário: $e';
    }
  }

  // Buscar todos os usuários (para admin)
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      QuerySnapshot querySnapshot = await usersCollection
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      throw 'Erro ao buscar usuários: $e';
    }
  }

  // Verificar se o usuário existe no Firestore
  Future<bool> userExists(String uid) async {
    try {
      DocumentSnapshot doc = await usersCollection.doc(uid).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }
}
