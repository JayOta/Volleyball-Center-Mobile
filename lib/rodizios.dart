import 'package:flutter/material.dart';
import 'package:volleyball_center_mobile/navbar.dart';

class Rodizios extends StatefulWidget {
  const Rodizios({super.key});

  @override
  State<Rodizios> createState() => _RodiziosState();
}

class _RodiziosState extends State<Rodizios> {
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
              child: Text("Sistemas de rodízios",
                  style: TextStyle(color: Color(0xFF14276B), fontSize: 25)),
            ),
               container("Rodízio 6x0",
                "No sistema 6x0, também chamado de sistema 6x6, todos farão a função tanto de levantadores como de atacantes ou defensores. É o sistema mais simples de todos, é normalmente usado em equipes que estão iniciando o treinamento no esporte."),
            Center(
              child: Image(
                  height: 300,
                  width: 300,
                  image: AssetImage('images/rod-6x0.jpg')),
            ),
                  container("Rodízio 6x0 com infiltração",
                "A grande inovação do sistema 6x0 com infiltração é exatamente a movimentação de infiltração do jogador da posição 1, que torna-se o Levantador da equipe quando está estiver recebendo o Saque. O jogador que ocupar a posição 1, nesse sistema,   nunca deve participar da recepção do Saque."),
            Center(
              child: Image(
                  height: 300,
                  width: 300,
                  image: AssetImage('images/rod-6x0-infiltracao.jpg')),
            ),
                container("Rodízio 5x1",
                "O sistema 4x2 pode ser dividido entre o 4x2 simples ou com infiltração. No 4x2 simples há dois levantadores, que se colocam nas posições diagonais da quadra, mais quatro atacantes. Com esse sistema, há sempre um levantador na rede juntamente com dois atacantes."),
            Center(
              child: Image(
                  height: 300,
                  width: 300,
                  image: AssetImage('images/rod-5x1.jpg')),
            ),
            container("Rodízio 4x2",
                "O sistema 4x2 pode ser dividido entre o 4x2 simples ou com infiltração. No 4x2 simples há dois levantadores, que se colocam nas posições diagonais da quadra, mais quatro atacantes. Com esse sistema, há sempre um levantador na rede juntamente com dois atacantes."),
            Center(
              child: Image(
                  height: 300,
                  width: 300,
                  image: AssetImage('images/rod-4x2.jpg')),
            ),
               container("Rodízio 4x2 com líbero",
                "Neste rodízio, as 4 jogadoras rotativas são as atacantes e as centrais, enquanto as 2 jogadoras fixas são as levantadoras. A cada troca de saque, 2 atacantes e 2 centrais se movimentam no sentido horário, alternando suas posições na quadra. Já as 2 levantadoras ficam sempre nas mesmas posições, 2 e 5, não rodando. O líbero entra na posição mais recuada, substituindo uma das levantadoras."),
            Center(
              child: Image(
                  height: 300,
                  width: 300,
                  image: AssetImage('images/rod-4x2-libero.jpg')),
            ),
                container("Rodízio 4x2 com infiltração",
                "No 4x2 invertido, também chamado de 4x2 com infiltração, (uma vez que há 4 atacantes e 2 levantadoras em quadra), também há dois levantadores e eles também se posicionam em diagonal. No entanto, o levantador que está na zona de ataque se tornará disponível para o ataque e o que estiver na zona de defesa infiltrará, ou seja, passará da zona em que ele está para a zona de ataque para efetuar o levantamento. Assim, sempre haverá 3 atacantes na rede."),
            Center(
              child: Image(
                  height: 300,
                  width: 300,
                  image: AssetImage('images/rod-4x2-infiltracao.jpg')),
            ),
          ]
      ),
    );
  }
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
