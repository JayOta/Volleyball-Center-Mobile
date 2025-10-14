import 'package:flutter/material.dart';
import 'package:volleyball_center_mobile/navbar.dart';
import 'produto_pagina.dart';

class Loja extends StatefulWidget {
  const Loja({super.key});

  @override
  State<Loja> createState() => _LojaState();
}

class _LojaState extends State<Loja> {
  // Lista de produtos para facilitar a iteração no GridView
  final List<Map<String, String>> products = const [
    {
      "nome": "Bola de vôlei Penalty",
      "preco": "R\$ 249,99",
      "imagem": "assets/images/bola.jpg"
    },
    {
      "nome": "Tênis de vôlei",
      "preco": "R\$ 299,99",
      "imagem": "assets/images/tenis.jpg"
    },
    {
      "nome": "Joelheira",
      "preco": "R\$ 99,99",
      "imagem": "assets/images/joelheira.jpg"
    },
    {
      "nome": "Manguito de Vôlei",
      "preco": "R\$ 39,99",
      "imagem": "assets/images/manguito.jpg"
    },
    {
      "nome": "Meias",
      "preco": "R\$ 29,99",
      "imagem": "assets/images/meias.jpg"
    },
    {
      "nome": "Marcador de pontos",
      "preco": "R\$ 99,99",
      "imagem": "assets/images/placar.jpg"
    },
    {
      "nome": "Faixa",
      "preco": "R\$ 29,99",
      "imagem": "assets/images/faixa.jpg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(
            16.0), // Adiciona padding ao SingleChildScrollView
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20.0),
            const Center(
              child: Text(
                "Catálogo de produtos",
                style: TextStyle(
                  color: Color(0xFF14276B),
                  fontSize: 25,
                  fontWeight: FontWeight
                      .bold, // Adicionei bold para melhorar a visibilidade
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 🔥 WIDGET RESPONSIVO: Substitui os múltiplos Rows
            GridView.count(
              physics:
                  const NeverScrollableScrollPhysics(), // Desabilita o scroll do GridView
              shrinkWrap:
                  true, // Permite que o GridView caiba no SingleChildScrollView
              crossAxisCount: 2, // 2 colunas em qualquer tela
              crossAxisSpacing: 16.0, // Espaçamento horizontal entre os cards
              mainAxisSpacing: 16.0, // Espaçamento vertical entre os cards

              // ESSENCIAL: Controla a proporção LARGURA/ALTURA dos cards
              // Ajuste o valor (e.g., 0.65, 0.7) até o card não ter overflow vertical (BOTTOM OVERFLOWED)
              childAspectRatio: 0.60,

              children: products.map((product) {
                return cardProduct(context, product["nome"]!, product["preco"]!,
                    product["imagem"]!);
              }).toList(),
            ),
          ],
        ),
      ),
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

Center cardProduct(
    BuildContext context, String nome, String preco, String imagem) {
  return Center(
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: double.infinity, // Ocupa a largura máxima da célula do GridView
        // 🔥 REMOVER ALTURA FIXA: height: 250,
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem do produto
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 120, // A altura da imagem pode ser mantida
                width: double.infinity,
                child: Image.asset(
                  imagem,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 8),

            // Nome do produto
            Text(
              nome,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis, // Adicionei para melhor UX
              softWrap: true,
            ),

            SizedBox(height: 4),

            // Preço do produto
            Text(
              preco,
              style: TextStyle(
                color: Colors.green[700],
                fontSize: 14,
              ),
            ),

            const Spacer(), // Empurra o botão pra baixo

            // Botão de compra
            // ... (o código do TextButton continua o mesmo)
            SizedBox(
              width: double.infinity, // Faz o botão ocupar a largura total
              child: TextButton(
                // ... (Estilos e onPressed)
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Color(0xFF14276b)),
                  padding: WidgetStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  ),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProdutoPage(
                              produto: {
                                'nome': nome,
                                'preco': preco,
                                'imagem': imagem,
                                'descricao': 'Descrição do produto',
                                'categorias_id': 1,
                              },
                            )),
                  );
                },
                child: const Text(
                  "Comprar",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// ignore: dead_code
TextButton cardProduct2(
    BuildContext context, String nome, String preco, String imagem) {
  return TextButton(
    style: ButtonStyle(
      overlayColor: WidgetStatePropertyAll(Colors.transparent),
    ),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProdutoPage(
                  produto: {
                    'nome': nome,
                    'preco': preco,
                    'imagem': imagem,
                    'descricao':
                        'Descrição do produto', // ou deixe vazia se não tiver
                    'categorias_id': 1,
                  },
                )),
      );
    },
    child: Center(
      child: Container(
        width: 160,
        height: 250,
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem do produto
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 120,
                width: double.infinity,
                child: Image.asset(
                  imagem,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 6),

            // Nome do produto
// Nome do produto
            Text(
              nome,
              style: TextStyle(fontSize: 14, color: Colors.black),
              maxLines: 2, // 🔥 permite até 2 linhas
              softWrap: true, // 🔥 quebra a linha se passar
            ),

            SizedBox(height: 2),

            // Preço do produto
            Text(
              preco,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
                fontSize: 18,
              ),
            ),

            Spacer(), // 🔥 empurra o botão pra baixo

            // Botão de compra
          ],
        ),
      ),
    ),
  );
}
