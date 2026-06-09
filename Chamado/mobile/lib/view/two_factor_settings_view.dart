import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/settings_view_model.dart';
import '../widgets/cust_drawer.dart';

class TwoFactorSettingsView extends StatefulWidget {
  const TwoFactorSettingsView({super.key});

  @override
  State<TwoFactorSettingsView> createState() => _TwoFactorSettingsViewState();
}

class _TwoFactorSettingsViewState extends State<TwoFactorSettingsView> {
  bool _twoFactorEnabled = false;
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _enableTwoFactor() async {
    final viewModel = context.read<SettingsViewModel>();
    final success = await viewModel.enableTwoFactor();

    if (!mounted) return;

    if (success) {
      setState(() => _twoFactorEnabled = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Autenticação em dois fatores ativada!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewModel.errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _disableTwoFactor() async {
    if (_formKey.currentState!.validate()) {
      final viewModel = context.read<SettingsViewModel>();
      final success = await viewModel.disableTwoFactor(_passwordController.text);

      if (!mounted) return;

      if (success) {
        setState(() => _twoFactorEnabled = false);
        _passwordController.clear();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Sucesso'),
              content: const Text('Autenticação em dois fatores desativada.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(viewModel.errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SettingsViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Autenticação em Dois Fatores'),
        backgroundColor: const Color(0xFFFF0000),
        foregroundColor: Colors.white,
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Segurança Avançada',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'A autenticação em dois fatores adiciona uma camada extra de segurança à sua conta.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.shield, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        'O que é 2FA?',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'A autenticação em dois fatores requer que você forneça um código além de sua senha ao fazer login. Isso torna muito mais difícil para outras pessoas acessarem sua conta.',
                    style: TextStyle(fontSize: 12, color: Colors.blue),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Autenticação em Dois Fatores',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _twoFactorEnabled ? 'Ativado' : 'Desativado',
                        style: TextStyle(
                          color: _twoFactorEnabled ? Colors.green : Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: _twoFactorEnabled,
                    onChanged: (value) {
                      if (value) {
                        _enableTwoFactor();
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Desativar 2FA'),
                              content: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text('Digite sua senha para confirmar:'),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: _passwordController,
                                      obscureText: !_showPassword,
                                      decoration: InputDecoration(
                                        hintText: 'Sua senha',
                                        suffixIcon: IconButton(
                                          icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
                                          onPressed: () => setState(() => _showPassword = !_showPassword),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value?.isEmpty ?? true) return "Senha é obrigatória";
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _disableTwoFactor();
                                  },
                                  child: const Text('Desativar', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    activeColor: const Color(0xFFFF0000),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber[200]!),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning, color: Colors.amber),
                      SizedBox(width: 8),
                      Text(
                        'Códigos de Backup',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Guarde seus códigos de backup em um local seguro. Você pode usá-los para fazer login se não tiver acesso ao seu aplicativo autenticador.',
                    style: TextStyle(fontSize: 12, color: Colors.amber),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
