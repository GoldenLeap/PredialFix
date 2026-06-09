import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
<<<<<<< HEAD
import '../view_models/dashboard_view_model.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  bool _initialized = false;

  final List<String> _months = [
    'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardViewModel>(
      builder: (context, viewModel, child) {
        if (!_initialized) {
          _initialized = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            viewModel.loadDashboard();
          });
        }

        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            title: const Text('Dashboard'),
            backgroundColor: const Color(0xFFFF0000),
            foregroundColor: Colors.white,
            actions: [
              IconButton(icon: const Icon(Icons.refresh), onPressed: viewModel.loadDashboard),
            ],
          ),
          body: viewModel.isLoading 
            ? const Center(child: CircularProgressIndicator())
            : viewModel.errorMessage != null
              ? Center(child: Text(viewModel.errorMessage!, style: const TextStyle(color: Colors.red)))
              : viewModel.dashboardData == null
                ? const Center(child: Text("Nenhum dado encontrado."))
                : _buildDashboardContent(context, viewModel),
        );
      },
    );
  }

  Widget _buildDashboardContent(BuildContext context, DashboardViewModel viewModel) {
    final data = viewModel.dashboardData!;

    // Mapear corretamente a estrutura real da API
    final financeiro = data['financeiro'] as Map<String, dynamic>? ?? {};
    final chamadosInfo = data['chamados'] as Map<String, dynamic>? ?? {};

    final double valorOrcamento = (financeiro['orcamento_total'] as num?)?.toDouble() ?? 0.0;
    final double valorGasto = (financeiro['total_gasto'] as num?)?.toDouble() ?? 0.0;
    final int abertos = (chamadosInfo['abertos'] as num?)?.toInt() ?? 0;
    final int finalizados = (chamadosInfo['finalizados'] as num?)?.toInt() ?? 0;
    final int emAndamento = (chamadosInfo['em_andamento'] as num?)?.toInt() ?? 0;

    final double saldo = valorOrcamento - valorGasto;

    // Atividades recentes é uma lista de Maps
    final atividadesRecentes = data['atividades_recentes'] as List<dynamic>? ?? [];

    return RefreshIndicator(
      onRefresh: viewModel.loadDashboard,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Seletor de Mês/Ano
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Período:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Row(
                    children: [
                      DropdownButton<int>(
                        value: viewModel.selectedMonth,
                        underline: const SizedBox(),
                        items: List.generate(12, (i) => DropdownMenuItem(
                          value: i + 1,
                          child: Text(_months[i]),
                        )),
                        onChanged: (val) {
                          if (val != null) viewModel.setDate(val, viewModel.selectedYear);
                        },
                      ),
                      const SizedBox(width: 8),
                      DropdownButton<int>(
                        value: viewModel.selectedYear,
                        underline: const SizedBox(),
                        items: List.generate(5, (i) => DropdownMenuItem(
                          value: DateTime.now().year - 2 + i,
                          child: Text('${DateTime.now().year - 2 + i}'),
                        )),
                        onChanged: (val) {
                          if (val != null) viewModel.setDate(viewModel.selectedMonth, val);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Cards de Chamados
          Row(
            children: [
              Expanded(child: _buildInfoCard('Abertos', abertos.toString(), Icons.inbox, Colors.orange)),
              const SizedBox(width: 8),
              Expanded(child: _buildInfoCard('Em Andamento', emAndamento.toString(), Icons.autorenew, Colors.blue)),
              const SizedBox(width: 8),
              Expanded(child: _buildInfoCard('Concluídos', finalizados.toString(), Icons.check_circle, Colors.green)),
            ],
          ),
          const SizedBox(height: 16),

          // Card Financeiro Principal
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: saldo >= 0 ? [Colors.green.shade700, Colors.green.shade500] : [Colors.red.shade700, Colors.red.shade500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Saldo Mensal', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text('R\$ ${saldo.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Orçamento', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          Text('R\$ ${valorOrcamento.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Gastos', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          Text('R\$ ${valorGasto.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: valorOrcamento > 0 ? (valorGasto / valorOrcamento).clamp(0.0, 1.0) : 0.0,
                    backgroundColor: Colors.white30,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          const Text('Atividades Recentes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          
          ..._buildAtividadesRecentes(atividadesRecentes),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAtividadesRecentes(List<dynamic> atividades) {
    if (atividades.isEmpty) {
      return [const Padding(padding: EdgeInsets.all(16.0), child: Text("Nenhuma atividade recente."))];
    }
    
    return atividades.take(5).map((a) {
      final descricao = a['descricao']?.toString() ?? '';
      final statusNovo = a['status_novo']?.toString() ?? '';
      final statusColor = statusNovo == 'Concluído' ? Colors.green : (statusNovo == 'Aberto' ? Colors.red : Colors.orange);
      return Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          title: Text(descricao, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          subtitle: Text('por ${a['alterado_por'] ?? 'Sistema'}', style: const TextStyle(fontSize: 12)),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Text(statusNovo, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ),
      );
    }).toList();
  }
}
=======
import '../widgets/cust_drawer.dart';


class DashboardView extends StatefulWidget{
  const DashboardView({super.key});

  @override 
  State<DashboardView> createState() => _DashboardViewState();

}

class _DashboardViewState extends State<DashboardView>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel de Controle'),
        backgroundColor: const Color(0xFFFF0000),
        foregroundColor: Colors.white,
      ),
      drawer: CustomDrawer()

    );
  }
}
>>>>>>> fa6256c34e6d440e3b2bb93a2b5a899aad3e923c
