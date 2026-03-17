// lib/pages/admin/admin_products_view.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volleyball_center_mobile/services/firestore_service.dart'; // Importe o serviço
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminProductsView extends StatefulWidget {
  const AdminProductsView({super.key});

  @override
  State<AdminProductsView> createState() => _AdminProductsViewState();
}

class _AdminProductsViewState extends State<AdminProductsView> {
  final FirestoreService _service = FirestoreService();
  final Color primaryColor = const Color(0xFF14276B);

  // Exibe o formulário para adicionar/editar um produto
  void _showProductForm({Map<String, dynamic>? product}) {
    final TextEditingController nameController =
        TextEditingController(text: product?['name'] ?? '');
    final TextEditingController priceController =
        TextEditingController(text: product?['price']?.toString() ?? '');
    final TextEditingController imageUrlController =
        TextEditingController(text: product?['image_url'] ?? '');
    final TextEditingController descriptionController =
        TextEditingController(text: product?['description'] ?? '');
    final TextEditingController categoryController =
        TextEditingController(text: product?['category_id']?.toString() ?? '0');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                product == null ? 'Adicionar Novo Produto' : 'Editar Produto',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryColor),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nome do Produto'),
              ),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: 'Preço (Ex: 199.99)'),
              ),
              TextField(
                controller: imageUrlController,
                decoration: const InputDecoration(
                    labelText: 'URL da Imagem (Firebase Storage/Imgur)'),
              ),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
              TextField(
                controller: categoryController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'ID da Categoria (Ex: 1=Calçado, 2=Roupa)'),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white),
                  onPressed: () async {
                    if (nameController.text.isEmpty ||
                        priceController.text.isEmpty) {
                      return;
                    }

                    final Map<String, dynamic> data = {
                      'nome': nameController.text.trim(),
                      'name': nameController.text
                          .trim(), // Duplique o campo para compatibilidade
                      'price': double.tryParse(
                              priceController.text.replaceAll(',', '.')) ??
                          0.0,
                      'image_url': imageUrlController.text.trim(),
                      'imagem': imageUrlController.text
                          .trim(), // Duplique o campo para compatibilidade
                      'description': descriptionController.text.trim(),
                      'category_id':
                          int.tryParse(categoryController.text.trim()) ?? 0,
                    };

                    await _service.saveProduct(data, docId: product?['id']);
                    Navigator.pop(context);
                  },
                  child: Text(
                      product == null ? 'Salvar Produto' : 'Atualizar Produto'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Confirmação para exclusão
  void _confirmDelete(String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Produto?'),
        content: const Text(
            'Tem certeza que deseja excluir este produto? Esta ação é irreversível.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              _service.deleteProduct(docId);
              Navigator.pop(context);
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProductForm(),
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _service.getProductsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Erro ao carregar produtos: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('Nenhum produto cadastrado.',
                    style: TextStyle(fontSize: 16)));
          }

          final products = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 80, top: 10),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: product['image_url'] != null &&
                          product['image_url'].isNotEmpty
                      ? Image.network(
                          product['image_url'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image_not_supported, size: 40),
                        )
                      : const Icon(Icons.shopping_bag, size: 40),
                  title: Text(product['name'] ?? 'Produto sem nome',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(product['preco'] ?? 'Preço indisponível'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showProductForm(product: product),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDelete(product['id']),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
