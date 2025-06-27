import 'package:flutter/material.dart';
import 'produto_pagina.dart';

class Loja extends StatefulWidget {
  const Loja({super.key});

  @override
  State<Loja> createState() => _LojaState();
}

class _LojaState extends State<Loja> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.0),
            Center(
              child: Text(
                "Catálago de produtos",
                style: TextStyle(
                  color: Color(0xFF14276B),
                  fontSize: 25,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                cardProduct(context, "Bola de vôlei Penalty", "RS 249,99", "images/bola.jpg"),
                SizedBox(
                  width: 60,
                ),
                cardProduct(context, "Tênis de vôlei", "RS 299,99", "images/tenis.jpg"),
              ],
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                cardProduct(context, "Joelheira", "RS 99,99", "images/joelheira.jpg"),
                SizedBox(
                  width: 60,
                ),
                cardProduct(context, "Manguito de Vôlei", "RS 39,99", "images/manguito.jpg"),
              ],
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                cardProduct(context, "Meias", "RS29,99", 'images/meias.jpg'),
                SizedBox(
                  width: 60,
                ),
                cardProduct(context,"Marcador de pontos", "RS 99,99", 'images/placar.jpg'),
              ],
            ),
            SizedBox(height: 40),
            cardProduct(context,"Faixa", "RS 29,99", 'images/faixa.jpg'),
            SizedBox(height: 20),
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

Center cardProduct(BuildContext context, String nome, String preco, String imagem) {
  return Center(
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
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
            SizedBox(height: 8),

            // Nome do produto
// Nome do produto
            Text(
              nome,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              maxLines: 2, // 🔥 permite até 2 linhas
              softWrap: true, // 🔥 quebra a linha se passar
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

            Spacer(), // 🔥 empurra o botão pra baixo

            // Botão de compra
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Color(0xFF14276b)),
                padding: WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                ),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6), // 🔥 menor radius
                  ),
                ),
              ),
              onPressed: () {
              Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProdutoPage(
                          produto: {
                          'nome': nome,
                          'preco': preco,
                          'imagem': imagem,   
                          'descricao': 'Descrição do produto', // ou deixe vazia se não tiver
                          'categorias_id': 1,
                        },
                          )),
              );
              },
              child: Text(
                "Comprar",
                style: TextStyle(color: Colors.white),
                
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
