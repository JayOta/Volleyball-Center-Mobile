// lib/models/news.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class News {
  final String id;
  final String title;
  final String content; // O corpo completo da notícia
  final String authorUid; // ID do admin que criou a notícia
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final String? imageUrl; // NOVO CAMPO: URL da imagem

  News({
    required this.id,
    required this.title,
    required this.content,
    required this.authorUid,
    required this.createdAt,
    required this.updatedAt,
    this.imageUrl, // Adicionado aqui
  });

  // Factory para criar News diretamente de um Map (usado no AdminNewsView e Noticias)
  factory News.fromMap(Map<String, dynamic> data) {
    return News(
      id: data['id'] ?? '', // O 'id' é injetado no map pelo getAllNews
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      authorUid: data['authorUid'] ?? '',
      createdAt: data['createdAt'] as Timestamp? ?? Timestamp.now(),
      updatedAt: data['updatedAt'] as Timestamp? ?? Timestamp.now(),
      imageUrl: data['imageUrl'] as String?, // Mapeia o novo campo
    );
  }

  // Factory original para criar um objeto News a partir de um DocumentSnapshot do Firestore
  factory News.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return News(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      authorUid: data['authorUid'] ?? '',
      createdAt: data['createdAt'] as Timestamp? ?? Timestamp.now(),
      updatedAt: data['updatedAt'] as Timestamp? ?? Timestamp.now(),
      imageUrl: data['imageUrl'] as String?, // Mapeia o novo campo
    );
  }

  // Método para converter para Map (usado para criação)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'authorUid': authorUid,
      // Usamos FieldValue.serverTimestamp() no serviço, mas aqui usamos o objeto para consistência no modelo.
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'imageUrl': imageUrl, // Inclui a URL
    };
  }

  // Método para converter para Map (usado para atualização)
  Map<String, dynamic> toUpdateMap() {
    return {
      'title': title,
      'content': content,
      'updatedAt': FieldValue.serverTimestamp(),
      'imageUrl': imageUrl, // Inclui a URL
    };
  }
}
