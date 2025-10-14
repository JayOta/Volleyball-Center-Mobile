// lib/pages/admin/admin_users_view.dart (FINALIZADO COM SCROLL CHECK)

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

  Future<List<Map<String, dynamic>>> _fetchUsers() async {
    return await _firestoreService.getAllUsers();
  }

  void _refreshUsers() {
    setState(() {
      _usersFuture = _fetchUsers();
    });
  }

  // Lógica de Update (Bloquear/Desbloquear)
  Future<void> _toggleUserActiveStatus(
      String uid, bool currentStatus, String userName) async {
    final newStatus = !currentStatus;
    final action = newStatus ? 'Ativado' : 'Bloqueado';

    try {
      await _firestoreService.updateUserProfile(
        uid: uid,
        updates: {'isActive': newStatus},
      );
      _refreshUsers();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Usuário $userName $action com sucesso!'),
            backgroundColor: newStatus ? Colors.green : Colors.red.shade700,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao ${action.toLowerCase()} o usuário: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Lógica de Delete (Soft Delete)
  Future<void> _deleteUser(String uid, String userName) async {
    try {
      await _firestoreService.deleteUserProfile(uid);
      _refreshUsers();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Usuário $userName desativado (soft delete) com sucesso!'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao desativar o usuário: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'N/A';
    final date = timestamp.toDate();
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Gestão de Usuários',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF14276b)),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: Color(0xFF14276b)),
                onPressed: _refreshUsers,
                tooltip: 'Recarregar Usuários',
              ),
            ],
          ),
          const SizedBox(height: 20),
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
                      child: Text('Nenhum usuário encontrado.'));
                }

                final userList = snapshot.data!;

                return SingleChildScrollView(
                  scrollDirection:
                      Axis.vertical, // Scroll principal para as linhas
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal, // Scroll para as colunas
                    child: DataTable(
                      headingRowColor:
                          WidgetStateProperty.all(Colors.grey[200]),
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
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: userList.map((user) {
                        final String uid = user['uid'] as String? ?? '';
                        final bool isActive = user['isActive'] == true;
                        final String name =
                            user['name'] ?? 'Usuário Desconhecido';

                        return DataRow(cells: [
                          DataCell(Text(name)),
                          DataCell(Text(user['email'] ?? 'N/A')),
                          DataCell(Icon(
                            isActive ? Icons.check_circle : Icons.cancel,
                            color: isActive ? Colors.green : Colors.red,
                            size: 18,
                          )),
                          DataCell(Text(_formatTimestamp(
                              user['createdAt'] as Timestamp?))),
                          DataCell(
                            Row(
                              children: [
                                // Botão de Bloqueio/Ativação
                                IconButton(
                                  icon: Icon(
                                    isActive ? Icons.lock : Icons.lock_open,
                                    color: isActive
                                        ? Colors.red.shade700
                                        : Colors.green.shade700,
                                  ),
                                  tooltip: isActive
                                      ? 'Bloquear Usuário'
                                      : 'Ativar Usuário',
                                  onPressed: () {
                                    if (uid.isNotEmpty) {
                                      _toggleUserActiveStatus(
                                          uid, isActive, name);
                                    }
                                  },
                                ),
                                const SizedBox(width: 8),

                                // Botão de Deletar (Soft Delete)
                                IconButton(
                                  icon: const Icon(Icons.delete_forever,
                                      color: Colors.orange),
                                  tooltip: 'Desativar Usuário (Soft Delete)',
                                  onPressed: () {
                                    if (uid.isNotEmpty) {
                                      _deleteUser(uid, name);
                                    }
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
