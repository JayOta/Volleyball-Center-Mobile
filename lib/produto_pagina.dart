import 'package:flutter/material.dart';
import 'package:volleyball_center_mobile/navbar.dart';

class ProdutoPage extends StatefulWidget {
  final Map<String, dynamic> produto; // Dados do produto
  const ProdutoPage({super.key, required this.produto});

  @override
  State<ProdutoPage> createState() => _ProdutoPageState();
}

class _ProdutoPageState extends State<ProdutoPage> {
  int quantidade = 0;

  @override
  Widget build(BuildContext context) {
    final produto = widget.produto;

    return Scaffold(
      appBar: const Navbar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Produtos de Edição Limitada Verão',
              style:TextStyle(color: Color(0xFF14276B), fontSize: 25),),  
            SizedBox(height: 60,),  
            Image.asset(produto['imagem'], height: 180),
            const SizedBox(height: 16),
            const SizedBox(height: 8),
            Text(produto['nome'], style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  produto['preco'],
                  style: const TextStyle(
                    fontSize: 22,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  '25%',
                  style: TextStyle(fontSize: 22, color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Tamanhos
            Text('Tamanhos', style: Theme.of(context).textTheme.titleMedium),
            Wrap(
              spacing: 8,
              children: _buildTamanhos(produto['categorias_id']),
            ),
            const SizedBox(height: 20),
            // Quantidade
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (quantidade > 0) quantidade--;
                    });
                  },
                  icon: const Icon(Icons.remove),
                ),
                Text(
                  '$quantidade',
                  style: const TextStyle(fontSize: 24),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      quantidade++;
                    });
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // Adicionar ao carrinho
              },
              icon: const Icon(Icons.shopping_cart),
              label: const Text('Adicionar ao Carrinho'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTamanhos(int categoriaId) {
    if (categoriaId == 1) {
      return ['37', '38', '39', '40', '41', '42', '43']
          .map((size) => Chip(label: Text(size)))
          .toList();
    } else if ([2, 3, 4].contains(categoriaId)) {
      return ['PP', 'P', 'M', 'G', 'GG']
          .map((size) => Chip(label: Text(size)))
          .toList();
    } else {
      return [const Text('Sem tamanhos disponíveis')];
    }
  }
}
