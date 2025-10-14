import 'package:flutter/material.dart';

class Regras extends StatefulWidget {
  const Regras({super.key});

  @override
  State<Regras> createState() => _RegrasState();
}

class _RegrasState extends State<Regras> {
  // Definindo as cores principais para facilitar a manutenção
  static const Color primaryColor = Color(0xFF14276B); // Azul Marinho
  static const Color accentColor = Color(0xFFFFCC00); // Amarelo/Âmbar

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          const Text(
            "Regras Essenciais do Vôlei",
            style: TextStyle(
                color: primaryColor, fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),

          // Cards das Regras
          _buildRegraCard(
            context,
            titulo: "Área de Jogo",
            texto:
                "A área de jogo do vôlei é formada pela quadra e a zona livre. A quadra tem 18m de comprimento por 9m de largura. A rede é instalada verticalmente sobre a linha central, com altura de 2,43m para homens e 2,24m para mulheres.",
            imagePath: 'assets/images/area_volei.jpg',
          ),
          _buildRegraCard(
            context,
            titulo: "Equipamentos",
            texto:
                "Os equipamentos necessários no vôlei são:\n\n- Camiseta\n- Calção/shorts\n- Meias (líbero deve usar meia diferente)\n- Joelheira\n- Calçado esportivo",
            imagePath: 'assets/images/equipamentos.jpg',
          ),
          _buildRegraCard(
            context,
            titulo: "Quantidade de Jogadores",
            texto:
                "Uma equipe de vôlei tem 12 jogadores, sendo que 6 entram em quadra. A equipe é formada por técnico, assistentes, médico e fisioterapeuta. Podem ser realizadas até seis substituições por set.",
            imagePath: 'assets/images/jogo-3.jpg',
          ),
          _buildRegraCard(
            context,
            titulo: "Pontuação no Vôlei",
            texto:
                "A vitória em um set é definida quando uma equipe atinge 25 pontos com no mínimo 2 pontos de vantagem. Vence a partida a equipe que ganhar 3 sets. Se houver empate de 2 a 2, o quinto set (tie-break) é jogado até 15 pontos, mantendo a regra da diferença mínima de 2 pontos.",
            imagePath: 'assets/images/placar.jpg',
          ),
          _buildRegraCard(
            context,
            titulo: "Toques no Vôlei",
            texto:
                "Cada equipe tem o direito de realizar no máximo três toques (além do bloqueio) para enviar a bola ao campo adversário. A bola pode tocar em qualquer parte do corpo, desde que o contato seja contínuo (não pode haver dois toques sequenciais pelo mesmo jogador).",
            imagePath: 'assets/images/fotos2.jpg',
          ),
          _buildRegraCard(
            context,
            titulo: "Principais Faltas",
            texto:
                "As faltas incluem: \n\n **Dois toques:** Jogador toca duas vezes seguidas. \n **De posição/rotação:** Jogador fora de sua posição na ordem de saque. \n **Quatro toques:** Equipe realiza mais de três toques. \n **Condução:** A bola é retida ou lançada, e não rebatida. \n **Rede:** Jogador toca a rede (exceto a parte inferior durante o bloqueio).",
            imagePath: 'assets/images/faltas.jpg',
          ),
          _buildRegraCard(
            context,
            titulo: "Evolução das Regras",
            texto:
                "As regras são atualizadas para manter o esporte atrativo. Uma grande mudança foi a criação da posição do Líbero em 1998, um jogador especializado em defesa e recepção que não pode atacar ou sacar, equilibrando o jogo que estava se tornando dominado pelo ataque.",
            imagePath: 'assets/images/evolucao.jpg',
          ),
        ],
      ),
    );
  }

  // 🔥 NOVO: Widget Card para exibir cada Regra
  Widget _buildRegraCard(
    BuildContext context, {
    required String titulo,
    required String texto,
    required String imagePath,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      elevation: 6, // Elevação suave
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Área de Título Destacada
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: const BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Text(
              titulo,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          // Imagem (Responsiva)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                // Ocupa a largura máxima disponível no Card, garantindo responsividade
                width: MediaQuery.of(context).size.width,
                height: 200, // Altura padrão para imagens
              ),
            ),
          ),

          // Texto (Responsivo)
          Padding(
            padding:
                const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: Text(
              texto,
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

// REMOVIDO: A função 'container' antiga e 'textCreator' foram removidas, 
// pois foram substituídas pelo '_buildRegraCard' para um layout mais moderno e limpo.