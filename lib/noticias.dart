import 'package:flutter/material.dart';

class Noticias extends StatefulWidget {
  const Noticias({super.key});

  @override
  State<Noticias> createState() => _NoticiasState();
}

class _NoticiasState extends State<Noticias> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Isso é bom se tiver muito conteúdo
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),

            // O título centralizado
            Center(
              child: Text(
                "Notícias",
                style: TextStyle(
                  color: Color(0xFF14276B),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 20),

            // O bloco de notícia
            Container(
              padding: EdgeInsets.all(14.0),
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: Colors.grey),
                  SizedBox(height: 8),
                  Text(
                    "Título da Notícia",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),

                  // Texto e imagem lado a lado
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        // troque Expanded por Flexible
                        flex: 2,
                        child: Text(
                          "Esse é o conteúdo da notícia. Aqui você escreve o que quiser. Ele vai ficar ao lado da imagem.",
                          style: TextStyle(fontSize: 16),
                          softWrap: true, // adicione isso
                        ),
                      ),
                      SizedBox(width: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/images/jogo-3.jpg',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
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
