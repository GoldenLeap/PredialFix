import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/materiais_view_model.dart';
import '../models/material_model.dart';

class MateriaisView extends StatefulWidget {
  const MateriaisView({super.key});

  @override
  State<MateriaisView> createState() => _MateriaisViewState();
}

class _MateriaisViewState extends State<MateriaisView> {
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<MateriaisViewModel>(
      builder: (context, viewModel, child) {
        if (!_initialized) {
          _initialized = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            viewModel.loadMateriais();
          });
        }

        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            title: const Text('Estoque de Materiais'),
            backgroundColor: const Color(0xFFFF0000),
            foregroundColor: Colors.white,
            actions: [
              IconButton(icon: const Icon(Icons.refresh), onPressed: viewModel.loadMateriais),
            ],
          ),
          body: viewModel.isLoading && viewModel.materiais.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : viewModel.errorMessage != null
              ? Center(child: Text(viewModel.errorMessage!, style: const TextStyle(color: Colors.red)))
              : viewModel.materiais.isEmpty
                ? const Center(child: Text("Nenhum material cadastrado no estoque."))
                : RefreshIndicator(
                    onRefresh: viewModel.loadMateriais,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: viewModel.materiais.length,
                      itemBuilder: (context, index) {
                        final material = viewModel.materiais[index];
                        return _buildMaterialCard(context, material, viewModel);
                      },
                    ),
                  ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xFFFF0000),
            onPressed: () => _showMaterialDialog(context, viewModel),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }

  Color _statusColor(String? status) {
    switch (status) {
      case 'Crítico': return Colors.red;
      case 'Baixo': return Colors.orange;
      case 'Adequado': return Colors.green;
      default: return Colors.grey;
    }
  }

  Widget _buildMaterialCard(BuildContext context, MaterialItem material, MateriaisViewModel viewModel) {
    final statusColor = _statusColor(material.statusEstoque);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.15),
          child: Icon(Icons.inventory_2, color: statusColor),
        ),
        title: Text(material.nome, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Qtd: ${material.quantidadeAtual} ${material.unidade} (mín: ${material.quantidadeMinima})', style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
            Text('Categoria: ${material.categoria}'),
            Text('Local: ${material.localizacao}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            if (material.statusEstoque != null)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                child: Text(material.statusEstoque!, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _showMaterialDialog(context, viewModel, material: material),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Excluir'),
                    content: Text('Tem certeza que deseja remover ${material.nome}?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
                      TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Excluir', style: TextStyle(color: Colors.red))),
                    ],
                  )
                );
                if (confirm == true) {
                  viewModel.deleteMaterial(material.id);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showMaterialDialog(BuildContext context, MateriaisViewModel viewModel, {MaterialItem? material}) {
    final formKey = GlobalKey<FormState>();
    final nomeCtrl = TextEditingController(text: material?.nome ?? '');
    final catCtrl = TextEditingController(text: material?.categoria ?? '');
    final localCtrl = TextEditingController(text: material?.localizacao ?? '');
    final qtdAtualCtrl = TextEditingController(text: material?.quantidadeAtual.toString() ?? '0');
    final qtdMinCtrl = TextEditingController(text: material?.quantidadeMinima.toString() ?? '0');
    final unidadeCtrl = TextEditingController(text: material?.unidade ?? 'un');

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(material == null ? 'Novo Material' : 'Editar Material'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nomeCtrl,
                    decoration: const InputDecoration(labelText: 'Nome do Material'),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Obrigatório' : null,
                  ),
                  TextFormField(
                    controller: catCtrl,
                    decoration: const InputDecoration(labelText: 'Categoria (ex: Elétrico, Hidráulico)'),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Obrigatório' : null,
                  ),
                  TextFormField(
                    controller: localCtrl,
                    decoration: const InputDecoration(labelText: 'Localização (ex: Almoxarifado A)'),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Obrigatório' : null,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: qtdAtualCtrl,
                          decoration: const InputDecoration(labelText: 'Qtd Atual'),
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Obrigatório';
                            final n = int.tryParse(v);
                            if (n == null || n < 0) return 'Valor inválido';
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: qtdMinCtrl,
                          decoration: const InputDecoration(labelText: 'Qtd Mínima'),
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Obrigatório';
                            final n = int.tryParse(v);
                            if (n == null || n < 0) return 'Valor inválido';
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: unidadeCtrl,
                    decoration: const InputDecoration(labelText: 'Unidade (ex: un, kg, m, litro)'),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Obrigatório' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final data = {
                    'nome': nomeCtrl.text.trim(),
                    'categoria': catCtrl.text.trim(),
                    'localizacao': localCtrl.text.trim(),
                    'quantidade_atual': int.tryParse(qtdAtualCtrl.text) ?? 0,
                    'quantidade_minima': int.tryParse(qtdMinCtrl.text) ?? 0,
                    'unidade': unidadeCtrl.text.trim(),
                  };
                  Navigator.pop(ctx);
                  await viewModel.saveMaterial(data, id: material?.id);
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      }
    );
  }
}
