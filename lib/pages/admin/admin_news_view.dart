// lib/pages/admin/admin_news_view.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:volleyball_center_mobile/models/news.dart';
import 'package:volleyball_center_mobile/services/firestore_service.dart';
// NOTE: Removemos importações relacionadas a ImagePicker e StorageService.

class AdminNewsView extends StatefulWidget {
  const AdminNewsView({super.key});

  @override
  State<AdminNewsView> createState() => _AdminNewsViewState();
}

class _AdminNewsViewState extends State<AdminNewsView> {
  final FirestoreService _firestoreService = FirestoreService();
  // ❌ REMOVIDO: final StorageService _storageService = StorageService();

  late Future<List<News>> _newsFuture;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  // ✅ NOVO: Controller para a URL da imagem externa
  final TextEditingController _imageUrlController = TextEditingController();

  // ❌ REMOVIDO: XFile? _selectedImage;
  // ❌ REMOVIDO: String? _existingImageUrl;

  News? _editingNews;

  @override
  void initState() {
    super.initState();
    _newsFuture = _fetchNews();
  }

  // Função para buscar e converter as notícias
  Future<List<News>> _fetchNews() async {
    try {
      final List<Map<String, dynamic>> newsDataList =
          await _firestoreService.getAllNews();

      return newsDataList.map((data) {
        return News.fromMap(data);
      }).toList();
    } catch (e) {
      // Captura o erro, exibe e retorna lista vazia para evitar crash
      print("Erro ao carregar notícias no app: $e");
      // Reatribui o Future para que o FutureBuilder exiba o erro
      setState(() {
        _newsFuture = Future.error(e);
      });
      return [];
    }
  }

  // ❌ REMOVIDO: _pickImage (Não precisamos mais do seletor de arquivos)

  // Função para limpar o formulário e resetar variáveis
  void _clearForm() {
    _titleController.clear();
    _contentController.clear();
    _imageUrlController.clear(); // Limpa o campo de URL
    setState(() {
      _editingNews = null;
      // ❌ REMOVIDO: _selectedImage = null;
      // ❌ REMOVIDO: _existingImageUrl = null;
    });
  }

  // Função para salvar (criar ou atualizar) a notícia
  Future<void> _saveNews() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Título e Conteúdo são obrigatórios.')),
      );
      return;
    }

    try {
      // ❌ REMOVIDO: Toda a lógica de Upload/Manutenção de Imagem do Storage
      // String? finalImageUrl = _existingImageUrl;
      // ... (Resto da lógica removida)

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      final News news = News(
        id: _editingNews?.id ?? '',
        title: _titleController.text,
        content: _contentController.text,
        authorUid: currentUser.uid,
        createdAt: _editingNews?.createdAt ?? Timestamp.now(),
        updatedAt: Timestamp.now(),
        // ✅ NOVO: Usa o texto digitado como URL
        imageUrl:
            _imageUrlController.text.isEmpty ? null : _imageUrlController.text,
      );

      if (_editingNews == null) {
        // CRIAÇÃO
        await _firestoreService.addNews(news);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Notícia criada com sucesso!')));
      } else {
        // EDIÇÃO
        await _firestoreService.updateNews(news);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Notícia atualizada com sucesso!')));
      }

      _clearForm();
      setState(() {
        _newsFuture = _fetchNews(); // Recarrega a lista
      });
    } catch (e) {
      print("Erro ao salvar notícia: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: ${e.toString()}')));
    }
  }

  // Função para deletar a notícia
  Future<void> _deleteNews(News news) async {
    try {
      // ❌ REMOVIDO: 1. Deleta a imagem do Storage
      // await _storageService.deleteImage(news.imageUrl);

      // 2. Deleta o documento do Firestore
      await _firestoreService.deleteNews(news.id);

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Notícia "${news.title}" excluída!')));

      setState(() {
        _newsFuture = _fetchNews(); // Recarrega a lista
      });
    } catch (e) {
      print("Erro ao deletar notícia: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao deletar: ${e.toString()}')));
    }
  }

  // Função para preencher o formulário para edição
  void _editNews(News news) {
    setState(() {
      _editingNews = news;
      _titleController.text = news.title;
      _contentController.text = news.content;
      // ✅ NOVO: Preenche o campo de URL com a URL existente
      _imageUrlController.text = news.imageUrl ?? '';
      // ❌ REMOVIDO: _existingImageUrl = news.imageUrl;
      // ❌ REMOVIDO: _selectedImage = null;
    });
  }

  // Função para formatar o Timestamp
  String _formatTimestamp(Timestamp timestamp) {
    final date = timestamp.toDate();
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _editingNews == null ? 'Criar Nova Notícia' : 'Editar Notícia',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // --- Formulário ---
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Título da Notícia',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _contentController,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Conteúdo Completo',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // ✅ NOVO: Campo de texto para a URL da Imagem Externa
          TextField(
            controller: _imageUrlController,
            decoration: const InputDecoration(
              labelText: 'URL da Imagem (Link Externo)',
              hintText: 'Cole o link de uma imagem hospedada aqui (opcional)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          // ❌ REMOVIDO: O Widget Row que continha o _pickImage

          // Botões de Ação
          Row(
            children: [
              ElevatedButton(
                onPressed: _saveNews,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF14276b),
                  foregroundColor: Colors.white,
                ),
                child:
                    Text(_editingNews == null ? 'Publicar' : 'Salvar Edição'),
              ),
              const SizedBox(width: 10),
              if (_editingNews != null)
                TextButton(
                  onPressed: _clearForm,
                  child: const Text('Cancelar Edição'),
                ),
            ],
          ),
          const Divider(height: 40),

          // --- Tabela de Notícias ---
          const Text(
            'Notícias Publicadas',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          FutureBuilder<List<News>>(
            future: _newsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // Exibe a mensagem de erro que foi capturada no _fetchNews
                return Center(
                    child: Text(
                        'Erro ao carregar notícias: ${snapshot.error.toString()}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Nenhuma notícia encontrada.'));
              }

              final newsList = snapshot.data!;

              // ... restante da tabela de notícias ...
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Título')),
                    DataColumn(label: Text('Imagem')),
                    DataColumn(label: Text('Data')),
                    DataColumn(label: Text('Ações')),
                  ],
                  rows: newsList.map((news) {
                    return DataRow(cells: [
                      DataCell(SizedBox(
                          width: 150,
                          child: Text(news.title,
                              overflow: TextOverflow.ellipsis))),
                      DataCell(
                        news.imageUrl != null && news.imageUrl!.isNotEmpty
                            ? const Icon(Icons.photo, color: Colors.green)
                            : const Icon(Icons.close, color: Colors.red),
                      ),
                      DataCell(Text(_formatTimestamp(news.createdAt))),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editNews(news),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteNews(news),
                          ),
                        ],
                      )),
                    ]);
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
