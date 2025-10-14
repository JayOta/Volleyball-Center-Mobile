import 'package:flutter/material.dart';

class Rodizios extends StatefulWidget {
  const Rodizios({super.key});

  @override
  State<Rodizios> createState() => _RodiziosState();
}

class _RodiziosState extends State<Rodizios> {
  // Cores Padrão
  static const Color primaryColor = Color(0xFF14276B); // Azul Marinho
  static const Color accentColor = Color(0xFFFFCC00); // Amarelo/Âmbar

  // Dados de Rodízios
  final List<Map<String, String>> _rotations = [
    {
      "titulo": "Rodízio 6x0",
      "texto":
          "No sistema 6x0, também chamado de sistema 6x6, todos farão a função tanto de levantadores como de atacantes ou defensores. É o sistema mais simples de todos, é normalmente usado em equipes que estão iniciando o treinamento no esporte.",
      "imagem": 'assets/images/rod-6x0.jpg'
    },
    {
      "titulo": "Rodízio 6x0 com infiltração",
      "texto":
          "A grande inovação do sistema 6x0 com infiltração é exatamente a movimentação de infiltração do jogador da posição 1, que torna-se o Levantador da equipe quando está estiver recebendo o Saque. O jogador que ocupar a posição 1, nesse sistema, nunca deve participar da recepção do Saque.",
      "imagem": 'assets/images/rod-6x0-infiltracao.jpg'
    },
    {
      "titulo": "Rodízio 5x1",
      "texto":
          "O 5x1 utiliza um levantador fixo e cinco atacantes. O levantador se 'infiltra' da zona de defesa para a zona de ataque, garantindo que a equipe tenha sempre três atacantes na rede. É o sistema mais usado no alto rendimento.",
      "imagem": 'assets/images/rod-5x1.jpg'
    },
    {
      "titulo": "Rodízio 4x2",
      "texto":
          "O sistema 4x2 simples tem dois levantadores que se colocam em posições diagonais e quatro atacantes. Sempre haverá um levantador na rede juntamente com dois atacantes.",
      "imagem": 'assets/images/rod-4x2.jpg'
    },
    {
      "titulo": "Rodízio 4x2 com líbero",
      "texto":
          "Neste rodízio, 4 jogadores são atacantes e centrais, e 2 são levantadores fixos (não rodam). O líbero entra na posição mais recuada, substituindo um dos levantadores, focando na defesa.",
      "imagem": 'assets/images/rod-4x2-libero.jpg'
    },
    {
      "titulo": "Rodízio 4x2 com infiltração",
      "texto":
          "Também chamado de 4x2 invertido, o levantador que estiver na zona de defesa se infiltra para a zona de ataque para levantar. Assim, a equipe sempre garante 3 atacantes na rede.",
      "imagem": 'assets/images/rod-4x2-infiltracao.jpg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Fundo leve
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
            top: 20.0, left: 16.0, right: 16.0, bottom: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Título principal estilizado
            const Center(
              child: Text(
                "Sistemas de Rodízios",
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),

            // Mapeia cada rodízio para o novo Card responsivo
            ..._rotations.map((rotation) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: _buildRotationCard(
                  context,
                  rotation["titulo"]!,
                  rotation["texto"]!,
                  rotation["imagem"]!,
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  // Novo Widget: Card Responsivo para cada Rodízio
  Widget _buildRotationCard(
      BuildContext context, String titulo, String texto, String imagemPath) {
    // Define um breakpoint para mudar o layout
    final isLargeScreen = MediaQuery.of(context).size.width > 600;

    // Componente da Imagem com tamanho fixo
    final imageWidget = ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 200, // Altura fixa
        width: isLargeScreen ? 200 : double.infinity, // L: 200px, S: Max
        color: Colors.grey[200],
        child: Image.asset(
          imagemPath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Center(
              child: Icon(Icons.image_not_supported,
                  size: 50, color: Colors.grey)),
        ),
      ),
    );

    // Componente do Texto
    final textWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título
        Text(
          titulo,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
        ),
        const SizedBox(height: 8.0),
        // Descrição
        Text(
          texto,
          textAlign: TextAlign.justify,
          style: const TextStyle(fontSize: 15, height: 1.4),
        ),
      ],
    );

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLargeScreen
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3, // Ocupa mais espaço para o texto
                    child: textWidget,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2, // Ocupa menos espaço para a imagem
                    child: imageWidget,
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textWidget,
                  const SizedBox(height: 16),
                  imageWidget, // Imagem abaixo do texto em telas pequenas
                ],
              ),
      ),
    );
  }
}
