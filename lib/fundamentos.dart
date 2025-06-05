import 'package:flutter/material.dart';
import 'package:volleyball_center_mobile/historia.dart';
import 'package:volleyball_center_mobile/navbar.dart';
import 'package:volleyball_center_mobile/regras.dart';

class Fundamentos extends StatefulWidget {
  const Fundamentos({super.key});

  @override
  State<Fundamentos> createState() => _FundamentosState();
}

class _FundamentosState extends State<Fundamentos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //        appBar: const Navbar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20.0,
            ),
          ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Fundamentos()),
            );
          },
          child: Text('Fundamentos'),
        ),
             ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Historia()),
            );
          },
          child: Text('História'),
        ),
          ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Regras()),
            );
          },
          child: Text('Regras'),
        ),
          
                SizedBox(
              height: 20,
            ),
            container("Saque",
                "O saque é a ação que inicia cada rally (jogo de pontos) e consiste em lançar a bola por cima do seu corpo e golpeá-la para que ela atravessar a rede e caia na quadra adversária."),
            Center(
              child: Image(
                  height: 300,
                  width: 300,
                  image: AssetImage('assets/images/Saque.jpg')),
            ),
            container("Ataque",
                "O ataque, é a finalização ofensiva do jogo. O jogador salta e golpeia a bola com a mão ou o braço, com a intenção de marcar um ponto."),
            Center(
              child: Image(
                  height: 300,
                  width: 300,
                  image: AssetImage('assets/images/ataque.jpg')),
            ),
            container("Bloqueio",
                "O bloqueio é uma técnica defensiva que visa impedir ou dificultar o ataque do adversário. Um ou mais jogadores se posicionam na rede, levantando as mãos para bloquear a passagem da bola."),
            Center(
              child: Image(
                  height: 300,
                  width: 300,
                  image: AssetImage('assets/images/bloqueio.jpg')),
            ),
            container("Levantamento",
                "O levantamento, ou toque, é uma técnica que consiste em levantar a bola para cima e em um ponto adequado para o ataque do jogador da sua equipe."),
            Center(
              child: Image(
                  height: 300,
                  width: 300,
                  image: AssetImage('assets/images/levantamento2.jpg')),
            ),
            container("Recepção",
                "A recepção, ou passe, é uma técnica defensiva que visa receber o saque do adversário ou uma bola vinda da quadra contrária e passá-la para um companheiro, geralmente o levantador, para iniciar a jogada ofensiva. "),
            Center(
              child: Image(
                  height: 300,
                  width: 300,
                  image: AssetImage('assets/images/recepcao.jpg')),
            ),
        ],
        )
           ),
      );
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
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }
}
