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
            title: const Text('Gestão de Materiais'),
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
              : Column(
                  children: [
                    _buildTopStats(viewModel),
                    _buildFilters(viewModel),
                    Expanded(
                      child: viewModel.filteredMateriais.isEmpty
                        ? const Center(child: Text("Nenhum material encontrado."))
                        : RefreshIndicator(
                            onRefresh: viewModel.loadMateriais,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(12),
                              itemCount: viewModel.filteredMateriais.length,
                              itemBuilder: (context, index) {
                                final material = viewModel.filteredMateriais[index];
                                return _buildMaterialCard(context, material, viewModel);
                              },
                            ),
                          ),
                    ),
                  ],
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

  Widget _buildTopStats(MateriaisViewModel viewModel) {
    final materiais = viewModel.materiais;
    final total = materiais.length;
    final critico = materiais.where((m) => m.quantidadeAtual < m.quantidadeMinima * 0.3).length;
    final baixo = materiais.where((m) => m.quantidadeAtual < m.quantidadeMinima && m.quantidadeAtual >= m.quantidadeMinima * 0.3).length;
    final adequado = total - critico - baixo;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Row(
        children: [
          Expanded(child: _buildStatCard('Total', total.toString(), Icons.inventory_2, Colors.grey)),
          const SizedBox(width: 8),
          Expanded(child: _buildStatCard('Crítico', critico.toString(), Icons.warning, Colors.red)),
          const SizedBox(width: 8),
          Expanded(child: _buildStatCard('Baixo', baixo.toString(), Icons.warning_amber, Colors.orange)),
          const SizedBox(width: 8),
          Expanded(child: _buildStatCard('OK', adequado.toString(), Icons.check_circle, Colors.green)),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color == Colors.grey ? Colors.black87 : color)),
            Text(title, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters(MateriaisViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Pesquisar...',
                prefixIcon: const Icon(Icons.search, size: 20),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: viewModel.setSearchQuery,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: viewModel.selectedCategory.isEmpty ? null : viewModel.selectedCategory,
                  hint: const Text('Categoria', style: TextStyle(fontSize: 12)),
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, size: 20),
                  items: [
                    const DropdownMenuItem<String>(value: '', child: Text('Todas', style: TextStyle(fontSize: 12))),
                    ...viewModel.categories.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 12))))
                  ],
                  onChanged: (val) => viewModel.setSelectedCategory(val ?? ''),
                ),
              ),
            ),
          ),
        ],
      ),
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
    Color statusColor = Colors.green;
    String statusText = 'Adequado';
    if (material.quantidadeAtual < material.quantidadeMinima * 0.3) {
      statusColor = Colors.red;
      statusText = 'Crítico';
    } else if (material.quantidadeAtual < material.quantidadeMinima) {
      statusColor = Colors.orange;
      statusText = 'Baixo';
    }

    final pct = material.quantidadeMinima > 0 ? (material.quantidadeAtual / material.quantidadeMinima) : 1.0;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: statusColor.withOpacity(0.3))),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                  child: Icon(Icons.inventory_2, color: statusColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(width: 8, height: 8, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
                              const SizedBox(width: 4),
                              Text(statusText.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor, letterSpacing: 1)),
                            ],
                          ),
                          Row(
                            children: [
                              InkWell(onTap: () => _showMaterialDialog(context, viewModel, material: material), child: const Icon(Icons.edit, color: Colors.blue, size: 18)),
                              const SizedBox(width: 12),
                              InkWell(
                                onTap: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Excluir'),
                                      content: Text('Remover ${material.nome}?'),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
                                        TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Excluir', style: TextStyle(color: Colors.red))),
                                      ],
                                    )
                                  );
                                  if (confirm == true) viewModel.deleteMaterial(material.id);
                                },
                                child: const Icon(Icons.delete, color: Colors.red, size: 18),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(material.nome, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(material.categoria, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${material.quantidadeAtual} ${material.unidade}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                Text('mín: ${material.quantidadeMinima}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: pct.clamp(0.0, 1.0),
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              minHeight: 6,
              borderRadius: BorderRadius.circular(6),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(material.localizacao, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                Text('R\$ ${material.valorUnitario.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
              ],
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
    final valorCtrl = TextEditingController(text: material?.valorUnitario.toString() ?? '0.0');

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
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: unidadeCtrl,
                          decoration: const InputDecoration(labelText: 'Unidade (ex: un, kg, m)'),
                          validator: (v) => v == null || v.trim().isEmpty ? 'Obrigatório' : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: valorCtrl,
                          decoration: const InputDecoration(labelText: 'Valor Unit. (R\$)'),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Obrigatório';
                            if (double.tryParse(v) == null) return 'Inválido';
                            return null;
                          },
                        ),
                      ),
                    ],
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
                    'valor_unitario': double.tryParse(valorCtrl.text) ?? 0.0,
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
