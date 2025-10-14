// lib/pages/admin/admin_users_view.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volleyball_center_mobile/services/firestore_service.dart';

class AdminUsersView extends StatefulWidget {
  const AdminUsersView({super.key});

  @override
  State<AdminUsersView> createState() => _AdminUsersViewState();
}

class _AdminUsersViewState extends State<AdminUsersView> {
  final FirestoreService _firestoreService = FirestoreService();
  late Future<List<Map<String, dynamic>>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = _fetchUsers();
  }

  // Função para buscar a lista de usuários
  Future<List<Map<String, dynamic>>> _fetchUsers() async {
    // Chama o método que busca todos os usuários (ativos) do Firestore
    // Note: Ele retorna uma List<Map<String, dynamic>>
    return await _firestoreService.getAllUsers();
  }

  // Função para formatar o Timestamp
  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'N/A';
    final date = timestamp.toDate();
    // Formato DD/MM/AAAA
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gestão de Usuários',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF14276b)),
          ),
          const SizedBox(height: 20),

          // O FutureBuilder busca os dados e constrói a UI com base no resultado
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _usersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child:
                          Text('Erro ao carregar usuários: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text(
                          'Nenhum usuário encontrado (ou regras do Firestore não permitem leitura).'));
                }

                final userList = snapshot.data!;

                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor:
                          MaterialStateProperty.all(Colors.grey[200]),
                      border: TableBorder.all(color: Colors.grey.shade300),
                      columnSpacing: 20,
                      dataRowHeight: 40,
                      columns: const [
                        DataColumn(
                            label: Text('Nome',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Email',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Ativo?',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Registro',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Ações',
                                style: TextStyle(
                                    fontWeight: FontWeight
                                        .bold))), // Manteremos as ações para futura expansão (bloquear/ativar)
                      ],
                      rows: userList.map((user) {
                        return DataRow(cells: [
                          DataCell(Text(user['name'] ?? 'N/A')),
                          DataCell(Text(user['email'] ?? 'N/A')),
                          DataCell(Icon(
                            (user['isActive'] == true)
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: (user['isActive'] == true)
                                ? Colors.green
                                : Colors.red,
                            size: 18,
                          )),
                          DataCell(Text(_formatTimestamp(
                              user['createdAt'] as Timestamp?))),
                          DataCell(
                            Row(
                              children: [
                                // Exemplo de botão para futura implementação de "Bloquear"
                                IconButton(
                                  icon: Icon(Icons.lock_open,
                                      color: Colors.blueGrey),
                                  tooltip: 'Bloquear/Desbloquear',
                                  onPressed: () {
                                    // Implementação futura: _toggleUserActiveStatus(user['uid']);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Ação de Bloqueio/Ativação para o usuário ${user['name']}')));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
