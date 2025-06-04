import 'package:flutter/material.dart';
 
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
            cardProduct("Bola de vôlei Penalty", "RS 249,99", "images/bola.jpg"),
 
            // Card do produto
            cardProduct("Tênis de vôlei", "RS 299,99", "images/tenis.jpg"),
            SizedBox(height: 20),

            // Card do produto
             cardProduct("Joelheira", "RS 99,99", "images/joelheira.jpg"),
             SizedBox(height: 20),
 
            // Card do produto
            cardProduct("Manguito de Vôlei", "RS 39,99", "images/manguito.jpg"),
            SizedBox(height: 20),

            // Card do produto
            cardProduct("Meias", "29,99", 'images/meias.jpg'),
               SizedBox(height: 20),

            // Card do produto
            cardProduct("Marcador de pontos", "RS 99,99", 'images/placar.jpg'),
            SizedBox(height: 20),

            // Card do produto
            cardProduct("Faixa", "RS 29,99", 'images/faixa.jpg'),
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

Center cardProduct(String nome, String preco,String imagem) {
 return Center(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  width: 160,
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Imagem do produto
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          imagem,
                          height: 160,
                          width: 200,
                          fit: BoxFit.cover,
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
                    ],
                  ),
                ),
              ),
            );
}