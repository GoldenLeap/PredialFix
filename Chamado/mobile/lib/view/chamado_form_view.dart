import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/chamado_model.dart';
import '../view_models/home_view_model.dart';

class ChamadoFormView extends StatefulWidget {
  const ChamadoFormView({super.key});

  @override
  State<ChamadoFormView> createState() => _ChamadoFormViewState();
}

class _ChamadoFormViewState extends State<ChamadoFormView> {
  final _formKey = GlobalKey<FormState>();

  String _tipo = 'Elétrica';
  String _local = '';
  String _assunto = '';
  String _descricao = '';
  String _prioridade = 'Média';
  String _tipoServico = 'Interno';
  String _observacao = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Chamado'),
        backgroundColor: const Color(0xFFFF0000),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Tipo de Serviço'),
              _buildDropdown<String>(
                value: _tipo,
                items: Chamado.tipos,
                onChanged: (v) => setState(() => _tipo = v!),
                validator: (v) => v == null ? 'Selecione o tipo' : null,
              ),
              const SizedBox(height: 16),

              _buildSectionTitle('Local'),
              TextFormField(
                initialValue: _local,
                decoration: _inputDecoration('Ex: Sala 101, Corredor A'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Informe o local' : null,
                onSaved: (v) => _local = v ?? '',
              ),
              const SizedBox(height: 16),

              _buildSectionTitle('Assunto'),
              TextFormField(
                initialValue: _assunto,
                decoration: _inputDecoration('Ex: Lâmpada queimada'),
                maxLength: 255,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Informe o assunto' : null,
                onSaved: (v) => _assunto = v ?? '',
              ),
              const SizedBox(height: 16),

              _buildSectionTitle('Descrição'),
              TextFormField(
                initialValue: _descricao,
                decoration: _inputDecoration('Descreva o problema em detalhes'),
                maxLines: 4,
                maxLength: 1000,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Informe a descrição' : null,
                onSaved: (v) => _descricao = v ?? '',
              ),
              const SizedBox(height: 16),

              _buildSectionTitle('Prioridade'),
              _buildDropdown<String>(
                value: _prioridade,
                items: Chamado.prioridades,
                onChanged: (v) => setState(() => _prioridade = v!),
                validator: (v) => v == null ? 'Selecione a prioridade' : null,
              ),
              const SizedBox(height: 16),

              _buildSectionTitle('Tipo de Serviço'),
              _buildDropdown<String>(
                value: _tipoServico,
                items: Chamado.tipoServicos,
                onChanged: (v) => setState(() => _tipoServico = v!),
                validator: (v) => v == null ? 'Selecione o tipo' : null,
              ),
              const SizedBox(height: 16),

              _buildSectionTitle('Observação (opcional)'),
              TextFormField(
                initialValue: _observacao,
                decoration: _inputDecoration('Alguma informação adicional'),
                maxLines: 2,
                maxLength: 1000,
                onSaved: (v) => _observacao = v ?? '',
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF0000),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'ENVIAR CHAMADO',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
        letterSpacing: 1,
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  Widget _buildDropdown<T>({
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    String Function(T?)? validator,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items.map((item) {
        return DropdownMenuItem(value: item, child: Text(item));
      }).toList(),
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final viewModel = context.read<HomeViewModel>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    final success = await viewModel.createChamado(
      tipo: _tipo,
      local: _local,
      assunto: _assunto,
      descricao: _descricao,
      prioridade: _prioridade,
      tipoServico: _tipoServico,
      observacao: _observacao.isNotEmpty ? _observacao : null,
    );

    if (context.mounted) {
      Navigator.pop(context); // dismiss loading
      if (success != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Chamado #${success.id} criado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao criar chamado: ${viewModel.errorMessage}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}