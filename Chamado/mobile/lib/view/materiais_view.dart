import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/material_service.dart';
import '../view_models/home_view_model.dart';
import '../widgets/cust_drawer.dart';
class MateriaisView extends StatefulWidget {
  const MateriaisView({super.key});

  @override
  State<MateriaisView> createState() => _MateriaisViewState();
}

class _MateriaisViewState extends State<MateriaisView> {
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
}
