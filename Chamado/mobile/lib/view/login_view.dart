import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import '../view_models/login_view_model.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // a View assiste o ViewModel
    final viewModel = context.watch<LoginViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFFF0000),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            Image.asset('assets/images/logo_senai.png', height: 40),
            const SizedBox(height: 20),
            Image.asset('assets/images/logo.png', height: 100), 
            const SizedBox(height: 20),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(48),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (viewModel.errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom:16),
                      child: Text(
                        viewModel.errorMessage,
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),

                  const Text(
                    "E-MAIL INSTITUCIONAL",
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 2),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.mail_outline, color: Color(0xFFFF0000)),
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      hintText: "seu.nome@senai.br",
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "SENHA",
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 2),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_showPassword,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFFFF0000)),
                      suffixIcon: IconButton(
                        icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => _showPassword = !_showPassword),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      hintText: "••••••••",
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Botão Entrar com estado de Loading
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: viewModel.isLoading
                          ? null // Desabilita o botão enquanto carrega
                          : () async {
                              bool sucesso = await viewModel.login(
                                _emailController.text,
                                _passwordController.text,
                              );
                              if (sucesso && mounted) {
                                Navigator.pushReplacementNamed(context, '/home');
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF0000),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 5,
                      ),
                      child: viewModel.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "ENTRAR NO SISTEMA",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              "© 2026 SENAI - PREDIALFIX",
              style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 3),
            ),
          ],
        ),
      ),
    );
  }
}
