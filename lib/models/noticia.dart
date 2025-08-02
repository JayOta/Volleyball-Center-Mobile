import 'package:cloud_firestore/cloud_firestore.dart';

class Noticia {
  final String? id;
  final String titulo;
  final String conteudo;
  final String? imagemUrl;
  final String autor;
  final DateTime dataPublicacao;
  final DateTime? dataAtualizacao;
  final List<String> tags;
  final bool ativo;
  final int visualizacoes;

  Noticia({
    this.id,
    required this.titulo,
    required this.conteudo,
    this.imagemUrl,
    required this.autor,
    required this.dataPublicacao,
    this.dataAtualizacao,
    this.tags = const [],
    this.ativo = true,
    this.visualizacoes = 0,
  });

  // Converter para Map (para salvar no Firestore)
  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'conteudo': conteudo,
      'imagemUrl': imagemUrl,
      'autor': autor,
      'dataPublicacao': dataPublicacao,
      'dataAtualizacao': dataAtualizacao,
      'tags': tags,
      'ativo': ativo,
      'visualizacoes': visualizacoes,
    };
  }

  // Criar Noticia a partir de Map (do Firestore)
  factory Noticia.fromMap(String id, Map<String, dynamic> map) {
    return Noticia(
      id: id,
      titulo: map['titulo'] ?? '',
      conteudo: map['conteudo'] ?? '',
      imagemUrl: map['imagemUrl'],
      autor: map['autor'] ?? '',
      dataPublicacao: (map['dataPublicacao'] as Timestamp).toDate(),
      dataAtualizacao: map['dataAtualizacao'] != null 
          ? (map['dataAtualizacao'] as Timestamp).toDate() 
          : null,
      tags: List<String>.from(map['tags'] ?? []),
      ativo: map['ativo'] ?? true,
      visualizacoes: map['visualizacoes'] ?? 0,
    );
  }

  // Criar cópia com alterações
  Noticia copyWith({
    String? id,
    String? titulo,
    String? conteudo,
    String? imagemUrl,
    String? autor,
    DateTime? dataPublicacao,
    DateTime? dataAtualizacao,
    List<String>? tags,
    bool? ativo,
    int? visualizacoes,
  }) {
    return Noticia(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      conteudo: conteudo ?? this.conteudo,
      imagemUrl: imagemUrl ?? this.imagemUrl,
      autor: autor ?? this.autor,
      dataPublicacao: dataPublicacao ?? this.dataPublicacao,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
      tags: tags ?? this.tags,
      ativo: ativo ?? this.ativo,
      visualizacoes: visualizacoes ?? this.visualizacoes,
    );
  }

  @override
  String toString() {
    return 'Noticia(id: $id, titulo: $titulo, autor: $autor, dataPublicacao: $dataPublicacao)';
  }
}