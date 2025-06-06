import 'package:flutter/material.dart';
import 'package:volleyball_center_mobile/navbar.dart';

class Historia extends StatelessWidget {
  const Historia({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Center(
              child: Text(
                "Origem do vôlei",
                style: TextStyle(color: Color(0xFF14276B), fontSize: 25),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Text(
                "\u00A0\u00A0\u00A0   William George Morgan, professor e diretor de Educação Física na Associação Cristã de Moços (ACM), idealizou um jogo em que as probabilidades dos participantes se machucarem, em detrimento de contato físico, fossem baixas. Outro fator importante, pensado nos jogadores mais velhos, era que o esporte não fosse fisicamente tão exigente.",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
              child: Text(
                "\u00A0\u00A0\u00A0  Na época, o basquetebol estava na moda. Havia sido criado 4 anos antes, em 1891, também por um professor de educação física da Associação Cristã dos Moços.",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Text(
                "\u00A0\u00A0\u00A0 E assim surgiu o vôlei, chamado de mintonette que, graças ao fato de cada uma das equipes ficarem separadas por uma rede, trazia menos chances de lesões. Além disso, era menos exigente em termos físicos do que o basquetebol. O vôlei, no entanto, era muito completo, pois compreendia uma série de exercícios benéficos para a saúde.",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
              child: Text(
                "\u00A0\u00A0\u00A0 Em seguida, foi a vez de tratar das regras do jogo. Para tanto, Morgan contou com o auxílio de dois amigos, Dr. Frank Wood e John Lynch.",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Text(
                "\u00A0\u00A0\u00A0 Nessa ocasião, a alteração do nome “mintonette” para “volley ball” foi sugerida pelo professor Alfred T. Halstead, porque os movimentos do novo jogo sugeriam isso, um voleio, ou seja, uma jogada feita no ar. Por fim, os conselheiros receberem uma cópia das regras do jogo, e uma equipe ficou responsável por estudá-las e sugerir melhorias.",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                "A chegada do vôlei em vários países",
                style: TextStyle(color: Color(0xFF14276B), fontSize: 25),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Text(
                "\u00A0\u00A0\u00A0 Dos Estados Unidos da América, o vôlei seguiu para o Canadá, chegando à América do Sul em 1910. O primeiro país sul-americano a conhecê-lo foi o Peru, e em 1915 foi a vez do Brasil. Em 1951, foi no Brasil que o primeiro campeonato sul-americano de vôlei foi disputado.",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
              child: Text(
                "\u00A0\u00A0\u00A0 Em 20 de abril de 1947 foi fundada a Federação Internacional de Voleibol (FIVB), que teve como primeiro presidente Paul Libaud. Quando fundada, tinha 14 membros: Brasil, Bélgica, Egito, Estados Unidos, França, Holanda, Hungria, Itália, Iugoslávia, Polônia, Portugal, Romênia, Checoslováquia e Uruguai. Atualmente, a FIVB conta com 163 países filiados.",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Text(
                "\u00A0\u00A0\u00A0 A FIVB é o órgão responsável por todas as questões que envolvem o voleibol, tais como a organização de torneios e congressos, além de oferecer cursos para árbitros e treinadores.",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
              child: Text(
                "\u00A0\u00A0\u00A0 Dois anos depois da fundação da Federação, em 1949, realizou-se o primeiro campeonato de vôlei masculino na Checoslováquia, o qual foi conquistado pelos russos. Em 1952 foi a vez das mulheres disputarem pela primeira vez um campeonato de voleibol, sendo o título conquistado pelas russas.",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Text(
                "\u00A0\u00A0\u00A0 Quase 70 anos após a sua criação, a partir de 1964, o vôlei passou a integrar os jogos olímpicos. A Rússia foi o primeiro campeão olímpico do vôlei masculino, quando a Checoslováquia ficou com a prata e o Japão, com o bronze.",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
