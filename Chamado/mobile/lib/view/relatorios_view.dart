import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/report_service.dart';
import '../view_models/home_view_model.dart';
import '../widgets/cust_drawer.dart';
class RelatoriosView extends StatefulWidget {
  const RelatoriosView({super.key});

  @override
  State<RelatoriosView> createState() => _RelatoriosViewState();
}

class _RelatoriosViewState extends State<RelatoriosView> {
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

  @override
  void initState() {
    super.initState();
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
  }

  @override
  Widget build(BuildContext context) {
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
      ),
    );
  }

  Widget _buildInfoItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
