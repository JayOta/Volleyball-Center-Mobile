import 'package:flutter/material.dart';
import 'package:volleyball_center_mobile/fundamentos.dart';
import 'package:volleyball_center_mobile/loja.dart';
import 'package:volleyball_center_mobile/main.dart';
import 'package:volleyball_center_mobile/menuBar.dart';
import 'package:volleyball_center_mobile/navbar.dart';
import 'package:volleyball_center_mobile/admin.dart';
import 'package:volleyball_center_mobile/noticias.dart';
import 'package:volleyball_center_mobile/perfil.dart';

class ProdutoPage extends StatefulWidget {
  final Map<String, dynamic> produto; // Dados do produto
  const ProdutoPage({super.key, required this.produto});

  @override
  State<ProdutoPage> createState() => _ProdutoPageState();
}

class _ProdutoPageState extends State<ProdutoPage> {
  int quantidade = 0;
  String? tamanhoSelecionado;
  int _selectedIndex = 5;

  void _onItemSelected(int index) {
    if (index == 4) {
      // índice 4 é o botão perfil
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Perfil()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final produto = widget.produto;

    Widget _buildBody(int index) {
      switch (index) {
        case 0:
          return Fundamentos();
        case 1:
          return Noticias();
        case 2:
          return HomePage();
        case 3:
          return Loja();
        case 4:
          return Perfil();
        default:
          return bodyContent();
      }
    }

    return Scaffold(
      appBar: const Navbar(),
      body: _buildBody(_selectedIndex),
      bottomNavigationBar: MenuBarFile(onItemSelected: _onItemSelected),
    );
  }

  Widget bodyContent() {
    final produto = widget.produto;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(height: 15),
          Text(
            'Produtos de Edição Limitada Verão',
            style: TextStyle(color: Color(0xFF14276B), fontSize: 25),
          ),
          SizedBox(height: 50),
          Row(
            children: [
              Text(produto['nome'], style: const TextStyle(fontSize: 40)),
            ],
          ),
          Row(
            children: [
              Text(
                "Tenis (categoria)",
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),

          SizedBox(height: 10),
          Row(
            children: [
              Text(
                produto['preco'],
                style: const TextStyle(
                  fontSize: 24,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 40,
          ),
          Image.asset(produto['imagem'],
              width: double.infinity, fit: BoxFit.cover),
          const SizedBox(height: 20),

          SizedBox(height: 30),
          Row(children: [
            // Deixar o Texto encima dos tmamanhos
            // Tamanhos
            Text('Tamanhos', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(width: 8),
            Expanded(
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _buildTamanhos(produto['categorias_id']),
              ),
            ),
          ]),

          const SizedBox(height: 20),
          // Quantidade
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     IconButton(
          //       onPressed: () {
          //         setState(() {
          //           if (quantidade > 0) quantidade--;
          //         });
          //       },
          //       icon: const Icon(Icons.remove),
          //     ),
          //     Text(
          //       '$quantidade',
          //       style: const TextStyle(fontSize: 24),
          //     ),
          //     IconButton(
          //       onPressed: () {
          //         setState(() {
          //           quantidade++;
          //         });
          //       },
          //       icon: const Icon(Icons.add),
          //     ),
          //   ],
          // ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              // Adicionar ao carrinho
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Admin()),
              );
            },
            icon: const Icon(Icons.shopping_cart),
            label: const Text('Adicionar ao Carrinho'),
            style: ElevatedButton.styleFrom(
              iconColor: Color(0xFFFFFFFF),
              foregroundColor: Color(0xFFFFFFFF),
              backgroundColor: Color(0xFF14276b),
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 90),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTamanhos(int categoriaId) {
    if (categoriaId == 1) {
      return ['37', '38', '39', '40', '41', '42', '43']
          .map((size) => _buildTamanhoButton(size))
          .toList();
    } else if ([2, 3, 4].contains(categoriaId)) {
      return ['PP', 'P', 'M', 'G', 'GG']
          .map((size) => _buildTamanhoButton(size))
          .toList();
    } else {
      return [const Text('Sem tamanhos disponíveis')];
    }
  }

  Widget _buildTamanhoButton(String size) {
    final bool isSelected = tamanhoSelecionado == size;
    return TextButton(
      onPressed: () {
        setState(() {
          tamanhoSelecionado = size;
        });
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
        backgroundColor:
            isSelected ? Color.fromARGB(255, 37, 53, 110) : Colors.white30,
        foregroundColor: isSelected ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade400,
          ),
        ),
      ),
      child: Text(size),
    );
  }
}
