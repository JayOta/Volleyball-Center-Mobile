import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHelper {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Exemplo: Adicionar um documento
  static Future<String> addDocument(String collection, Map<String, dynamic> data) async {
    try {
      DocumentReference docRef = await _db.collection(collection).add(data);
      return docRef.id;
    } catch (e) {
      throw Exception('Erro ao adicionar documento: $e');
    }
  }

  // Exemplo: Buscar todos os documentos de uma coleção
  static Future<List<Map<String, dynamic>>> getDocuments(String collection) async {
    try {
      QuerySnapshot querySnapshot = await _db.collection(collection).get();
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Adiciona o ID do documento
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Erro ao buscar documentos: $e');
    }
  }

  // Exemplo: Buscar um documento específico
  static Future<Map<String, dynamic>?> getDocument(String collection, String docId) async {
    try {
      DocumentSnapshot doc = await _db.collection(collection).doc(docId).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao buscar documento: $e');
    }
  }

  // Exemplo: Atualizar um documento
  static Future<void> updateDocument(String collection, String docId, Map<String, dynamic> data) async {
    try {
      await _db.collection(collection).doc(docId).update(data);
    } catch (e) {
      throw Exception('Erro ao atualizar documento: $e');
    }
  }

  // Exemplo: Deletar um documento
  static Future<void> deleteDocument(String collection, String docId) async {
    try {
      await _db.collection(collection).doc(docId).delete();
    } catch (e) {
      throw Exception('Erro ao deletar documento: $e');
    }
  }

  // Exemplo: Stream para escutar mudanças em tempo real
  static Stream<List<Map<String, dynamic>>> streamDocuments(String collection) {
    return _db.collection(collection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  // Exemplo específico para posts (baseado no seu código atual)
  static Future<String> addPost(String title, String body) async {
    return await addDocument('posts', {
      'title': title,
      'body': body,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<List<Map<String, dynamic>>> getPosts() async {
    return await getDocuments('posts');
  }

  static Stream<List<Map<String, dynamic>>> streamPosts() {
    return streamDocuments('posts');
  }
}