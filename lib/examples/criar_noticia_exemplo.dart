import '../models/noticia.dart';
import '../services/noticias_service.dart';

class CriarNoticiaExemplo {
  static final NoticiasService _noticiasService = NoticiasService();

  // Exemplo de como criar uma nova notícia
  static Future<void> criarNovaNoticia() async {
    try {
      // Criar uma nova notícia
      Noticia novaNoticia = Noticia(
        titulo: "Nova conquista da seleção brasileira de vôlei",
        conteudo: "A seleção brasileira de vôlei conquistou mais uma vitória importante em competição internacional. O time demonstrou excelente técnica e espírito de equipe, consolidando sua posição como uma das principais forças do vôlei mundial. A partida foi marcada por momentos de grande emoção e demonstrou a qualidade dos atletas brasileiros.",
        imagemUrl: "https://example.com/nova-conquista.jpg",
        autor: "Repórter Esportivo",
        dataPublicacao: DateTime.now(),
        tags: ["seleção", "vitória", "competição", "vôlei"],
      );

      // Salvar no Firestore
      String id = await _noticiasService.criarNoticia(novaNoticia);
      print('Nova notícia criada com sucesso! ID: $id');
      print('Título: ${novaNoticia.titulo}');
      print('Autor: ${novaNoticia.autor}');

    } catch (e) {
      print('Erro ao criar nova notícia: $e');
    }
  }

  // Exemplo de como atualizar uma notícia existente
  static Future<void> atualizarNoticiaExistente(String noticiaId) async {
    try {
      // Dados para atualizar
      Map<String, dynamic> updates = {
        'titulo': 'Título atualizado da notícia',
        'conteudo': 'Conteúdo atualizado com novas informações...',
        'tags': ['atualizado', 'vôlei', 'seleção'],
      };

      // Atualizar no Firestore
      await _noticiasService.atualizarNoticia(noticiaId, updates);
      print('Notícia atualizada com sucesso!');

    } catch (e) {
      print('Erro ao atualizar notícia: $e');
    }
  }

  // Exemplo de como buscar notícias por tag
  static Future<void> buscarNoticiasPorTag() async {
    try {
      List<Noticia> noticias = await _noticiasService.buscarNoticiasPorTag('seleção');
      
      print('Notícias encontradas para a tag "seleção":');
      for (Noticia noticia in noticias) {
        print('- ${noticia.titulo} (por ${noticia.autor})');
      }

    } catch (e) {
      print('Erro ao buscar notícias por tag: $e');
    }
  }

  // Exemplo de como buscar notícias mais visualizadas
  static Future<void> buscarNoticiasMaisVisualizadas() async {
    try {
      List<Noticia> noticias = await _noticiasService.buscarNoticiasMaisVisualizadas(limite: 5);
      
      print('Top 5 notícias mais visualizadas:');
      for (int i = 0; i < noticias.length; i++) {
        Noticia noticia = noticias[i];
        print('${i + 1}. ${noticia.titulo} - ${noticia.visualizacoes} visualizações');
      }

    } catch (e) {
      print('Erro ao buscar notícias mais visualizadas: $e');
    }
  }

  // Exemplo de como incrementar visualizações
  static Future<void> incrementarVisualizacoes(String noticiaId) async {
    try {
      await _noticiasService.incrementarVisualizacoes(noticiaId);
      print('Visualizações incrementadas com sucesso!');

    } catch (e) {
      print('Erro ao incrementar visualizações: $e');
    }
  }

  // Exemplo de como deletar uma notícia (soft delete)
  static Future<void> deletarNoticia(String noticiaId) async {
    try {
      await _noticiasService.deletarNoticia(noticiaId);
      print('Notícia deletada com sucesso (soft delete)!');

    } catch (e) {
      print('Erro ao deletar notícia: $e');
    }
  }

  // Exemplo de como usar o stream de notícias em tempo real
  static void escutarNoticiasEmTempoReal() {
    print('Iniciando escuta de notícias em tempo real...');
    
    _noticiasService.streamNoticias().listen(
      (noticias) {
        print('Notícias atualizadas em tempo real:');
        for (Noticia noticia in noticias) {
          print('- ${noticia.titulo}');
        }
      },
      onError: (error) {
        print('Erro no stream de notícias: $error');
      },
    );
  }
}