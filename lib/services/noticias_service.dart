import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:volleyball_center_mobile/models/noticia_model.dart';

class NoticiasService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Coleção de notícias
  CollectionReference get _noticiasCollection => _firestore.collection('noticias');

  // Criar nova notícia
  Future<String> criarNoticia({
    required String titulo,
    required String conteudo,
    required String resumo,
    String imagemUrl = '',
    List<String> tags = const [],
  }) async {
    try {
      print('Criando nova notícia: $titulo'); // Debug log

      final usuario = _auth.currentUser;
      if (usuario == null) {
        throw 'Usuário não está logado';
      }

      final noticiaData = {
        'titulo': titulo,
        'conteudo': conteudo,
        'resumo': resumo,
        'imagemUrl': imagemUrl,
        'autor': usuario.displayName ?? usuario.email ?? 'Autor Desconhecido',
        'autorId': usuario.uid,
        'dataPublicacao': FieldValue.serverTimestamp(),
        'dataAtualizacao': FieldValue.serverTimestamp(),
        'tags': tags,
        'ativo': true,
        'visualizacoes': 0,
      };

      final docRef = await _noticiasCollection.add(noticiaData);
      print('Notícia criada com sucesso: ${docRef.id}'); // Debug log

      return docRef.id;
    } catch (e) {
      print('Erro ao criar notícia: $e'); // Debug log
      throw 'Erro ao criar notícia: $e';
    }
  }

  // Buscar todas as notícias ativas (ordenadas por data)
  Future<List<NoticiaModel>> buscarNoticiasAtivas() async {
    try {
      print('Buscando notícias ativas...'); // Debug log

      final querySnapshot = await _noticiasCollection
          .where('ativo', isEqualTo: true)
          .orderBy('dataPublicacao', descending: true)
          .get();

      final noticias = querySnapshot.docs
          .map((doc) => NoticiaModel.fromFirestore(doc))
          .toList();

      print('${noticias.length} notícias encontradas'); // Debug log
      return noticias;
    } catch (e) {
      print('Erro ao buscar notícias: $e'); // Debug log
      throw 'Erro ao buscar notícias: $e';
    }
  }

  // Buscar notícias com paginação
  Future<List<NoticiaModel>> buscarNoticiasPaginadas({
    int limite = 10,
    DocumentSnapshot? ultimoDoc,
  }) async {
    try {
      Query query = _noticiasCollection
          .where('ativo', isEqualTo: true)
          .orderBy('dataPublicacao', descending: true)
          .limit(limite);

      if (ultimoDoc != null) {
        query = query.startAfterDocument(ultimoDoc);
      }

      final querySnapshot = await query.get();
      
      return querySnapshot.docs
          .map((doc) => NoticiaModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Erro ao buscar notícias paginadas: $e'); // Debug log
      throw 'Erro ao buscar notícias paginadas: $e';
    }
  }

  // Buscar notícia por ID
  Future<NoticiaModel?> buscarNoticiaPorId(String id) async {
    try {
      print('Buscando notícia por ID: $id'); // Debug log

      final doc = await _noticiasCollection.doc(id).get();
      
      if (doc.exists) {
        return NoticiaModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Erro ao buscar notícia por ID: $e'); // Debug log
      throw 'Erro ao buscar notícia: $e';
    }
  }

  // Atualizar notícia
  Future<void> atualizarNoticia(String id, Map<String, dynamic> dados) async {
    try {
      print('Atualizando notícia: $id'); // Debug log

      dados['dataAtualizacao'] = FieldValue.serverTimestamp();
      
      await _noticiasCollection.doc(id).update(dados);
      print('Notícia atualizada com sucesso'); // Debug log
    } catch (e) {
      print('Erro ao atualizar notícia: $e'); // Debug log
      throw 'Erro ao atualizar notícia: $e';
    }
  }

  // Deletar notícia (soft delete)
  Future<void> deletarNoticia(String id) async {
    try {
      print('Deletando notícia: $id'); // Debug log

      await _noticiasCollection.doc(id).update({
        'ativo': false,
        'dataAtualizacao': FieldValue.serverTimestamp(),
      });

      print('Notícia deletada com sucesso'); // Debug log
    } catch (e) {
      print('Erro ao deletar notícia: $e'); // Debug log
      throw 'Erro ao deletar notícia: $e';
    }
  }

  // Incrementar visualizações
  Future<void> incrementarVisualizacoes(String id) async {
    try {
      await _noticiasCollection.doc(id).update({
        'visualizacoes': FieldValue.increment(1),
      });
    } catch (e) {
      print('Erro ao incrementar visualizações: $e'); // Debug log
      // Não lança erro pois não é crítico
    }
  }

  // Buscar notícias por tag
  Future<List<NoticiaModel>> buscarNoticiasPorTag(String tag) async {
    try {
      print('Buscando notícias por tag: $tag'); // Debug log

      final querySnapshot = await _noticiasCollection
          .where('ativo', isEqualTo: true)
          .where('tags', arrayContains: tag)
          .orderBy('dataPublicacao', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => NoticiaModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Erro ao buscar notícias por tag: $e'); // Debug log
      throw 'Erro ao buscar notícias por tag: $e';
    }
  }

  // Buscar notícias por texto (título ou resumo)
  Future<List<NoticiaModel>> buscarNoticiasPorTexto(String texto) async {
    try {
      print('Buscando notícias por texto: $texto'); // Debug log

      // Firestore não suporta busca full-text nativa, então fazemos duas consultas
      final tituloQuery = await _noticiasCollection
          .where('ativo', isEqualTo: true)
          .where('titulo', isGreaterThanOrEqualTo: texto)
          .where('titulo', isLessThanOrEqualTo: texto + '\uf8ff')
          .get();

      final resumoQuery = await _noticiasCollection
          .where('ativo', isEqualTo: true)
          .where('resumo', isGreaterThanOrEqualTo: texto)
          .where('resumo', isLessThanOrEqualTo: texto + '\uf8ff')
          .get();

      // Combinar resultados e remover duplicatas
      final Map<String, NoticiaModel> resultados = {};
      
      for (final doc in tituloQuery.docs) {
        resultados[doc.id] = NoticiaModel.fromFirestore(doc);
      }
      
      for (final doc in resumoQuery.docs) {
        resultados[doc.id] = NoticiaModel.fromFirestore(doc);
      }

      final noticias = resultados.values.toList();
      noticias.sort((a, b) => b.dataPublicacao.compareTo(a.dataPublicacao));

      return noticias;
    } catch (e) {
      print('Erro ao buscar notícias por texto: $e'); // Debug log
      throw 'Erro ao buscar notícias: $e';
    }
  }

  // Stream para escutar mudanças em tempo real
  Stream<List<NoticiaModel>> escutarNoticiasAtivas() {
    return _noticiasCollection
        .where('ativo', isEqualTo: true)
        .orderBy('dataPublicacao', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NoticiaModel.fromFirestore(doc))
            .toList());
  }

  // Buscar todas as tags disponíveis
  Future<List<String>> buscarTodasTags() async {
    try {
      final querySnapshot = await _noticiasCollection
          .where('ativo', isEqualTo: true)
          .get();

      final Set<String> todasTags = {};
      
      for (final doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final tags = List<String>.from(data['tags'] ?? []);
        todasTags.addAll(tags);
      }

      final listaTagsOrdenada = todasTags.toList()..sort();
      return listaTagsOrdenada;
    } catch (e) {
      print('Erro ao buscar tags: $e'); // Debug log
      throw 'Erro ao buscar tags: $e';
    }
  }
}