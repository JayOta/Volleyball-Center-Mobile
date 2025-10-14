import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:volleyball_center_mobile/navbar.dart';
import 'package:volleyball_center_mobile/services/firestore_service.dart';
import 'package:volleyball_center_mobile/models/news.dart';

class Noticias extends StatefulWidget {
  const Noticias({super.key});

  @override
  State<Noticias> createState() => _NoticiasState();
}

class _NoticiasState extends State<Noticias> {
  final FirestoreService _firestoreService = FirestoreService();
  late Future<List<News>> _newsFuture;

  @override
  void initState() {
    super.initState();
    _newsFuture = _fetchNews();
  }

  // Função para buscar e converter as notícias, semelhante ao que fizemos no Admin
  Future<List<News>> _fetchNews() async {
    try {
      final List<Map<String, dynamic>> newsDataList =
          await _firestoreService.getAllNews();

      // Usando o factory News.fromMap que adicionamos no modelo
      return newsDataList.map((data) => News.fromMap(data)).toList();
    } catch (e) {
      // Se houver erro (sem conexão, regras de segurança, etc.)
      print("Erro ao carregar notícias no app: $e");
      // Retorna uma lista vazia ou lança um erro, dependendo do que for melhor para o UX
      return [];
    }
  }

// Widget que renderiza uma única notícia
  Widget _buildNewsItem(BuildContext context, News news) {
    // O Card ajuda a agrupar visualmente o item da notícia
    return Card(
      elevation: 4, // Adiciona uma leve sombra para destacar
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ NOVO: Exibição da Imagem
          if (news.imageUrl != null && news.imageUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.network(
                news.imageUrl!,
                height: 200, // Altura fixa para um visual consistente
                width: double.infinity,
                fit: BoxFit.cover,
                // Adicionar um placeholder de carregamento/erro para melhor UX
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: const Center(
                        child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF14276B)),
                    )),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Center(
                        child: Icon(Icons.broken_image,
                            size: 50, color: Colors.red)),
                  );
                },
              ),
            ),

          // --- Conteúdo da Notícia ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  news.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF14276B),
                  ),
                  softWrap: true,
                ),
                const SizedBox(height: 8),
                Text(
                  // Mostra apenas uma prévia do conteúdo (primeiros 150 caracteres)
                  news.content.length > 150
                      ? '${news.content.substring(0, 150)}...'
                      : news.content,
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 12),
                Text(
                  'Publicado em: ${_formatTimestamp(news.createdAt)}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Função auxiliar para formatar o timestamp (copiado do AdminUsersView)
  String _formatTimestamp(Timestamp timestamp) {
    final date = timestamp.toDate();
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),

            const Center(
              child: Text(
                "Notícias",
                style: TextStyle(
                  color: Color(0xFF14276B),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // NOVO: FutureBuilder para buscar dados do Firebase
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: FutureBuilder<List<News>>(
                future: _newsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text(
                            'Erro ao carregar notícias: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('Nenhuma notícia disponível.'));
                  }

                  final newsList = snapshot.data!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: newsList.map((news) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: _buildNewsItem(context, news),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // O textCreator e o antigo bodyContent (com notícias estáticas) foram removidos/substituídos.
}
