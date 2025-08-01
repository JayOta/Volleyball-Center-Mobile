import 'package:cloud_firestore/cloud_firestore.dart';

class NoticiaModel {
  final String id;
  final String titulo;
  final String conteudo;
  final String resumo;
  final String imagemUrl;
  final String autor;
  final DateTime dataPublicacao;
  final DateTime dataAtualizacao;
  final List<String> tags;
  final bool ativo;
  final int visualizacoes;

  NoticiaModel({
    required this.id,
    required this.titulo,
    required this.conteudo,
    required this.resumo,
    required this.imagemUrl,
    required this.autor,
    required this.dataPublicacao,
    required this.dataAtualizacao,
    required this.tags,
    required this.ativo,
    required this.visualizacoes,
  });

  // Criar instância a partir de dados do Firestore
  factory NoticiaModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return NoticiaModel(
      id: doc.id,
      titulo: data['titulo'] ?? '',
      conteudo: data['conteudo'] ?? '',
      resumo: data['resumo'] ?? '',
      imagemUrl: data['imagemUrl'] ?? '',
      autor: data['autor'] ?? '',
      dataPublicacao: (data['dataPublicacao'] as Timestamp?)?.toDate() ?? DateTime.now(),
      dataAtualizacao: (data['dataAtualizacao'] as Timestamp?)?.toDate() ?? DateTime.now(),
      tags: List<String>.from(data['tags'] ?? []),
      ativo: data['ativo'] ?? true,
      visualizacoes: data['visualizacoes'] ?? 0,
    );
  }

  // Criar instância a partir de Map
  factory NoticiaModel.fromMap(Map<String, dynamic> data, String id) {
    return NoticiaModel(
      id: id,
      titulo: data['titulo'] ?? '',
      conteudo: data['conteudo'] ?? '',
      resumo: data['resumo'] ?? '',
      imagemUrl: data['imagemUrl'] ?? '',
      autor: data['autor'] ?? '',
      dataPublicacao: (data['dataPublicacao'] as Timestamp?)?.toDate() ?? DateTime.now(),
      dataAtualizacao: (data['dataAtualizacao'] as Timestamp?)?.toDate() ?? DateTime.now(),
      tags: List<String>.from(data['tags'] ?? []),
      ativo: data['ativo'] ?? true,
      visualizacoes: data['visualizacoes'] ?? 0,
    );
  }

  // Converter para Map (para salvar no Firestore)
  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'conteudo': conteudo,
      'resumo': resumo,
      'imagemUrl': imagemUrl,
      'autor': autor,
      'dataPublicacao': Timestamp.fromDate(dataPublicacao),
      'dataAtualizacao': Timestamp.fromDate(dataAtualizacao),
      'tags': tags,
      'ativo': ativo,
      'visualizacoes': visualizacoes,
    };
  }

  // Criar cópia com modificações
  NoticiaModel copyWith({
    String? titulo,
    String? conteudo,
    String? resumo,
    String? imagemUrl,
    String? autor,
    DateTime? dataPublicacao,
    DateTime? dataAtualizacao,
    List<String>? tags,
    bool? ativo,
    int? visualizacoes,
  }) {
    return NoticiaModel(
      id: id,
      titulo: titulo ?? this.titulo,
      conteudo: conteudo ?? this.conteudo,
      resumo: resumo ?? this.resumo,
      imagemUrl: imagemUrl ?? this.imagemUrl,
      autor: autor ?? this.autor,
      dataPublicacao: dataPublicacao ?? this.dataPublicacao,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
      tags: tags ?? this.tags,
      ativo: ativo ?? this.ativo,
      visualizacoes: visualizacoes ?? this.visualizacoes,
    );
  }

  // Getter para data formatada
  String get dataFormatada {
    return '${dataPublicacao.day.toString().padLeft(2, '0')}/'
           '${dataPublicacao.month.toString().padLeft(2, '0')}/'
           '${dataPublicacao.year}';
  }

  // Getter para tempo desde publicação
  String get tempoPublicacao {
    final agora = DateTime.now();
    final diferenca = agora.difference(dataPublicacao);

    if (diferenca.inDays > 0) {
      return '${diferenca.inDays} dia${diferenca.inDays > 1 ? 's' : ''} atrás';
    } else if (diferenca.inHours > 0) {
      return '${diferenca.inHours} hora${diferenca.inHours > 1 ? 's' : ''} atrás';
    } else if (diferenca.inMinutes > 0) {
      return '${diferenca.inMinutes} minuto${diferenca.inMinutes > 1 ? 's' : ''} atrás';
    } else {
      return 'Agora';
    }
  }

  @override
  String toString() {
    return 'NoticiaModel(id: $id, titulo: $titulo, autor: $autor, ativo: $ativo)';
  }
}