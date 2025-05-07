import 'package:flutter/material.dart';

class Fundamentos extends StatefulWidget {
  const Fundamentos({super.key});

  @override
  State<Fundamentos> createState() => _FundamentosState();
}

class _FundamentosState extends State<Fundamentos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15.0,),
          Center(child: Text("Fundamentos",
              style: TextStyle(color: Color(0xFF14276B), fontSize: 25)),),

          SizedBox(height: 20.0,),
          Padding(
            padding: EdgeInsets.only(left: 16.0),
          child: Text("Saque", style: TextStyle(fontSize: 20),),
          ),
          SizedBox(height: 10.0,),
          Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Text("O saque é a ação que inicia cada rally (jogo de pontos) e consiste em lançar a bola por cima do seu corpo e golpeá-la para que ela atravessar a rede e caia na quadra adversária.",   textAlign: TextAlign.justify, style: TextStyle(fontSize: 14),),
          ),
          SizedBox(height: 25.0,),
          Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text("Ataque", style: TextStyle(fontSize: 20),),
          ),
            SizedBox(height: 10.0,),
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text("O ataque, é a finalização ofensiva do jogo. O jogador salta e golpeia a bola com a mão ou o braço, com a intenção de marcar um ponto.",   textAlign: TextAlign.justify, style: TextStyle(fontSize: 14),),
            ),
              SizedBox(height: 25.0,),
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text("Bloqueio", style: TextStyle(fontSize: 20),),
              ),
            SizedBox(height: 10.0,),
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text("O bloqueio é uma técnica defensiva que visa impedir ou dificultar o ataque do adversário. Um ou mais jogadores se posicionam na rede, levantando as mãos para bloquear a passagem da bola.",  textAlign: TextAlign.justify, style: TextStyle(fontSize: 14),),
            ),
          SizedBox(height: 25.0,),
          Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text("Levantamento", style: TextStyle(fontSize: 20),),
          ),
          SizedBox(height: 10.0,),
          Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Text("O levantamento, ou toque, é uma técnica que consiste em levantar a bola para cima e em um ponto adequado para o ataque do jogador da sua equipe. ",  textAlign: TextAlign.justify, style: TextStyle(fontSize: 14),),
          ),
          SizedBox(height: 25.0,),
          Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text("Recepção", style: TextStyle(fontSize: 20),),
          ),
          SizedBox(height: 10.0,),
          Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Text("A recepção, ou passe, é uma técnica defensiva que visa receber o saque do adversário ou uma bola vinda da quadra contrária e passá-la para um companheiro, geralmente o levantador, para iniciar a jogada ofensiva. ",  textAlign: TextAlign.justify, style: TextStyle(fontSize: 14),),
          ),
        ],
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
}
