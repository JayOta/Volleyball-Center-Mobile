import 'package:flutter/material.dart';
import 'models/noticia.dart';
import 'services/noticias_service.dart';
import 'utils/noticias_exemplo.dart';

class TestNoticias extends StatefulWidget {
  const TestNoticias({super.key});

  @override
  State<TestNoticias> createState() => _TestNoticiasState();
}

class _TestNoticiasState extends State<TestNoticias> {
  final NoticiasService _noticiasService = NoticiasService();
  List<Noticia> _noticias = [];
  bool _isLoading = false;
  String _status = '';

  @override
  void initState() {
    super.initState();
    _testarFuncionalidades();
  }

  Future<void> _testarFuncionalidades() async {
    setState(() {
      _isLoading = true;
      _status = 'Iniciando testes...';
    });

    try {
      // Teste 1: Popular dados de exemplo
      setState(() => _status = 'Teste 1: Populando dados de exemplo...');
      await NoticiasExemplo.popularSeVazia();

      // Teste 2: Buscar todas as notícias
      setState(() => _status = 'Teste 2: Buscando todas as notícias...');
      List<Noticia> noticias = await _noticiasService.buscarTodasNoticias();
      setState(() => _noticias = noticias);

      // Teste 3: Criar uma nova notícia
      setState(() => _status = 'Teste 3: Criando nova notícia...');
      Noticia novaNoticia = Noticia(
        titulo: "Notícia de Teste - ${DateTime.now().millisecondsSinceEpoch}",
        conteudo: "Esta é uma notícia de teste criada para verificar a funcionalidade da coleção de notícias no Firestore.",
        autor: "Sistema de Teste",
        dataPublicacao: DateTime.now(),
        tags: ["teste", "firestore", "flutter"],
      );
      
      String id = await _noticiasService.criarNoticia(novaNoticia);
      setState(() => _status = 'Nova notícia criada com ID: $id');

      // Teste 4: Buscar notícias por tag
      setState(() => _status = 'Teste 4: Buscando notícias por tag...');
      List<Noticia> noticiasPorTag = await _noticiasService.buscarNoticiasPorTag("teste");
      setState(() => _status = 'Encontradas ${noticiasPorTag.length} notícias com tag "teste"');

      // Teste 5: Atualizar notícia
      setState(() => _status = 'Teste 5: Atualizando notícia...');
      await _noticiasService.atualizarNoticia(id, {
        'titulo': 'Notícia Atualizada - ${DateTime.now().millisecondsSinceEpoch}',
        'conteudo': 'Esta notícia foi atualizada com sucesso!',
      });

      // Teste 6: Incrementar visualizações
      setState(() => _status = 'Teste 6: Incrementando visualizações...');
      await _noticiasService.incrementarVisualizacoes(id);

      // Teste 7: Buscar notícia por ID
      setState(() => _status = 'Teste 7: Buscando notícia por ID...');
      Noticia? noticiaEncontrada = await _noticiasService.buscarNoticiaPorId(id);
      if (noticiaEncontrada != null) {
        setState(() => _status = 'Notícia encontrada: ${noticiaEncontrada.titulo}');
      }

      // Teste 8: Buscar notícias mais visualizadas
      setState(() => _status = 'Teste 8: Buscando notícias mais visualizadas...');
      List<Noticia> maisVisualizadas = await _noticiasService.buscarNoticiasMaisVisualizadas(limite: 5);

      // Atualizar lista final
      List<Noticia> todasNoticias = await _noticiasService.buscarTodasNoticias();
      setState(() {
        _noticias = todasNoticias;
        _isLoading = false;
        _status = 'Todos os testes concluídos com sucesso! Total de notícias: ${todasNoticias.length}';
      });

    } catch (e) {
      setState(() {
        _isLoading = false;
        _status = 'Erro durante os testes: $e';
      });
      print('Erro durante os testes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teste - Coleção de Notícias'),
        backgroundColor: Color(0xFF14276B),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Status dos testes
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            color: _isLoading ? Colors.blue[50] : Colors.green[50],
            child: Column(
              children: [
                if (_isLoading)
                  CircularProgressIndicator(
                    color: Color(0xFF14276B),
                  ),
                SizedBox(height: 8),
                Text(
                  _status,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _isLoading ? Colors.blue[700] : Colors.green[700],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Botão para executar testes novamente
          Padding(
            padding: EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _isLoading ? null : _testarFuncionalidades,
              child: Text('Executar Testes Novamente'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF14276B),
                foregroundColor: Colors.white,
              ),
            ),
          ),

          // Lista de notícias
          Expanded(
            child: _noticias.isEmpty
                ? Center(
                    child: Text(
                      'Nenhuma notícia encontrada',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  )
                : ListView.builder(
                    itemCount: _noticias.length,
                    itemBuilder: (context, index) {
                      Noticia noticia = _noticias[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: ListTile(
                          title: Text(
                            noticia.titulo,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Por: ${noticia.autor}'),
                              Text('Data: ${_formatarData(noticia.dataPublicacao)}'),
                              Text('Visualizações: ${noticia.visualizacoes}'),
                              if (noticia.tags.isNotEmpty)
                                Wrap(
                                  spacing: 4,
                                  children: noticia.tags.map((tag) => Chip(
                                    label: Text(tag, style: TextStyle(fontSize: 10)),
                                    backgroundColor: Color(0xFF14276B).withOpacity(0.1),
                                  )).toList(),
                                ),
                            ],
                          ),
                          isThreeLine: true,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _formatarData(DateTime data) {
    return '${data.day}/${data.month}/${data.year} ${data.hour}:${data.minute}';
  }
}