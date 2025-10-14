// produto_pagina.dart

import 'package:flutter/material.dart';
import 'package:volleyball_center_mobile/navbar.dart';
// Note que o MenuBarFile não será mais importado/usado nesta página de detalhes.

class ProdutoPage extends StatefulWidget {
  final Map<String, dynamic> produto; // Dados do produto
  const ProdutoPage({super.key, required this.produto});

  @override
  State<ProdutoPage> createState() => _ProdutoPageState();
}

class _ProdutoPageState extends State<ProdutoPage> {
  static const Color primaryColor = Color(0xFF14276B); // Azul Marinho

  int quantidade = 1;
  String? tamanhoSelecionado;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ⭐️ MANTÉM A NAVBAR: O botão de "Voltar" nativo funciona
      appBar: const Navbar(),
      // ⭐️ BODY: Exibe o conteúdo do produto
      body: _bodyContent(),
      // ❌ REMOVIDO: O MenuBarFile não deve existir em uma página de detalhes,
      // pois interfere na navegação e causa a não funcionalidade em outras telas.
      // bottomNavigationBar: MenuBarFile(...)
    );
  }

  Widget _bodyContent() {
    final produto = widget.produto;
    // ATENÇÃO: Verifique no Firestore se o campo é 'description' ou 'descricao'
    // Se for 'descricao', mude a linha abaixo de volta.
    final String descricao =
        produto['description'] ?? 'Sem descrição detalhada.';
    final int categoriaId = produto['categorias_id'] ?? 0;

    // Mapeamento simples de categoria para exibição
    String categoriaTexto;
    switch (categoriaId) {
      case 0:
        categoriaTexto = 'Bola/Objeto Principal';
        break;
      case 1:
        categoriaTexto = 'Calçado';
        break;
      case 2:
        categoriaTexto = 'Acessório de Proteção';
        break;
      case 3:
        categoriaTexto = 'Acessório Esportivo';
        break;
      case 4:
        categoriaTexto = 'Vestuário';
        break;
      case 5:
        categoriaTexto = 'Equipamento/Placar';
        break;
      default:
        categoriaTexto = 'Outros';
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Título de Destaque (Topo) - REMOVIDO, pois o nome e a imagem já falam por si.
          // const Text(
          //   'Produtos em Destaque',
          //   style: TextStyle(
          //       color: primaryColor, fontSize: 18, fontWeight: FontWeight.w600),
          // ),
          // const SizedBox(height: 10), // Reduzido o espaço vertical

          // 2. Imagem Principal
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: produto['image_url'] != null &&
                      (produto['image_url'] as String).startsWith('http')
                  ? Image.network(
                      produto['image_url'],
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
                              child: Icon(Icons.error,
                                  size: 50, color: Colors.red)),
                    )
                  : Image.asset(
                      produto['imagem'] ?? 'assets/images/placeholder.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
                              child: Icon(Icons.image_not_supported, size: 50)),
                    ),
            ),
          ),
          const SizedBox(height: 20),

          // 3. Nome do Produto e Categoria
          Text(
            produto['name'] ?? 'Produto Sem Nome',
            style: const TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: primaryColor),
          ),
          const SizedBox(height: 5),
          Text(
            categoriaTexto,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 15),

          // 4. Preço
          Text(
            produto['preco'] ?? 'R\$ --',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Color.fromARGB(255, 33, 150, 83),
            ),
          ),
          const SizedBox(height: 30),

          // 5. Opções de Tamanho
          if (categoriaId != 0)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selecione o Tamanho:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _buildTamanhos(categoriaId),
                ),
                const SizedBox(height: 30),
              ],
            ),

          // 6. Contador de Quantidade
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Quantidade:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 20),
                      onPressed: () {
                        setState(() {
                          if (quantidade > 1) quantidade--;
                        });
                      },
                    ),
                    Text(
                      '$quantidade',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, size: 20),
                      onPressed: () {
                        setState(() {
                          quantidade++;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),

          // 7. Botão Adicionar ao Carrinho (Responsivo)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // Lógica de adição ao carrinho (Placeholder)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Produto ${produto['name']} (Qtd: $quantidade) adicionado ao carrinho!')),
                );
              },
              icon: const Icon(Icons.shopping_cart),
              label: const Text('Adicionar ao Carrinho'),
              style: ElevatedButton.styleFrom(
                iconColor: Colors.white,
                foregroundColor: Colors.white,
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 18),
                textStyle:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),

          const SizedBox(height: 40),

          // 8. Descrição do Produto
          const Text(
            'Detalhes do Produto',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
          ),
          const Divider(color: primaryColor),
          const SizedBox(height: 10),
          Text(
            descricao,
            textAlign: TextAlign.justify,
            style: const TextStyle(fontSize: 15, height: 1.5),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  // Métodos _buildTamanhos e _buildTamanhoButton (mantidos)
  List<Widget> _buildTamanhos(int categoriaId) {
    List<String> sizes = [];
    if (categoriaId == 1) {
      sizes = ['37', '38', '39', '40', '41', '42', '43'];
    } else if ([2, 3, 4].contains(categoriaId)) {
      sizes = ['PP', 'P', 'M', 'G', 'GG'];
    } else {
      return [const Text('Sem tamanhos disponíveis')];
    }

    return sizes.map((size) => _buildTamanhoButton(size)).toList();
  }

  Widget _buildTamanhoButton(String size) {
    final bool isSelected = tamanhoSelecionado == size;
    return GestureDetector(
      onTap: () {
        setState(() {
          tamanhoSelecionado = size;
        });
      },
      child: Container(
        width: 60,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey.shade400,
            width: 2,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          size,
          style: TextStyle(
            color: isSelected ? Colors.white : primaryColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
