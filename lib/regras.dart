import 'package:flutter/material.dart';
import 'package:volleyball_center_mobile/navbar.dart';

class Regras extends StatefulWidget {
  const Regras({super.key});

  @override
  State<Regras> createState() => _RegrasState();
}

class _RegrasState extends State<Regras> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text("Regras do vôlei",
                  style: TextStyle(color: Color(0xFF14276B), fontSize: 25)),
            ),
          
            container("Área de jogo",
                "A área de jogo do vôlei é formada pela quadra de jogo e a zona livre. A quadra de vôlei contém 18 metros de comprimento por 9 metros de largura, sendo retangular e simétrica. A superfície da quadra deve ser plana, horizontal e sem quaisquer irregularidades que possam prejudicar a realização da prática. A rede é instalada verticalmente sobre a linha central. Sua altura difere de acordo com o gênero, para homens é de 2,43 metros e para mulheres, 2,24 metros."),
            Center(
              child: Image(
                  height: 300,
                  width: 300,
                  image: AssetImage('images/area_volei.jpg')),
            ),
            container("Equipamentos",
                "Os equipamentos necessários no vôlei são: \n\n Camiseta \n\n Calção/shorts \n\n Meias (líbero deve usar meia diferente) \n\n Joelheira \n\n Calçado esportivo"),
            Center(
              child: Image(
                  height: 300,
                  width: 300,
                  image: AssetImage('images/equipamentos.jpg')),
            ),
            container("Quantidade de jogadores no vôlei",
                "Uma equipe de vôlei tem 12 jogadores, sendo que entram em quadra 6 jogadores. Além dos competidores, o time é formado por outros profissionais: \n\n Comissão técnica: um técnico/treinador e até dois assistentes técnicos. \n\n Corpo médico: um médico e um fisioterapeuta. Um dos atletas é definido como capitão da equipe. Ao longo de um set, podem ser realizadas até seis substituições. \n\n O set é uma fase de uma partida de vôlei."),
            Center(
              child: Image(
                  height: 300,
                  width: 300,
                  image: AssetImage('images/jogo-3.jpg')),
            ),
            container("Pontuação no vôlei",
                "O jogo de vôlei é formado por sets. A vitória de um set será definida quando uma das equipes atingir 25 pontos. Vence a partida a equipe que ganhar 3 sets. Caso ocorra um empate de 24 a 24 pontos, vence o time que conseguir uma vantagem de 2 pontos primeiro. Quando ocorre um empate de 2 sets a 2 sets, haverá um quinto set com 15 pontos. E o critério do empate é definido em caso de 14 a 14, com a equipe vencedora atingindo primeiro a diferença mínima de 2 pontos. \n\n  O rally é formado por todas ações de jogo, desde o saque da bola até a marcação de um ponto, seja por um ataque direto, seja porque a bola sai da quadra e gera ponto para o time adversário."),
            Center(
              child: Image(
                  height: 300,
                  width: 300,
                  image: AssetImage('images/placar.jpg')),
            ),
            container("Toques no vôlei",
                "Os toques são quaisquer ações de contato realizadas por um jogador com a bola em quadra. Cada equipe tem o direito de realizar no máximo três toques, além do bloqueio, para arremessar a bola no campo adversário. A bola pode tocar em qualquer parte do corpo desde que esse contato seja de forma contínua, ou seja, ela não pode bater em alguma parte e retornar ao corpo do jogador."),
            Center(
              child: Image(
                  height: 300,
                  width: 300,
                  image: AssetImage('images/fotos2.jpg')),
            ),
            container("Faltas no vôlei",
                "Dois toques: quando o jogador toca duas vezes na bola ou ela toca em partes de seu corpo (duas vezes, sem continuar o contato). \n\n De posição: quando o jogador não ocupa corretamente sua posição na quadra. \n\n De rotação: quando o saque não é feito de acordo com a ordem correta definida pela rotação. \n\n Quatro toques: quando a equipe realiza quatro toques antes de encaminhar a bola para o outro campo. \n\n Toque apoiado: quando o jogador se apoia em outro membro de sua equipe, ou quando ele se apoia em alguma estrutura do jogo ou objeto. \n\n Condução: quando a bola é retida ou lançada, isto é, ela não é rebatida pelo toque do jogador. \n\n Rede: quando o jogador toca a rede."),
            Center(
              child: Image(
                  height: 300,
                  width: 300,
                  image: AssetImage('images/faltas.jpg')),
            ),
            container("Evolução das regras de vôlei",
                "A atualização das regras é fundamental para que a prática esportiva se mantenha atrativa, tanto para jogadores quanto para os espectadores e, consequentemente, para o setor comercial e os diretores das equipes profissionais. \n\n  Uma das mudanças que impactaram o esporte foi a criação da posição do líbero, em 1998. A novidade foi incluída no vôlei, pois o esporte se caracterizava por ataques eficientes, entretanto, carecia de ferramentas de defesa. Nesse sentido, o jogador líbero passou a atuar exclusivamente na assistência e defesa durante as partidas."),
            Center(
              child: Image(
                  height: 300,
                  width: 300,
                  image: AssetImage('images/evolucao.jpg')),
            ),
          ]),
    );
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

Column container(String titulo, String texto) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.only(left: 16.0),
        child: Text(
          titulo,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(
        height: 10.0,
      ),
      Padding(
        padding: EdgeInsets.only(left: 16.0, right: 30.0),
        child: Text(
          texto,
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 14),
        ),
      ),
  
    ],
  );
}
