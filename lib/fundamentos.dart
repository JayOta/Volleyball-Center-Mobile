import 'package:flutter/material.dart';
import 'package:volleyball_center_mobile/historia.dart';
import 'package:volleyball_center_mobile/regras.dart';
import 'package:volleyball_center_mobile/rodizios.dart';

class Fundamentos extends StatefulWidget {
  const Fundamentos({super.key});

  @override
  State<Fundamentos> createState() => _FundamentosState();
}

class _FundamentosState extends State<Fundamentos> {
  int _selectedIndex = 0; // 0 = Fundamentos, 1 = História, 2 = Regras

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildFundamentosContent();
      case 1:
        return Historia(); // Certifique-se que Historia é um Widget pronto
      case 2:
        return Regras(); // Certifique-se que Regras é um Widget pronto
      case 3:
        return Rodizios();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Scaffold(
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Color(0xffffcce00),
        unselectedItemColor: Color(0xFF14276B),
        unselectedLabelStyle: TextStyle(color: Color(0xFF14276B)),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_volleyball),
            label: 'Fundamentos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'História',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rule),
            label: 'Regras',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.change_circle),
            label: 'Rodizios',
          ),
        ],
      ),
    ));
  }

  Widget _buildFundamentosContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Center(
            child: Text(
              "Fundamentos",
              style: TextStyle(color: Color(0xFF14276B), fontSize: 25),
            ),
          ),
          const SizedBox(height: 20),
          container("Saque",
              "O saque é a ação que inicia cada rally (jogo de pontos) e consiste em lançar a bola por cima do seu corpo e golpeá-la para que ela atravessar a rede e caia na quadra adversária."),
          Center(
            child:
                Image.asset('assets/images/Saque.jpg', height: 300, width: 300),
          ),
          container("Ataque",
              "O ataque, é a finalização ofensiva do jogo. O jogador salta e golpeia a bola com a mão ou o braço, com a intenção de marcar um ponto."),
          Center(
            child: Image.asset('assets/images/ataque.jpg',
                height: 300, width: 300),
          ),
          container("Bloqueio",
              "O bloqueio é uma técnica defensiva que visa impedir ou dificultar o ataque do adversário. Um ou mais jogadores se posicionam na rede, levantando as mãos para bloquear a passagem da bola."),
          Center(
            child: Image.asset('assets/images/bloqueio.jpg',
                height: 300, width: 300),
          ),
          container("Levantamento",
              "O levantamento, ou toque, é uma técnica que consiste em levantar a bola para cima e em um ponto adequado para o ataque do jogador da sua equipe."),
          Center(
            child: Image.asset('assets/images/levantamento2.jpg',
                height: 300, width: 300),
          ),
          container("Recepção",
              "A recepção, ou passe, é uma técnica defensiva que visa receber o saque do adversário ou uma bola vinda da quadra contrária e passá-la para um companheiro, geralmente o levantador, para iniciar a jogada ofensiva."),
          Center(
            child: Image.asset('assets/images/recepcao.jpg',
                height: 300, width: 300),
          ),
          // Center(
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       card("Saque", "Ver fundamento", "assets/images/Saque.jpg", 150,
          //           120),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Column container(String titulo, String texto) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            titulo,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            texto,
            textAlign: TextAlign.justify,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Column card(String cardText, String cardTextButton, String imagePath,
      double imageHeight, double imageWidth) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // Linha
          children: [
            Container(
              width: 420,
              height: 250,
              decoration: BoxDecoration(
                color: Color(0xFF14276B),
              ),
              margin: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // Esquerda e Direita
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // Esquerda
                    children: [
                      Text(
                        cardText,
                        style:
                            TextStyle(color: Color(0xFFFFFFFF), fontSize: 16),
                      ),
                      SizedBox(height: 90),
                      TextButton(
                          style: ButtonStyle(
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    8), // Aqui está o BorderRadius
                              ),
                            ),
                            backgroundColor: WidgetStatePropertyAll(
                              Color(0xffffcce00),
                            ),
                            padding:
                                WidgetStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.all(15),
                            ),
                          ),
                          onPressed: () {},
                          child: Text(
                            cardTextButton,
                            style: TextStyle(
                                color: Color(0xFFFFFFFF), fontSize: 12),
                          )),
                    ],
                  ),
                  Expanded(
                      child: Image.asset(imagePath,
                          height: imageHeight, width: imageWidth)),
                  // Direita
                ],
              ),
            ), // Card 1
          ],
        ),
      ],
    );
  }
}
