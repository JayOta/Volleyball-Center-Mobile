import 'package:flutter/material.dart';
import 'package:volleyball_center_mobile/models/noticia_model.dart';
import 'package:volleyball_center_mobile/services/noticias_service.dart';
import 'package:volleyball_center_mobile/utils/user_utils.dart';

class AdminNoticiasPage extends StatefulWidget {
  const AdminNoticiasPage({super.key});

  @override
  State<AdminNoticiasPage> createState() => _AdminNoticiasPageState();
}

class _AdminNoticiasPageState extends State<AdminNoticiasPage> {
  final NoticiasService _noticiasService = NoticiasService();
  List<NoticiaModel> _noticias = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarNoticias();
  }

  Future<void> _carregarNoticias() async {
    try {
      final noticias = await _noticiasService.buscarNoticiasAtivas();
      setState(() {
        _noticias = noticias;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar notícias: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Notícias'),
        backgroundColor: const Color(0xFF14276B),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarNoticias,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Header com estatísticas
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.blue.shade50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard('Total', _noticias.length.toString(), Icons.article),
                      _buildStatCard(
                        'Visualizações', 
                        _noticias.fold<int>(0, (sum, n) => sum + n.visualizacoes).toString(),
                        Icons.visibility,
                      ),
                      _buildStatCard(
                        'Hoje',
                        _noticias.where((n) => 
                          n.dataPublicacao.day == DateTime.now().day &&
                          n.dataPublicacao.month == DateTime.now().month &&
                          n.dataPublicacao.year == DateTime.now().year
                        ).length.toString(),
                        Icons.today,
                      ),
                    ],
                  ),
                ),
                
                // Lista de notícias
                Expanded(
                  child: _noticias.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.article_outlined, size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text(
                                'Nenhuma notícia encontrada',
                                style: TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                              Text(
                                'Clique no + para criar a primeira notícia',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _noticias.length,
                          itemBuilder: (context, index) {
                            final noticia = _noticias[index];
                            return _buildNoticiaCard(noticia);
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF14276B),
        onPressed: () => _navegarParaCriarNoticia(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF14276B), size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF14276B),
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoticiaCard(NoticiaModel noticia) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header do card
            Row(
              children: [
                Expanded(
                  child: Text(
                    noticia.titulo,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) => _onMenuAction(value, noticia),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'editar',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 20),
                          SizedBox(width: 8),
                          Text('Editar'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'deletar',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red, size: 20),
                          SizedBox(width: 8),
                          Text('Deletar', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Resumo
            Text(
              noticia.resumo,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            const SizedBox(height: 12),
            
            // Tags
            if (noticia.tags.isNotEmpty)
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: noticia.tags.take(3).map((tag) => Chip(
                  label: Text(
                    tag,
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: const Color(0xFF14276B).withOpacity(0.1),
                  side: const BorderSide(color: Color(0xFF14276B)),
                )).toList(),
              ),
            
            const SizedBox(height: 12),
            
            // Footer
            Row(
              children: [
                Icon(Icons.person, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  noticia.autor,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  noticia.tempoPublicacao,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const Spacer(),
                Icon(Icons.visibility, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  noticia.visualizacoes.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onMenuAction(String action, NoticiaModel noticia) {
    switch (action) {
      case 'editar':
        _navegarParaEditarNoticia(noticia);
        break;
      case 'deletar':
        _confirmarDelecao(noticia);
        break;
    }
  }

  void _navegarParaCriarNoticia() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CriarEditarNoticiaPage(),
      ),
    ).then((_) => _carregarNoticias());
  }

  void _navegarParaEditarNoticia(NoticiaModel noticia) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CriarEditarNoticiaPage(noticia: noticia),
      ),
    ).then((_) => _carregarNoticias());
  }

  void _confirmarDelecao(NoticiaModel noticia) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Deleção'),
        content: Text('Tem certeza que deseja deletar a notícia "${noticia.titulo}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deletarNoticia(noticia);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Deletar'),
          ),
        ],
      ),
    );
  }

  Future<void> _deletarNoticia(NoticiaModel noticia) async {
    try {
      await _noticiasService.deletarNoticia(noticia.id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notícia deletada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
      
      _carregarNoticias();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao deletar notícia: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

// Página para criar/editar notícias
class CriarEditarNoticiaPage extends StatefulWidget {
  final NoticiaModel? noticia;
  
  const CriarEditarNoticiaPage({super.key, this.noticia});

  @override
  State<CriarEditarNoticiaPage> createState() => _CriarEditarNoticiaPageState();
}

class _CriarEditarNoticiaPageState extends State<CriarEditarNoticiaPage> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _resumoController = TextEditingController();
  final _conteudoController = TextEditingController();
  final _imagemController = TextEditingController();
  final _tagsController = TextEditingController();
  
  final NoticiasService _noticiasService = NoticiasService();
  bool _isLoading = false;

  bool get _isEditMode => widget.noticia != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      _preencherCampos();
    }
  }

  void _preencherCampos() {
    final noticia = widget.noticia!;
    _tituloController.text = noticia.titulo;
    _resumoController.text = noticia.resumo;
    _conteudoController.text = noticia.conteudo;
    _imagemController.text = noticia.imagemUrl;
    _tagsController.text = noticia.tags.join(', ');
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _resumoController.dispose();
    _conteudoController.dispose();
    _imagemController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Editar Notícia' : 'Criar Notícia'),
        backgroundColor: const Color(0xFF14276B),
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Título
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Título é obrigatório';
                  }
                  return null;
                },
                maxLines: 2,
              ),
              
              const SizedBox(height: 16),
              
              // Resumo
              TextFormField(
                controller: _resumoController,
                decoration: const InputDecoration(
                  labelText: 'Resumo *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.short_text),
                  helperText: 'Breve descrição da notícia',
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Resumo é obrigatório';
                  }
                  return null;
                },
                maxLines: 3,
              ),
              
              const SizedBox(height: 16),
              
              // Conteúdo
              TextFormField(
                controller: _conteudoController,
                decoration: const InputDecoration(
                  labelText: 'Conteúdo *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.article),
                  helperText: 'Conteúdo completo da notícia',
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Conteúdo é obrigatório';
                  }
                  return null;
                },
                maxLines: 10,
              ),
              
              const SizedBox(height: 16),
              
              // URL da Imagem
              TextFormField(
                controller: _imagemController,
                decoration: const InputDecoration(
                  labelText: 'URL da Imagem',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.image),
                  helperText: 'Link para imagem da notícia (opcional)',
                ),
                keyboardType: TextInputType.url,
              ),
              
              const SizedBox(height: 16),
              
              // Tags
              TextFormField(
                controller: _tagsController,
                decoration: const InputDecoration(
                  labelText: 'Tags',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.tag),
                  helperText: 'Separe as tags por vírgula (ex: volei, esporte, brasil)',
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Botão de salvar
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF14276B),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _isLoading ? null : _salvarNoticia,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(_isEditMode ? 'Atualizar Notícia' : 'Criar Notícia'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _salvarNoticia() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final tags = _tagsController.text
          .split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toList();

      if (_isEditMode) {
        // Atualizar notícia existente
        await _noticiasService.atualizarNoticia(widget.noticia!.id, {
          'titulo': _tituloController.text.trim(),
          'resumo': _resumoController.text.trim(),
          'conteudo': _conteudoController.text.trim(),
          'imagemUrl': _imagemController.text.trim(),
          'tags': tags,
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Notícia atualizada com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // Criar nova notícia
        await _noticiasService.criarNoticia(
          titulo: _tituloController.text.trim(),
          resumo: _resumoController.text.trim(),
          conteudo: _conteudoController.text.trim(),
          imagemUrl: _imagemController.text.trim(),
          tags: tags,
        );
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Notícia criada com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar notícia: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}