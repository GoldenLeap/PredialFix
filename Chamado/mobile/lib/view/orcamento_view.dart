import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/budget_service.dart';
import '../view_models/home_view_model.dart';
import '../widgets/cust_drawer.dart';
class OrcamentoView extends StatefulWidget {
  const OrcamentoView({super.key});

  @override
  State<OrcamentoView> createState() => _OrcamentoViewState();
}

class _OrcamentoViewState extends State<OrcamentoView> {
  final BudgetService _service = BudgetService();
  bool _isLoading = true;
  String _error = '';
  int _mes = DateTime.now().month;
  int _ano = DateTime.now().year;
  double _totalBudget = 0;
  bool _alertEnabled = false;
  List<dynamic> _historico = [];

  @override
  void initState() {
    super.initState();
    _loadBudget();
  }

  Future<void> _loadBudget() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });
    try {
      final data = await _service.getBudget(mes: _mes, ano: _ano);
      final config = data['config'] as Map<String, dynamic>?;
      _totalBudget = (config?['total_budget'] ?? 0).toDouble();
      _alertEnabled = config?['alert_enabled'] ?? false;
      _historico = data['historico'] as List<dynamic>? ?? [];
    } catch (e) {
      _error = e.toString();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveBudget() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });
    try {
      final success = await _service.saveBudget(mes: _mes, ano: _ano, totalBudget: _totalBudget, alertEnabled: _alertEnabled);
      if (success) {
        await _loadBudget();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Orçamento salvo com sucesso!'), backgroundColor: Colors.green));
        }
      } else {
        _error = 'Falha ao salvar orçamento';
      }
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
        title: const Text('Orçamento'),
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
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Configuração do orçamento', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<int>(
                                value: _mes,
                                decoration: const InputDecoration(labelText: 'Mês', border: OutlineInputBorder()),
                                items: List.generate(12, (index) => index + 1)
                                    .map((value) => DropdownMenuItem(value: value, child: Text(value.toString())))
                                    .toList(),
                                onChanged: (value){
                                  if (value != null) {
                                    setState(() {
                                      _mes = value;
                                    });
                                    _loadBudget();
                                  }
                                }
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DropdownButtonFormField<int>(
                                value: _ano,
                                decoration: const InputDecoration(labelText: 'Ano', border: OutlineInputBorder()),
                                items: List.generate(5, (index) => DateTime.now().year - 2 + index)
                                    .map((value) => DropdownMenuItem(value: value, child: Text(value.toString())))
                                    .toList(),
                                onChanged: (value) => setState(() {
                                  if (value != null) {
                                    _ano = value;
                                    _loadBudget();
                                  }
                                }),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          key: ValueKey('${_mes}_${_ano}_$_totalBudget') , 
                          initialValue: _totalBudget.toStringAsFixed(2),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(labelText: 'Orçamento mensal (R\$)', border: OutlineInputBorder()),
                          onChanged: (value) {
                            _totalBudget = double.tryParse(value.replaceAll(',', '.')) ?? 0;
                          },
                        ),
                        const SizedBox(height: 12),
                        SwitchListTile(
                          title: const Text('Alerta de orçamento'),
                          value: _alertEnabled,
                          onChanged: (value) => setState(() => _alertEnabled = value),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _saveBudget,
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF0000)),
                            child: const Text('Salvar Orçamento'),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text('Histórico dos últimos 6 meses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        ..._historico.map((item) {
                          final status = item['status'] ?? 'N/A';
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              title: Text(item['mes'] ?? '-'),
                              subtitle: Text('Gasto: R\$ ${item['total_gasto']?.toStringAsFixed(2) ?? '0,00'} • Variância: R\$ ${item['variancia']?.toStringAsFixed(2) ?? '0,00'}'),
                              trailing: Text(status, style: TextStyle(color: status == 'Acima' ? Colors.red : Colors.green, fontWeight: FontWeight.bold)),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
      ),
    );
  }
}
