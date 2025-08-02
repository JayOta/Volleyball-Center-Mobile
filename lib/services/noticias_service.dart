import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/noticia.dart';

class NoticiasService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'noticias';

  // Criar uma nova notícia
  Future<String> criarNoticia(Noticia noticia) async {
    try {
      print('Criando nova notícia no Firestore...'); // Debug log

      // Converter a notícia para Map e adicionar timestamps
      Map<String, dynamic> noticiaData = noticia.toMap();
      noticiaData['dataPublicacao'] = FieldValue.serverTimestamp();
      noticiaData['dataAtualizacao'] = FieldValue.serverTimestamp();

      DocumentReference docRef = await _firestore
          .collection(_collectionName)
          .add(noticiaData);

      print('Notícia criada com sucesso. ID: ${docRef.id}'); // Debug log
      return docRef.id;
    } on FirebaseException catch (e) {
      print('Erro Firebase ao criar notícia: ${e.code} - ${e.message}'); // Debug log
      throw _handleFirebaseException(e);
    } catch (e) {
      print('Erro geral ao criar notícia: $e'); // Debug log
      throw 'Erro ao criar notícia: $e';
    }
  }

  // Buscar uma notícia por ID
  Future<Noticia?> buscarNoticiaPorId(String id) async {
    try {
      print('Buscando notícia por ID: $id'); // Debug log

      DocumentSnapshot doc = await _firestore
          .collection(_collectionName)
          .doc(id)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final noticia = Noticia.fromMap(doc.id, data);
        print('Notícia encontrada: ${noticia.titulo}'); // Debug log
        return noticia;
      } else {
        print('Notícia não encontrada para ID: $id'); // Debug log
        return null;
      }
    } catch (e) {
      print('Erro ao buscar notícia por ID: $e'); // Debug log
      return null;
    }
  }

  // Buscar todas as notícias ativas
  Future<List<Noticia>> buscarTodasNoticias() async {
    try {
      print('Buscando todas as notícias ativas...'); // Debug log

      QuerySnapshot querySnapshot = await _firestore
          .collection(_collectionName)
          .where('ativo', isEqualTo: true)
          .orderBy('dataPublicacao', descending: true)
          .get();

      List<Noticia> noticias = querySnapshot.docs
          .map((doc) => Noticia.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();

      print('${noticias.length} notícias encontradas'); // Debug log
      return noticias;
    } catch (e) {
      print('Erro ao buscar todas as notícias: $e'); // Debug log
      throw 'Erro ao buscar notícias: $e';
    }
  }

  // Buscar notícias por tag
  Future<List<Noticia>> buscarNoticiasPorTag(String tag) async {
    try {
      print('Buscando notícias por tag: $tag'); // Debug log

      QuerySnapshot querySnapshot = await _firestore
          .collection(_collectionName)
          .where('ativo', isEqualTo: true)
          .where('tags', arrayContains: tag)
          .orderBy('dataPublicacao', descending: true)
          .get();

      List<Noticia> noticias = querySnapshot.docs
          .map((doc) => Noticia.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();

      print('${noticias.length} notícias encontradas para a tag: $tag'); // Debug log
      return noticias;
    } catch (e) {
      print('Erro ao buscar notícias por tag: $e'); // Debug log
      throw 'Erro ao buscar notícias por tag: $e';
    }
  }

  // Buscar notícias por autor
  Future<List<Noticia>> buscarNoticiasPorAutor(String autor) async {
    try {
      print('Buscando notícias por autor: $autor'); // Debug log

      QuerySnapshot querySnapshot = await _firestore
          .collection(_collectionName)
          .where('ativo', isEqualTo: true)
          .where('autor', isEqualTo: autor)
          .orderBy('dataPublicacao', descending: true)
          .get();

      List<Noticia> noticias = querySnapshot.docs
          .map((doc) => Noticia.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();

      print('${noticias.length} notícias encontradas para o autor: $autor'); // Debug log
      return noticias;
    } catch (e) {
      print('Erro ao buscar notícias por autor: $e'); // Debug log
      throw 'Erro ao buscar notícias por autor: $e';
    }
  }

  // Atualizar uma notícia
  Future<void> atualizarNoticia(String id, Map<String, dynamic> updates) async {
    try {
      print('Atualizando notícia: $id'); // Debug log

      // Adicionar timestamp de atualização
      updates['dataAtualizacao'] = FieldValue.serverTimestamp();

      await _firestore
          .collection(_collectionName)
          .doc(id)
          .update(updates);

      print('Notícia atualizada com sucesso'); // Debug log
    } on FirebaseException catch (e) {
      print('Erro Firebase ao atualizar notícia: ${e.code} - ${e.message}'); // Debug log
      throw _handleFirebaseException(e);
    } catch (e) {
      print('Erro geral ao atualizar notícia: $e'); // Debug log
      throw 'Erro ao atualizar notícia: $e';
    }
  }

  // Incrementar visualizações
  Future<void> incrementarVisualizacoes(String id) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(id)
          .update({
        'visualizacoes': FieldValue.increment(1),
      });
    } catch (e) {
      print('Erro ao incrementar visualizações: $e'); // Debug log
      // Não lançar erro para não quebrar a experiência do usuário
    }
  }

  // Deletar uma notícia (soft delete)
  Future<void> deletarNoticia(String id) async {
    try {
      print('Deletando notícia (soft delete): $id'); // Debug log

      await _firestore
          .collection(_collectionName)
          .doc(id)
          .update({
        'ativo': false,
        'dataAtualizacao': FieldValue.serverTimestamp(),
      });

      print('Notícia deletada com sucesso (soft delete)'); // Debug log
    } on FirebaseException catch (e) {
      print('Erro Firebase ao deletar notícia: ${e.code} - ${e.message}'); // Debug log
      throw _handleFirebaseException(e);
    } catch (e) {
      print('Erro geral ao deletar notícia: $e'); // Debug log
      throw 'Erro ao deletar notícia: $e';
    }
  }

  // Deletar uma notícia permanentemente
  Future<void> deletarNoticiaPermanentemente(String id) async {
    try {
      print('Deletando notícia permanentemente: $id'); // Debug log

      await _firestore
          .collection(_collectionName)
          .doc(id)
          .delete();

      print('Notícia deletada permanentemente'); // Debug log
    } on FirebaseException catch (e) {
      print('Erro Firebase ao deletar notícia permanentemente: ${e.code} - ${e.message}'); // Debug log
      throw _handleFirebaseException(e);
    } catch (e) {
      print('Erro geral ao deletar notícia permanentemente: $e'); // Debug log
      throw 'Erro ao deletar notícia: $e';
    }
  }

  // Buscar notícias mais visualizadas
  Future<List<Noticia>> buscarNoticiasMaisVisualizadas({int limite = 10}) async {
    try {
      print('Buscando notícias mais visualizadas...'); // Debug log

      QuerySnapshot querySnapshot = await _firestore
          .collection(_collectionName)
          .where('ativo', isEqualTo: true)
          .orderBy('visualizacoes', descending: true)
          .limit(limite)
          .get();

      List<Noticia> noticias = querySnapshot.docs
          .map((doc) => Noticia.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();

      print('${noticias.length} notícias mais visualizadas encontradas'); // Debug log
      return noticias;
    } catch (e) {
      print('Erro ao buscar notícias mais visualizadas: $e'); // Debug log
      throw 'Erro ao buscar notícias mais visualizadas: $e';
    }
  }

  // Buscar notícias recentes
  Future<List<Noticia>> buscarNoticiasRecentes({int limite = 10}) async {
    try {
      print('Buscando notícias recentes...'); // Debug log

      QuerySnapshot querySnapshot = await _firestore
          .collection(_collectionName)
          .where('ativo', isEqualTo: true)
          .orderBy('dataPublicacao', descending: true)
          .limit(limite)
          .get();

      List<Noticia> noticias = querySnapshot.docs
          .map((doc) => Noticia.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();

      print('${noticias.length} notícias recentes encontradas'); // Debug log
      return noticias;
    } catch (e) {
      print('Erro ao buscar notícias recentes: $e'); // Debug log
      throw 'Erro ao buscar notícias recentes: $e';
    }
  }

  // Stream de notícias em tempo real
  Stream<List<Noticia>> streamNoticias() {
    return _firestore
        .collection(_collectionName)
        .where('ativo', isEqualTo: true)
        .orderBy('dataPublicacao', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Noticia.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  // Tratamento de exceções do Firebase
  String _handleFirebaseException(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return 'Erro de permissão: Verifique as regras de segurança do Firestore.';
      case 'not-found':
        return 'Notícia não encontrada no Firestore.';
      case 'already-exists':
        return 'Notícia já existe no Firestore.';
      case 'unavailable':
        return 'Firestore temporariamente indisponível. Tente novamente.';
      case 'invalid-argument':
        return 'Dados inválidos fornecidos para a notícia.';
      default:
        return 'Erro do Firebase: ${e.message}';
    }
  }
}