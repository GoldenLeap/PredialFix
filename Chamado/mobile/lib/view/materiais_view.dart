import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
<<<<<<< HEAD
import '../view_models/materiais_view_model.dart';
import '../models/material_model.dart';

=======
import '../services/material_service.dart';
import '../view_models/home_view_model.dart';
import '../widgets/cust_drawer.dart';
>>>>>>> fa6256c34e6d440e3b2bb93a2b5a899aad3e923c
class MateriaisView extends StatefulWidget {
  const MateriaisView({super.key});

  @override
  State<MateriaisView> createState() => _MateriaisViewState();
}

class _MateriaisViewState extends State<MateriaisView> {
<<<<<<< HEAD
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
=======
  final MaterialService _service = MaterialService();
  bool _isLoading = true;
  String _error = '';
  String _busca = '';
  Map<String, dynamic>? _data;

  @override
  void initState() {
    super.initState();
    _loadMaterials();
  }

  Future<void> _loadMaterials() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });
    try {
      _data = await _service.getMaterials(busca: _busca);
    } catch (e) {
      _error = e.toString();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeViewModel = context.read<HomeViewModel>();
    final materiais = (_data?['materiais'] as List<dynamic>?) ?? [];
    final totalizadores = _data?['totalizadores'] as Map<String, dynamic>?;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Materiais'),
        backgroundColor: const Color(0xFFFF0000),
        foregroundColor: Colors.white,
      ),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error.isNotEmpty
                ? Center(child: Text(_error, style: const TextStyle(color: Colors.red)))
                : RefreshIndicator(
                    onRefresh: _loadMaterials,
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Estoque de Materiais', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text('Total: ${totalizadores?['total'] ?? 0} • Crítico: ${totalizadores?['critico'] ?? 0} • Baixo: ${totalizadores?['baixo'] ?? 0} • Adequado: ${totalizadores?['adequado'] ?? 0}', style: const TextStyle(color: Colors.grey)),
                              const SizedBox(height: 16),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Pesquisar materiais',
                                  prefixIcon: const Icon(Icons.search),
                                  border: const OutlineInputBorder(),
                                  suffixIcon: _busca.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(Icons.clear),
                                          onPressed: () {
                                            setState(() {
                                              _busca = '';
                                            });
                                            _loadMaterials();
                                          },
                                        )
                                      : null,
                                ),
                                onChanged: (value) => _busca = value,
                                onSubmitted: (_) => _loadMaterials(),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                        materiais.isEmpty
                            ? SliverFillRemaining(
                                hasScrollBody: false,
                                child: Center(child: Text(_error.isEmpty ? 'Nenhum material encontrado.' : _error)),
                              )
                            : SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    final item = materiais[index] as Map<String, dynamic>;
                                    final status = item['status_estoque'] ?? 'Desconhecido';
                                    final quantity = item['quantidade_atual'] ?? 0;
                                    final minimum = item['quantidade_minima'] ?? 0;
                                    final percent = minimum > 0 ? (quantity / minimum * 100).clamp(0, 100).toDouble() : 0.0;
                                    Color statusColor;
                                    switch (status) {
                                      case 'Crítico':
                                        statusColor = Colors.red;
                                        break;
                                      case 'Baixo':
                                        statusColor = Colors.orange;
                                        break;
                                      default:
                                        statusColor = Colors.green;
                                    }
                                    return Card(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(item['nome'] ?? 'Sem nome', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                                  decoration: BoxDecoration(
                                                    color: statusColor.withOpacity(0.12),
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Text(item['categoria'] ?? '-', style: const TextStyle(color: Colors.grey)),
                                            const SizedBox(height: 12),
                                            LinearProgressIndicator(value: percent / 100, color: statusColor, backgroundColor: statusColor.withOpacity(0.12)),
                                            const SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('Atual: $quantity / Mín: $minimum', style: const TextStyle(fontSize: 12, color: Colors.black87)),
                                                Text(item['localizacao'] ?? '-', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  childCount: materiais.length,
                                ),
                              ),
                      ],
                    ),
                  ),
      ),
    );
  }
>>>>>>> fa6256c34e6d440e3b2bb93a2b5a899aad3e923c
}
