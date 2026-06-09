import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/two_factor_challenge_view_model.dart';

class TwoFactorChallengeView extends StatefulWidget {
  const TwoFactorChallengeView({super.key});

  @override
  State<TwoFactorChallengeView> createState() => _TwoFactorChallengeViewState();
}

class _TwoFactorChallengeViewState extends State<TwoFactorChallengeView> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _backupCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _useBackupCode = false;

  @override
  void dispose() {
    _codeController.dispose();
    _backupCodeController.dispose();
    super.dispose();
  }

  void _verify2FA() async {
    if (_formKey.currentState!.validate()) {
      final viewModel = context.read<TwoFactorChallengeViewModel>();
      
      late bool success;
      if (_useBackupCode) {
        success = await viewModel.verifyTwoFactorBackupCode(_backupCodeController.text);
      } else {
        success = await viewModel.verifyTwoFactorCode(_codeController.text);
      }

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Autenticação bem-sucedida!')),
        );
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(viewModel.errorMessage)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TwoFactorChallengeViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFFF0000),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF0000),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Image.asset('assets/images/logo_senai.png', height: 40),
            const SizedBox(height: 20),
            const Text(
              'Autenticação em Dois Fatores',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(48),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsets.only(bottom: 16),
                      child: const Row(
                        children: [
                          Icon(Icons.info, color: Colors.blue),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Insira o código de 6 dígitos do seu aplicativo autenticador.',
                              style: TextStyle(color: Colors.blue, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (viewModel.errorMessage.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.red[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          viewModel.errorMessage,
                          style: const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),

                    if (!_useBackupCode) ...[
                      const Text(
                        "CÓDIGO DE AUTENTICAÇÃO",
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 2),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _codeController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 24, letterSpacing: 8),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[50],
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                          hintText: "000000",
                        ),
                        maxLength: 6,
                        validator: (value) {
                          if (value?.isEmpty ?? true) return "Código é obrigatório";
                          if (value!.length != 6) return "Código deve ter 6 dígitos";
                          return null;
                        },
                      ),
                    ] else ...[
                      const Text(
                        "CÓDIGO DE BACKUP",
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 2),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _backupCodeController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[50],
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                          hintText: "XXXX-XXXX-XXXX",
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) return "Código de backup é obrigatório";
                          return null;
                        },
                      ),
                    ],
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () => setState(() => _useBackupCode = !_useBackupCode),
                          child: Text(
                            _useBackupCode ? 'Usar código de autenticação' : 'Usar código de backup',
                            style: const TextStyle(color: Color(0xFFFF0000), fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: viewModel.isLoading ? null : _verify2FA,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF0000),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          disabledBackgroundColor: Colors.grey,
                        ),
                        child: viewModel.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'VERIFICAR',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
