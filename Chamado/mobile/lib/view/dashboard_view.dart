import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    final data = viewModel.dashboardData ?? {};

    final stats = data['stats'] ?? {};
    final total = (stats['total'] as num?)?.toInt() ?? 0;
    final abertos = (stats['abertos'] as num?)?.toInt() ?? 0;
    final emAnalise = (stats['em_analise'] as num?)?.toInt() ?? 0;
    final emExecucao = (stats['em_execucao'] as num?)?.toInt() ?? 0;
    final concluidos = (stats['concluidos'] as num?)?.toInt() ?? 0;

    final double resolutionRate = total > 0 ? (concluidos / total) * 100 : 0.0;

    final recentChamados = data['recentChamados'] as List<dynamic>? ?? [];
    final recentMaterials = data['recentMaterials'] as List<dynamic>? ?? [];
    final criticalMaterials = recentMaterials.where((m) => ((m['quantidade_atual'] as num?) ?? 0) < ((m['quantidade_minima'] as num?) ?? 0)).toList();
    final topUsers = data['topUsers'] as List<dynamic>? ?? [];

    return RefreshIndicator(
      onRefresh: viewModel.loadDashboard,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text('Painel de Controle', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const Text('Visão geral do sistema de manutenção predial.', style: TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 16),

          // KPI Cards Grid
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.5,
            children: [
              _buildModernKpiCard('Total', total.toString(), Icons.content_paste, Colors.grey),
              _buildModernKpiCard('Abertos', abertos.toString(), Icons.error_outline, Colors.blue),
              _buildModernKpiCard('Em Análise', emAnalise.toString(), Icons.content_paste_search, Colors.amber),
              _buildModernKpiCard('Execução', emExecucao.toString(), Icons.build, Colors.orange),
              _buildModernKpiCard('Concluídos', concluidos.toString(), Icons.check_circle_outline, Colors.green),
            ],
          ),
          const SizedBox(height: 24),

          // Taxa de Resolução
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Taxa de Resolução', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Icon(Icons.trending_up, color: Colors.green.shade600, size: 20),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('${resolutionRate.round()}%', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: resolutionRate / 100,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade500),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  const SizedBox(height: 8),
                  Text('$concluidos de $total resolvidos', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Estoque Crítico
          const Row(
            children: [
              Icon(Icons.inventory_2, color: Colors.red, size: 20),
              SizedBox(width: 8),
              Text('Estoque Crítico', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          if (criticalMaterials.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 40),
                    SizedBox(height: 8),
                    Text('Estoque normalizado!', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            )
          else
            ...criticalMaterials.take(5).map((m) {
              final qtd = m['quantidade_atual'] ?? 0;
              final min = m['quantidade_minima'] ?? 0;
              return Card(
                color: Colors.red.shade50,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.red.shade100)),
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(m['nome'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text(m['categoria'] ?? '', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.red.shade100, borderRadius: BorderRadius.circular(8)),
                    child: Text('$qtd / $min', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ),
              );
            }),
          const SizedBox(height: 24),

          // Usuários Mais Ativos
          const Row(
            children: [
              Icon(Icons.people, color: Colors.grey, size: 20),
              SizedBox(width: 8),
              Text('Mais Ativos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          if (topUsers.isEmpty)
            const Center(child: Padding(padding: EdgeInsets.all(16.0), child: Text("Sem dados.", style: TextStyle(color: Colors.grey))))
          else
            ...topUsers.take(5).map((u) {
              return Card(
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: Text((u['name'] ?? '?').toString().toUpperCase().substring(0, 1), style: TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.bold)),
                  ),
                  title: Text(u['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text(u['cargo'] ?? '', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  trailing: Text(u['chamados_count']?.toString() ?? '0', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue)),
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildModernKpiCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: color.withOpacity(0.3))),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(title, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color), overflow: TextOverflow.ellipsis)),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Icon(icon, color: color, size: 16),
                ),
              ],
            ),
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color == Colors.grey ? Colors.black87 : color)),
          ],
        ),
      ),
    );
  }
}
