import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/auth_view_model.dart';
import '../services/auth_service.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  final _profileFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  bool _isLoadingData = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await AuthService().getUserData();
    if (userData != null) {
      _nameController.text = userData['name'];
      _emailController.text = userData['email'];
    }
    setState(() {
      _isLoadingData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AuthViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        backgroundColor: const Color(0xFFFF0000),
        foregroundColor: Colors.white,
      ),
      body: _isLoadingData 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (viewModel.errorMessage != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    color: Colors.red.shade100,
                    child: Text(viewModel.errorMessage!, style: const TextStyle(color: Colors.red)),
                  ),
                  
                const Text('Dados do Perfil', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Form(
                  key: _profileFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Nome', border: OutlineInputBorder()),
                        validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'E-mail', border: OutlineInputBorder()),
                        validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: viewModel.isLoading ? null : () async {
                            if (_profileFormKey.currentState!.validate()) {
                              final ok = await context.read<AuthViewModel>().updateProfile(_nameController.text, _emailController.text);
                              if (ok && mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Perfil atualizado!'), backgroundColor: Colors.green));
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                          child: const Text('SALVAR DADOS', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const Divider(height: 48, thickness: 1),
                
                const Text('Alterar Senha', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Form(
                  key: _passwordFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _currentPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: 'Senha Atual', border: OutlineInputBorder()),
                        validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _newPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: 'Nova Senha', border: OutlineInputBorder()),
                        validator: (v) => v!.length < 8 ? 'Mínimo 8 caracteres' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: 'Confirmar Nova Senha', border: OutlineInputBorder()),
                        validator: (v) => v != _newPasswordController.text ? 'Senhas não conferem' : null,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: viewModel.isLoading ? null : () async {
                            if (_passwordFormKey.currentState!.validate()) {
                              final ok = await context.read<AuthViewModel>().updatePassword(
                                _currentPasswordController.text, 
                                _newPasswordController.text, 
                                _confirmPasswordController.text
                              );
                              if (ok && mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Senha alterada com sucesso!'), backgroundColor: Colors.green));
                                _currentPasswordController.clear();
                                _newPasswordController.clear();
                                _confirmPasswordController.clear();
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                          child: const Text('ALTERAR SENHA', style: TextStyle(color: Colors.white)),
                        ),
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
