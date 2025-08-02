import 'package:flutter/material.dart';
import 'package:volleyball_center_mobile/main.dart';
import 'package:volleyball_center_mobile/login.dart';
import 'package:volleyball_center_mobile/loja.dart';
import 'package:volleyball_center_mobile/fundamentos.dart';
import 'package:volleyball_center_mobile/historia.dart';
import 'package:volleyball_center_mobile/navbar.dart';
import 'package:volleyball_center_mobile/regras.dart';
import 'package:volleyball_center_mobile/models/noticia.dart';
import 'package:volleyball_center_mobile/services/noticias_service.dart';
import 'package:volleyball_center_mobile/utils/noticias_exemplo.dart';

class Noticias extends StatefulWidget {
  const Noticias({super.key});

  @override
  State<Noticias> createState() => _NoticiasState();
}

class _NoticiasState extends State<Noticias> {
  final NoticiasService _noticiasService = NoticiasService();
  List<Noticia> _noticias = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _carregarNoticias();
  }

  Future<void> _carregarNoticias() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Verificar se a coleção está vazia e popular com dados de exemplo se necessário
      await NoticiasExemplo.popularSeVazia();

      // Carregar notícias do Firestore
      List<Noticia> noticias = await _noticiasService.buscarTodasNoticias();

      setState(() {
        _noticias = noticias;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Erro ao carregar notícias: $e';
        _isLoading = false;
      });
      print('Erro ao carregar notícias: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Isso é bom se tiver muito conteúdo
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),

            // O título centralizado
            Center(
              child: Text(
                "Notícias",
                style: TextStyle(
                  color: Color(0xFF14276B),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 20),

            // Indicador de carregamento
            if (_isLoading)
              Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF14276B),
                ),
              ),

            // Mensagem de erro
            if (_error != null)
              Container(
                margin: EdgeInsets.all(16.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Column(
                  children: [
                    Icon(Icons.error, color: Colors.red, size: 32),
                    SizedBox(height: 8),
                    Text(
                      'Erro ao carregar notícias',
                      style: TextStyle(
                        color: Colors.red[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      _error!,
                      style: TextStyle(color: Colors.red[600]),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _carregarNoticias,
                      child: Text('Tentar Novamente'),
                    ),
                  ],
                ),
              ),

            // Lista de notícias do Firestore
            if (!_isLoading && _error == null)
              ..._noticias.map((noticia) => _buildNoticiaCard(noticia)).toList(),

            // Bloco de notícia estático (mantido como fallback)
            if (_isLoading || _error != null)
              Container(
              padding: EdgeInsets.all(14.0),
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12),

                  // Texto e imagem lado a lado
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        // troque Expanded por Flexible
                        flex: 2,
                        child: Text(
                          "Seleção brasileira de vôlei apresenta novos uniformes para ciclo olímpico de Los Angeles 2028",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          softWrap: true, // adicione isso
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'images/uniformeNovo.jpg',
                          width: 180,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Divider(color: Colors.grey),
                  SizedBox(height: 12),

                  // Texto e imagem lado a lado
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        // troque Expanded por Flexible
                        flex: 2,
                        child: Text(
                          "Liga das Nações: Zé Roberto incrementa seleção com novos talentos em busca de título inédito",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          softWrap: true, // adicione isso
                        ),
                      ),
                      SizedBox(width: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'images/ze-roberto-guimaraes.webp',
                          width: 180,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Divider(color: Colors.grey),

                  SizedBox(height: 12),

                  // Texto e imagem lado a lado
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        // troque Expanded por Flexible
                        flex: 2,
                        child: Text(
                          "Renovação oficialmente iniciada na seleção masculina volei",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          softWrap: true, // adicione isso
                        ),
                      ),
                      SizedBox(width: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'images/brasil-tempo-bernardinho.jpg',
                          width: 180,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Divider(color: Colors.grey),
                  SizedBox(height: 12),

                  // Texto e imagem lado a lado
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        // troque Expanded por Flexible
                        flex: 2,
                        child: Text(
                          "Brasil inicia ciclo sem Carol, com nova líbero e algumas disputas",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          softWrap: true, // adicione isso
                        ),
                      ),
                      SizedBox(width: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'images/carol.jpg',
                          width: 180,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Divider(color: Colors.grey),
                  SizedBox(height: 12),

                  // Texto e imagem lado a lado
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        // troque Expanded por Flexible
                        flex: 2,
                        child: Text(
                          "Liga das Nações terá duas equipes a mais por naipe em 2025",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          softWrap: true, // adicione isso
                        ),
                      ),
                      SizedBox(width: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'images/vnl.jpg',
                          width: 180,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Divider(color: Colors.grey),
                  SizedBox(height: 12),

                  // Texto e imagem lado a lado
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        // troque Expanded por Flexible
                        flex: 2,
                        child: Text(
                          "Tabela da Liga das Nações de Vôlei (VNL) Feminino 2025",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          softWrap: true, // adicione isso
                        ),
                      ),
                      SizedBox(width: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'images/capavnl.jpg',
                          width: 180,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Widget para construir um card de notícia
  Widget _buildNoticiaCard(Noticia noticia) {
    return Container(
      padding: EdgeInsets.all(14.0),
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título e imagem lado a lado
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      noticia.titulo,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF14276B),
                      ),
                      softWrap: true,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Por ${noticia.autor}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      _formatarData(noticia.dataPublicacao),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              // Imagem da notícia
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: noticia.imagemUrl != null
                    ? Image.network(
                        noticia.imagemUrl!,
                        width: 120,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 120,
                            height: 80,
                            color: Colors.grey[300],
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.grey[600],
                            ),
                          );
                        },
                      )
                    : Container(
                        width: 120,
                        height: 80,
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.article,
                          color: Colors.grey[600],
                        ),
                      ),
              ),
            ],
          ),
          SizedBox(height: 12),
          
          // Resumo do conteúdo
          Text(
            noticia.conteudo.length > 150
                ? '${noticia.conteudo.substring(0, 150)}...'
                : noticia.conteudo,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          
          SizedBox(height: 12),
          
          // Tags
          if (noticia.tags.isNotEmpty)
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: noticia.tags.map((tag) => Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFF14276B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '#$tag',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF14276B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )).toList(),
            ),
          
          SizedBox(height: 8),
          
          // Visualizações
          Row(
            children: [
              Icon(
                Icons.visibility,
                size: 16,
                color: Colors.grey[500],
              ),
              SizedBox(width: 4),
              Text(
                '${noticia.visualizacoes} visualizações',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Método para formatar a data
  String _formatarData(DateTime data) {
    final now = DateTime.now();
    final difference = now.difference(data);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} minutos atrás';
      } else {
        return '${difference.inHours} horas atrás';
      }
    } else if (difference.inDays == 1) {
      return 'Ontem';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} dias atrás';
    } else {
      return '${data.day}/${data.month}/${data.year}';
    }
  }

  Text textCreator(String text) {
    return Text(
      text,
      textDirection: TextDirection.ltr,
      style: TextStyle(
        fontSize: 14,
        color: Colors.white,
      ),
    );
  }
}
