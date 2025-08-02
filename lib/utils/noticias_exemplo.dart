import '../models/noticia.dart';
import '../services/noticias_service.dart';

class NoticiasExemplo {
  static final NoticiasService _noticiasService = NoticiasService();

  // Lista de notícias de exemplo
  static final List<Noticia> noticiasExemplo = [
    Noticia(
      titulo: "Seleção brasileira de vôlei apresenta novos uniformes para ciclo olímpico de Los Angeles 2028",
      conteudo: "A Confederação Brasileira de Voleibol (CBV) apresentou oficialmente os novos uniformes da seleção brasileira masculina e feminina para o ciclo olímpico que culminará nos Jogos de Los Angeles 2028. Os uniformes, desenvolvidos em parceria com a marca esportiva oficial, incorporam tecnologia de ponta e design moderno, mantendo as cores tradicionais do Brasil. O lançamento foi realizado em cerimônia especial na sede da CBV, com a presença de atletas e dirigentes.",
      imagemUrl: "https://example.com/uniforme-novo.jpg",
      autor: "Redação CBV",
      dataPublicacao: DateTime.now().subtract(Duration(days: 2)),
      tags: ["seleção", "uniforme", "olimpíadas", "CBV"],
    ),
    Noticia(
      titulo: "Liga das Nações: Zé Roberto incrementa seleção com novos talentos em busca de título inédito",
      conteudo: "O técnico José Roberto Guimarães anunciou a convocação de novos talentos para a seleção brasileira feminina de vôlei, visando a próxima edição da Liga das Nações. Entre as novidades estão jogadoras que se destacaram no Campeonato Brasileiro e em competições internacionais. Zé Roberto destacou a importância de renovar o elenco mantendo a competitividade da equipe, que busca conquistar o título da VNL pela primeira vez na história.",
      imagemUrl: "https://example.com/ze-roberto.jpg",
      autor: "Esporte News",
      dataPublicacao: DateTime.now().subtract(Duration(days: 3)),
      tags: ["liga das nações", "Zé Roberto", "seleção feminina", "VNL"],
    ),
    Noticia(
      titulo: "Renovação oficialmente iniciada na seleção masculina de vôlei",
      conteudo: "A seleção brasileira masculina de vôlei inicia oficialmente seu processo de renovação com a convocação de novos atletas para o próximo ciclo olímpico. O técnico responsável pela transição anunciou que o foco será na preparação de jovens talentos para os Jogos de Los Angeles 2028, mantendo alguns veteranos para garantir a experiência necessária em competições importantes.",
      imagemUrl: "https://example.com/selecao-masculina.jpg",
      autor: "Vôlei Brasil",
      dataPublicacao: DateTime.now().subtract(Duration(days: 5)),
      tags: ["seleção masculina", "renovação", "olimpíadas", "transição"],
    ),
    Noticia(
      titulo: "Brasil inicia ciclo sem Carol, com nova líbero e algumas disputas",
      conteudo: "A seleção brasileira feminina de vôlei inicia o novo ciclo olímpico sem a líbero Carol, que anunciou sua aposentadoria após os Jogos de Tóquio. A posição será disputada por novas atletas que se destacaram no cenário nacional. O técnico Zé Roberto afirmou que a renovação na posição é natural e que as novas líberos têm potencial para manter o alto nível da seleção.",
      imagemUrl: "https://example.com/carol-libero.jpg",
      autor: "Vôlei News",
      dataPublicacao: DateTime.now().subtract(Duration(days: 7)),
      tags: ["Carol", "líbero", "seleção feminina", "aposentadoria"],
    ),
    Noticia(
      titulo: "Liga das Nações terá duas equipes a mais por naipe em 2025",
      conteudo: "A Federação Internacional de Voleibol (FIVB) anunciou que a Liga das Nações (VNL) terá duas equipes a mais por naipe a partir de 2025. A expansão visa aumentar a competitividade e dar oportunidade para mais países participarem da principal competição anual de vôlei. As novas equipes serão definidas através de torneios classificatórios regionais.",
      imagemUrl: "https://example.com/vnl-2025.jpg",
      autor: "FIVB News",
      dataPublicacao: DateTime.now().subtract(Duration(days: 10)),
      tags: ["VNL", "FIVB", "expansão", "competição"],
    ),
    Noticia(
      titulo: "Tabela da Liga das Nações de Vôlei (VNL) Feminino 2025",
      conteudo: "A Federação Internacional de Voleibol divulgou a tabela oficial da Liga das Nações Feminina 2025. A competição terá início em maio e se estenderá até julho, com fases em diferentes países. A seleção brasileira fará sua estreia contra a Itália, em partida que promete ser um dos destaques da primeira semana de competição.",
      imagemUrl: "https://example.com/tabela-vnl.jpg",
      autor: "Vôlei Internacional",
      dataPublicacao: DateTime.now().subtract(Duration(days: 12)),
      tags: ["VNL", "tabela", "feminino", "2025"],
    ),
  ];

  // Método para popular a coleção com notícias de exemplo
  static Future<void> popularNoticiasExemplo() async {
    try {
      print('Iniciando população da coleção de notícias com dados de exemplo...');
      
      for (Noticia noticia in noticiasExemplo) {
        try {
          String id = await _noticiasService.criarNoticia(noticia);
          print('Notícia criada com sucesso: ${noticia.titulo} (ID: $id)');
        } catch (e) {
          print('Erro ao criar notícia "${noticia.titulo}": $e');
        }
      }
      
      print('População da coleção de notícias concluída!');
    } catch (e) {
      print('Erro geral ao popular notícias de exemplo: $e');
    }
  }

  // Método para verificar se a coleção já tem dados
  static Future<bool> verificarSeColecaoVazia() async {
    try {
      List<Noticia> noticias = await _noticiasService.buscarTodasNoticias();
      return noticias.isEmpty;
    } catch (e) {
      print('Erro ao verificar se coleção está vazia: $e');
      return true; // Assume que está vazia em caso de erro
    }
  }

  // Método para popular apenas se a coleção estiver vazia
  static Future<void> popularSeVazia() async {
    bool estaVazia = await verificarSeColecaoVazia();
    if (estaVazia) {
      print('Coleção de notícias está vazia. Populando com dados de exemplo...');
      await popularNoticiasExemplo();
    } else {
      print('Coleção de notícias já possui dados. Pulando população de exemplo.');
    }
  }
}