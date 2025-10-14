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

  // Definindo as cores principais para facilitar a manutenção
  static const Color primaryColor = Color(0xFF14276B); // Azul Marinho
  static const Color accentColor = Color(0xFFFFCC00); // Amarelo/Âmbar

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
        return Historia();
      case 2:
        return Regras();
      case 3:
        return Rodizios();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: accentColor,
        unselectedItemColor: primaryColor,
        // Remover unselectedLabelStyle se a cor já foi definida em unselectedItemColor
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
            label: 'Rodízios',
          ),
        ],
      ),
    );
  }

  // Conteúdo dos Fundamentos (Mantido)
  Widget _buildFundamentosContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20), // Padding no final
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          const Text(
            "Fundamentos do Voleibol",
            style: TextStyle(
              color: primaryColor,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),

          // Lista dos Cards de Fundamentos
          _buildFundamentoCard(
            context,
            titulo: "Saque",
            texto:
                "O saque é a ação que inicia cada rally (jogo de pontos) e consiste em lançar a bola por cima do seu corpo e golpeá-la para que ela atravessar a rede e caia na quadra adversária.",
            imagePath: 'assets/images/Saque.jpg',
            isImageLeft: false, // Imagem à direita
          ),
          _buildFundamentoCard(
            context,
            titulo: "Ataque",
            texto:
                "O ataque, é a finalização ofensiva do jogo. O jogador salta e golpeia a bola com a mão ou o braço, com a intenção de marcar um ponto.",
            imagePath: 'assets/images/ataque.jpg',
            isImageLeft: true, // Imagem à esquerda
          ),
          _buildFundamentoCard(
            context,
            titulo: "Bloqueio",
            texto:
                "O bloqueio é uma técnica defensiva que visa impedir ou dificultar o ataque do adversário. Um ou mais jogadores se posicionam na rede, levantando as mãos para bloquear a passagem da bola.",
            imagePath: 'assets/images/bloqueio.jpg',
            isImageLeft: false, // Imagem à direita
          ),
          _buildFundamentoCard(
            context,
            titulo: "Levantamento",
            texto:
                "O levantamento, ou toque, é uma técnica que consiste em levantar a bola para cima e em um ponto adequado para o ataque do jogador da sua equipe.",
            imagePath: 'assets/images/levantamento2.jpg',
            isImageLeft: true, // Imagem à esquerda
          ),
          _buildFundamentoCard(
            context,
            titulo: "Recepção",
            texto:
                "A recepção, ou passe, é uma técnica defensiva que visa receber o saque do adversário ou uma bola vinda da quadra contrária e passá-la para um companheiro, geralmente o levantador, para iniciar a jogada ofensiva.",
            imagePath: 'assets/images/recepcao.jpg',
            isImageLeft: false, // Imagem à direita
          ),
        ],
      ),
    );
  }

  // 🔥 NOVO: Widget Card com imagem e texto lado a lado (CORREÇÃO DE RESPONSIVIDADE)
  Widget _buildFundamentoCard(
    BuildContext context, {
    required String titulo,
    required String texto,
    required String imagePath,
    required bool isImageLeft,
  }) {
    // Conteúdo da Imagem
    final Widget imageContent = Flexible(
      // Usamos Flexible para permitir que ocupe espaço sem overflow
      flex: 2, // Damos uma flexibilidade de 2 para a imagem (ex: 40% do espaço)
      child: Container(
        height: 180, // Mantive a altura fixa para consistência visual
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            width: double.infinity, // Ocupa a largura total do Flexible
          ),
        ),
      ),
    );

    // Conteúdo do Texto
    final Widget textContent = Flexible(
      // Usamos Flexible para permitir que ocupe espaço sem overflow
      flex: 3, // Damos uma flexibilidade de 3 para o texto (ex: 60% do espaço)
      child: Padding(
        // Adicionamos padding interno para o texto
        padding: const EdgeInsets.symmetric(horizontal: 12.0), // Padding menor
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              texto,
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ],
        ),
      ),
    );

    // Define a ordem dos widgets na Row
    final List<Widget> children =
        isImageLeft ? [imageContent, textContent] : [textContent, imageContent];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        // Padding interno do Card
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}
