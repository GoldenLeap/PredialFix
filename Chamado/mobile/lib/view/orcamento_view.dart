import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/orcamento_view_model.dart';

class OrcamentoView extends StatefulWidget {
  const OrcamentoView({super.key});

  @override
  State<OrcamentoView> createState() => _OrcamentoViewState();
}

class _OrcamentoViewState extends State<OrcamentoView> {
  bool _initialized = false;

  final List<String> _months = [
    'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<OrcamentoViewModel>(
      builder: (context, viewModel, child) {
        if (!_initialized) {
          _initialized = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            viewModel.loadBudget();
          });
        }

        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            title: const Text('Orçamento Mensal'),
            backgroundColor: const Color(0xFFFF0000),
            foregroundColor: Colors.white,
            actions: [
              IconButton(icon: const Icon(Icons.refresh), onPressed: viewModel.loadBudget),
            ],
          ),
          body: viewModel.isLoading 
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: viewModel.loadBudget,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (viewModel.errorMessage != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        color: Colors.red.shade100,
                        child: Text(viewModel.errorMessage!, style: const TextStyle(color: Colors.red)),
                      ),
                      
                    _buildFiltro(viewModel),
                    const SizedBox(height: 16),
                    _buildOrcamentoCard(context, viewModel),
                    const SizedBox(height: 24),
                    const Text('Histórico (Últimos 6 Meses)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(height: 12),
                    _buildHistorico(viewModel),
                  ],
                ),
              ),
        );
      },
    );
  }

  Widget _buildFiltro(OrcamentoViewModel viewModel) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Selecione o Mês:', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                DropdownButton<int>(
                  value: viewModel.selectedMonth,
                  underline: const SizedBox(),
                  items: List.generate(12, (i) => DropdownMenuItem(value: i + 1, child: Text(_months[i]))),
                  onChanged: (val) {
                    if (val != null) viewModel.setDate(val, viewModel.selectedYear);
                  },
                ),
                const SizedBox(width: 8),
                DropdownButton<int>(
                  value: viewModel.selectedYear,
                  underline: const SizedBox(),
                  items: List.generate(5, (i) => DropdownMenuItem(value: DateTime.now().year - 2 + i, child: Text('${DateTime.now().year - 2 + i}'))),
                  onChanged: (val) {
                    if (val != null) viewModel.setDate(viewModel.selectedMonth, val);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrcamentoCard(BuildContext context, OrcamentoViewModel viewModel) {
    final orcTotal = viewModel.orcamentoTotal;
    final gasto = viewModel.totalGasto;
    final saldo = viewModel.orcamentoRestante;

    if (viewModel.config == null || orcTotal == 0) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Icon(Icons.money_off, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('Nenhum orçamento definido para este mês.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _showDefineBudgetDialog(context, viewModel),
                icon: const Icon(Icons.add),
                label: const Text('DEFINIR ORÇAMENTO'),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF0000), foregroundColor: Colors.white),
              )
            ],
          ),
        ),
      );
    }

    final percentGasto = orcTotal > 0 ? (gasto / orcTotal).clamp(0.0, 1.0) : 0.0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Orçamento Definido:', style: TextStyle(fontSize: 16, color: Colors.grey)),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _showDefineBudgetDialog(context, viewModel, initialValue: orcTotal),
                  tooltip: 'Editar Orçamento',
                ),
              ],
            ),
            Text('R\$ ${orcTotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Valor Utilizado', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                    Text('R\$ ${gasto.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Saldo Restante', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    Text('R\$ ${saldo.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: percentGasto,
              minHeight: 12,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(percentGasto > 0.9 ? Colors.red : Colors.green),
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistorico(OrcamentoViewModel viewModel) {
    if (viewModel.historico.isEmpty) {
      return const Center(child: Padding(padding: EdgeInsets.all(16.0), child: Text("Sem histórico registrado.")));
    }

    return Column(
      children: viewModel.historico.map((h) {
        final orcInicial = (h['orcamento_inicial'] as num?)?.toDouble() ?? 0;
        final totalGasto = (h['total_gasto'] as num?)?.toDouble() ?? 0;
        final variancia = (h['variancia'] as num?)?.toDouble() ?? 0;
        final status = h['status']?.toString() ?? '';
        final mes = h['mes']?.toString() ?? '';

        final isOk = variancia >= 0;

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isOk ? Colors.green.shade100 : Colors.red.shade100,
              child: Icon(Icons.calendar_month, color: isOk ? Colors.green : Colors.red),
            ),
            title: Text(mes, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Gasto: R\$ ${totalGasto.toStringAsFixed(2)} de R\$ ${orcInicial.toStringAsFixed(2)}'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isOk ? Colors.green.shade50 : Colors.red.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(status, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: isOk ? Colors.green : Colors.red)),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showDefineBudgetDialog(BuildContext context, OrcamentoViewModel viewModel, {double initialValue = 0}) {
    final ctrl = TextEditingController(text: initialValue > 0 ? initialValue.toString() : '');
    final form = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Definir Orçamento'),
        content: Form(
          key: form,
          child: TextFormField(
            controller: ctrl,
            decoration: const InputDecoration(labelText: 'Valor Total (R\$)', border: OutlineInputBorder()),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Obrigatório';
              final n = double.tryParse(v);
              if (n == null || n < 0) return 'Valor inválido';
              return null;
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              if (form.currentState!.validate()) {
                final val = double.tryParse(ctrl.text) ?? 0.0;
                Navigator.pop(ctx);
                await viewModel.saveBudget(val);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF0000), foregroundColor: Colors.white),
            child: const Text('Salvar'),
          ),
        ],
      )
    );
  }
}
