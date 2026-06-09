import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
<<<<<<< HEAD
import '../view_models/relatorios_view_model.dart';

=======
import '../services/report_service.dart';
import '../view_models/home_view_model.dart';
import '../widgets/cust_drawer.dart';
>>>>>>> fa6256c34e6d440e3b2bb93a2b5a899aad3e923c
class RelatoriosView extends StatefulWidget {
  const RelatoriosView({super.key});

  @override
  State<RelatoriosView> createState() => _RelatoriosViewState();
}

class _RelatoriosViewState extends State<RelatoriosView> {
<<<<<<< HEAD
  bool _initialized = false;
  final ScrollController _scrollController = ScrollController();
  bool _showFilters = false;
=======
  final ReportService _service = ReportService();
  bool _isLoading = true;
  String _error = '';
  String _busca = '';
  String _status = '';
  String _tipo = '';
  List<dynamic> _reports = [];
  Map<String, dynamic> _totais = {};

  final List<String> _statusOptions = ['Aberto', 'Em Análise', 'Em Execução', 'Concluído'];
  final List<String> _tiposOptions = ['Elétrica', 'Hidráulica', 'Infraestrutura', 'Outros'];
>>>>>>> fa6256c34e6d440e3b2bb93a2b5a899aad3e923c

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
        context.read<RelatoriosViewModel>().loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
=======
    _loadReports();
  }

  Future<void> _loadReports() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });
    try {
      final data = await _service.getReports(busca: _busca, status: _status, tipo: _tipo);
      _reports = (data['relatorio'] as Map<String, dynamic>)['data'] as List<dynamic>? ?? [];
      _totais = data['totalizadores'] as Map<String, dynamic>? ?? {};
    } catch (e) {
      _error = e.toString();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
>>>>>>> fa6256c34e6d440e3b2bb93a2b5a899aad3e923c
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Consumer<RelatoriosViewModel>(
      builder: (context, viewModel, child) {
        if (!_initialized) {
          _initialized = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            viewModel.loadReports(reset: true);
          });
        }

        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            title: const Text('Relatórios'),
            backgroundColor: const Color(0xFFFF0000),
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: Icon(_showFilters ? Icons.filter_list_off : Icons.filter_list),
                onPressed: () => setState(() => _showFilters = !_showFilters),
              ),
            ],
          ),
          body: Column(
            children: [
              if (_showFilters) _buildFilters(viewModel),
              if (viewModel.totalizadores.isNotEmpty) _buildTotalizadores(viewModel),
              Expanded(
                child: viewModel.isLoading && viewModel.items.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : viewModel.errorMessage != null && viewModel.items.isEmpty
                    ? Center(child: Text(viewModel.errorMessage!, style: const TextStyle(color: Colors.red)))
                    : viewModel.items.isEmpty
                      ? const Center(child: Text("Nenhum chamado encontrado com estes filtros."))
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(8),
                          itemCount: viewModel.items.length + (viewModel.hasMorePages ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == viewModel.items.length) {
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(child: CircularProgressIndicator()),
                              );
                            }
                            final item = viewModel.items[index];
                            return _buildReportItem(item);
                          },
                        ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReportItem(Map<String, dynamic> item) {
    final status = item['status']?.toString() ?? '';
    final statusColor = status == 'Concluído' ? Colors.green 
                       : status == 'Aberto' ? Colors.red 
                       : Colors.orange;
    final custoTotal = (item['custo_total'] as num?)?.toDouble() ?? 0.0;

    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('#${item['id']} - ${item['servico'] ?? ''}', 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                  child: Text(status, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text('${item['local'] ?? ''}', style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                const SizedBox(width: 12),
                Icon(Icons.category, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text('${item['tipo'] ?? ''}', style: TextStyle(fontSize: 12, color: Colors.grey[700])),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Técnico: ${item['tecnico'] ?? 'Não atribuído'}', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                Text('R\$ ${custoTotal.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFFFF0000))),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${item['data'] ?? ''}', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                Text('${item['prioridade'] ?? ''}', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
              ],
            ),
          ],
        ),
=======
    final homeViewModel = context.read<HomeViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatórios'),
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
                : Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(labelText: 'Buscar por ID ou assunto', border: OutlineInputBorder()),
                              onChanged: (value) => _busca = value,
                              onFieldSubmitted: (_) => _loadReports(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: _loadReports,
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF0000)),
                            child: const Text('Filtrar'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _status.isEmpty ? null : _status,
                              decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
                              items: [const DropdownMenuItem(value: '', child: Text('Todos'))] +
                                  _statusOptions.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                              onChanged: (value) => setState(() {
                                _status = value ?? '';
                              }),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _tipo.isEmpty ? null : _tipo,
                              decoration: const InputDecoration(labelText: 'Tipo', border: OutlineInputBorder()),
                              items: [const DropdownMenuItem(value: '', child: Text('Todos'))] +
                                  _tiposOptions.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                              onChanged: (value) => setState(() {
                                _tipo = value ?? '';
                              }),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (_totais.isNotEmpty)
                        Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildInfoItem('Total', _totais['servicos_total']?.toString() ?? '0'),
                                _buildInfoItem('Custo total', 'R\$ ${(_totais['custo_total'] ?? 0).toStringAsFixed(2)}'),
                                _buildInfoItem('Mão de obra', 'R\$ ${(_totais['custo_mao_obra'] ?? 0).toStringAsFixed(2)}'),
                              ],
                            ),
                          ),
                        ),
                      Expanded(
                        child: _reports.isEmpty
                            ? const Center(child: Text('Nenhum relatório encontrado.'))
                            : ListView.builder(
                                itemCount: _reports.length,
                                itemBuilder: (context, index) {
                                  final item = _reports[index] as Map<String, dynamic>;
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    child: ListTile(
                                      title: Text('#${item['id']} - ${item['servico'] ?? item['assunto'] ?? 'Sem assunto'}'),
                                      subtitle: Text('${item['tipo'] ?? '-'} • ${item['status'] ?? '-'}'),
                                      trailing: Text('R\$ ${item['custo_total']?.toStringAsFixed(2) ?? '0,00'}'),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
>>>>>>> fa6256c34e6d440e3b2bb93a2b5a899aad3e923c
      ),
    );
  }

<<<<<<< HEAD
  Widget _buildFilters(RelatoriosViewModel viewModel) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            decoration: const InputDecoration(labelText: 'Busca (Assunto/ID)', border: OutlineInputBorder(), isDense: true),
            onChanged: (v) => viewModel.busca = v,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder(), isDense: true),
                  value: viewModel.status.isEmpty ? null : viewModel.status,
                  items: const [
                    DropdownMenuItem(value: '', child: Text('Todos')),
                    DropdownMenuItem(value: 'Aberto', child: Text('Aberto')),
                    DropdownMenuItem(value: 'Em Análise', child: Text('Em Análise')),
                    DropdownMenuItem(value: 'Em Execução', child: Text('Em Execução')),
                    DropdownMenuItem(value: 'Concluído', child: Text('Concluído')),
                  ],
                  onChanged: (v) => viewModel.status = v ?? '',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Prioridade', border: OutlineInputBorder(), isDense: true),
                  value: viewModel.prioridade.isEmpty ? null : viewModel.prioridade,
                  items: const [
                    DropdownMenuItem(value: '', child: Text('Todas')),
                    DropdownMenuItem(value: 'Baixa', child: Text('Baixa')),
                    DropdownMenuItem(value: 'Média', child: Text('Média')),
                    DropdownMenuItem(value: 'Alta', child: Text('Alta')),
                  ],
                  onChanged: (v) => viewModel.prioridade = v ?? '',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => viewModel.resetFilters(),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade300, foregroundColor: Colors.black),
                  child: const Text('Limpar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => viewModel.loadReports(reset: true),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF0000), foregroundColor: Colors.white),
                  child: const Text('Aplicar Filtros'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalizadores(RelatoriosViewModel viewModel) {
    final t = viewModel.totalizadores;
    final custoTotal = (t['custo_total'] as num?)?.toDouble() ?? 0.0;
    final custoMaoObra = (t['custo_mao_obra'] as num?)?.toDouble() ?? 0.0;
    final custoMateriais = (t['custo_materiais'] as num?)?.toDouble() ?? 0.0;

    return Container(
      color: Colors.red.shade50,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTotalItem('Total', '${t['servicos_total'] ?? 0}'),
          _buildTotalItem('Custo Total', 'R\$ ${custoTotal.toStringAsFixed(2)}'),
          _buildTotalItem('Mão de Obra', 'R\$ ${custoMaoObra.toStringAsFixed(2)}'),
          _buildTotalItem('Materiais', 'R\$ ${custoMateriais.toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  Widget _buildTotalItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFFFF0000))),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.black54)),
=======
  Widget _buildInfoItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
>>>>>>> fa6256c34e6d440e3b2bb93a2b5a899aad3e923c
      ],
    );
  }
}
