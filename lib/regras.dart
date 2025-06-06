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
            SizedBox(
              height: 20,
            ),
            container("Área de jogo",
                "A área de jogo do vôlei é formada pela quadra de jogo e a zona livre. A quadra de vôlei contém 18 metros de comprimento por 9 metros de largura, sendo retangular e simétrica. A superfície da quadra deve ser plana, horizontal e sem quaisquer irregularidades que possam prejudicar a realização da prática. A rede é instalada verticalmente sobre a linha central. Sua altura difere de acordo com o gênero, para homens é de 2,43 metros e para mulheres, 2,24 metros."),
            Center(
              child: Image(
                  height: 300,
                  width: 300,
                  image: AssetImage('images/area_volei.jpg')),
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
      SizedBox(
        height: 20.0,
      ),
    ],
  );
}
