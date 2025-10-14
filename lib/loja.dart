// loja.dart

// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:volleyball_center_mobile/services/firestore_service.dart';
// ⭐️ IMPORTAÇÃO ADICIONADA: Precisamos da página de destino
import 'package:volleyball_center_mobile/produto_pagina.dart';

class Loja extends StatefulWidget {
  const Loja({super.key});

  @override
  State<Loja> createState() => _LojaState();
}

class _LojaState extends State<Loja> {
  final FirestoreService _firestoreService = FirestoreService();
  late final Stream<List<Map<String, dynamic>>> _productsStream;

  @override
  void initState() {
    super.initState();
    _productsStream = _firestoreService.getProductsStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 10),
            child: Text(
              'Nossos Produtos',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF14276b),
              ),
            ),
          ),

          // StreamBuilder para carregar e exibir os produtos
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _productsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  print("Erro ao carregar produtos: ${snapshot.error}");
                  return const Center(
                      child: Text('Erro ao carregar produtos.'));
                }

                final products = snapshot.data;

                if (products == null || products.isEmpty) {
                  return const Center(
                    child: Text(
                      'Nenhum produto cadastrado no momento.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 itens por linha
                    childAspectRatio:
                        0.7, // Proporção para caber imagem e texto
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return _buildProductCard(product);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    // Usa 'preco' que é a chave formatada no FirestoreService.getProductsStream()
    final preco = product['preco'] ?? 'R\$ --';
    final nome = product['name'] ?? 'Produto Sem Nome';
    final imageUrl = product['image_url'];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagem do Produto
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
                              child: Icon(Icons.shopping_bag_outlined,
                                  size: 50, color: Colors.grey)),
                    )
                  : const Center(
                      child: Icon(Icons.shopping_bag_outlined,
                          size: 50, color: Colors.grey)),
            ),
          ),

          // Detalhes do Produto
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nome,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF14276b),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  preco,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xFFFFCC00), // Amarelo
                  ),
                ),
              ],
            ),
          ),

          // Botão de Compra (AGORA NAVEGA PARA PRODUTOPAGE) ⭐️ CORREÇÃO PRINCIPAL AQUI
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
            child: ElevatedButton(
              onPressed: () {
                // Ação de compra ou mais detalhes -> NAVEGAÇÃO
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // Passa o mapa de dados completo do produto
                    builder: (context) => ProdutoPage(produto: product),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFCC00), // Fundo Amarelo
                foregroundColor: const Color(0xFF14276b), // Texto Azul
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
                elevation: 0,
              ),
              child: const Text(
                'COMPRAR',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
