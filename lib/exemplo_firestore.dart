import 'package:flutter/material.dart';
import 'firestore_helper.dart';

class ExemploFirestore extends StatefulWidget {
  const ExemploFirestore({super.key});

  @override
  State<ExemploFirestore> createState() => _ExemploFirestoreState();
}

class _ExemploFirestoreState extends State<ExemploFirestore> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  List<Map<String, dynamic>> posts = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() => isLoading = true);
    try {
      final loadedPosts = await FirestoreHelper.getPosts();
      setState(() {
        posts = loadedPosts;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      _showError('Erro ao carregar posts: $e');
    }
  }

  Future<void> _addPost() async {
    if (_titleController.text.isEmpty || _bodyController.text.isEmpty) {
      _showError('Preencha todos os campos');
      return;
    }

    setState(() => isLoading = true);
    try {
      await FirestoreHelper.addPost(
        _titleController.text,
        _bodyController.text,
      );
      _titleController.clear();
      _bodyController.clear();
      await _loadPosts(); // Recarrega a lista
      _showSuccess('Post adicionado com sucesso!');
    } catch (e) {
      setState(() => isLoading = false);
      _showError('Erro ao adicionar post: $e');
    }
  }

  Future<void> _deletePost(String postId) async {
    setState(() => isLoading = true);
    try {
      await FirestoreHelper.deleteDocument('posts', postId);
      await _loadPosts();
      _showSuccess('Post deletado com sucesso!');
    } catch (e) {
      setState(() => isLoading = false);
      _showError('Erro ao deletar post: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exemplo Firestore'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Formulário para adicionar posts
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Título',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _bodyController,
                      decoration: const InputDecoration(
                        labelText: 'Conteúdo',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: isLoading ? null : _addPost,
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Adicionar Post'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Lista de posts
            Expanded(
              child: isLoading && posts.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : posts.isEmpty
                      ? const Center(
                          child: Text(
                            'Nenhum post encontrado.\nAdicione o primeiro post!',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            final post = posts[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                title: Text(
                                  post['title'] ?? 'Sem título',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(post['body'] ?? 'Sem conteúdo'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deletePost(post['id']),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadPosts,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }
}