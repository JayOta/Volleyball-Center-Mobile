import 'package:flutter/material.dart';
import 'package:volleyball_center_mobile/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:volleyball_center_mobile/services/auth_service.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Criar conta no Firebase
      await _authService.registerWithEmailAndPassword(
        _emailController.text.trim(),
        _senhaController.text,
      );

      // Atualizar nome do usuário
      await _authService.updateDisplayName(_nomeController.text.trim());

      // Mostrar mensagem de sucesso
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cadastro realizado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navegar para a tela principal
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyApp()),
        );
      }
    } catch (e) {
      // Mostrar erro
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Cadastro",
                    style: TextStyle(color: Color(0xFF14276B), fontSize: 40),
                  ),
                  const SizedBox(height: 30),

                  // Status do Firebase (apenas para debug)
                  FutureBuilder(
                    future: Future.value(Firebase.apps.isNotEmpty),
                    builder: (context, snapshot) {
                      return Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: snapshot.data == true
                              ? Colors.green.shade100
                              : Colors.red.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: snapshot.data == true
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              snapshot.data == true
                                  ? Icons.check_circle
                                  : Icons.error,
                              color: snapshot.data == true
                                  ? Colors.green
                                  : Colors.red,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              snapshot.data == true
                                  ? 'Firebase conectado'
                                  : 'Firebase não conectado',
                              style: TextStyle(
                                color: snapshot.data == true
                                    ? Colors.green.shade800
                                    : Colors.red.shade800,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  // Campo Nome/Usuário
                  SizedBox(
                    width: 350,
                    child: TextFormField(
                      controller: _nomeController,
                      decoration: InputDecoration(
                        labelText: 'Nome de usuário',
                        labelStyle: const TextStyle(color: Color(0xFF14276B)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide:
                              const BorderSide(color: Color(0xFF14276B)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide:
                              const BorderSide(color: Color(0xFF14276B)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: const BorderSide(
                              color: Color(0xFF14276B), width: 2),
                        ),
                        prefixIcon:
                            const Icon(Icons.person, color: Color(0xFF14276B)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira seu nome de usuário';
                        }
                        if (value.length < 3) {
                          return 'Nome deve ter pelo menos 3 caracteres';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Campo Email
                  SizedBox(
                    width: 350,
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: const TextStyle(color: Color(0xFF14276B)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide:
                              const BorderSide(color: Color(0xFF14276B)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide:
                              const BorderSide(color: Color(0xFF14276B)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: const BorderSide(
                              color: Color(0xFF14276B), width: 2),
                        ),
                        prefixIcon:
                            const Icon(Icons.email, color: Color(0xFF14276B)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira seu email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'Por favor, insira um email válido';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Campo Senha
                  SizedBox(
                    width: 350,
                    child: TextFormField(
                      controller: _senhaController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        labelStyle: const TextStyle(color: Color(0xFF14276B)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide:
                              const BorderSide(color: Color(0xFF14276B)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide:
                              const BorderSide(color: Color(0xFF14276B)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: const BorderSide(
                              color: Color(0xFF14276B), width: 2),
                        ),
                        prefixIcon:
                            const Icon(Icons.lock, color: Color(0xFF14276B)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color(0xFF14276B),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira sua senha';
                        }
                        if (value.length < 6) {
                          return 'Senha deve ter pelo menos 6 caracteres';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Botão Cadastrar
                  SizedBox(
                    width: 350,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF14276B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      onPressed: _isLoading ? null : _cadastrar,
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text(
                              "Cadastrar",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Link para login
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Já tem uma conta? Fazer login',
                      style: TextStyle(
                        color: Color(0xFF14276B),
                        decoration: TextDecoration.underline,
                        decorationColor: Color(0xFF14276B),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    'Volleyball Center',
                    style: TextStyle(color: Color(0xFF14276B), fontSize: 35),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
