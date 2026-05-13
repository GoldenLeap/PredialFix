import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/home_view_model.dart';
import '../view_models/login_view_model.dart';
import '../services/auth_service.dart';
import '../models/chamado_model.dart';
import 'chamado_form_view.dart';
import 'chamado_detail_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        if (!_initialized) {
          _initialized = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            viewModel.loadChamados();
          });
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Chamados'),
            backgroundColor: const Color(0xFFFF0000),
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  final authService = AuthService();
                  await authService.logout();
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, '/');
                  }
                },
                tooltip: 'Sair',
              ),
            ],
          ),
          body: _buildBody(context, viewModel),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _navigateToNewChamado(context),
            backgroundColor: const Color(0xFFFF0000),
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'Novo Chamado',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, HomeViewModel viewModel) {
    if (viewModel.isLoading && viewModel.filteredChamados.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                viewModel.errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: viewModel.loadChamados,
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        _buildFilterTabs(context, viewModel),
        Expanded(
          child: viewModel.filteredChamados.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('Nenhum chamado encontrado',
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: viewModel.loadChamados,
                  child: ListView.builder
                    (
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: viewModel.filteredChamados.length,
                    itemBuilder: (context, index) {
                      final chamado = viewModel.filteredChamados[index];
                      return _buildChamadoCard(context, chamado, viewModel);
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildFilterTabs(BuildContext context, HomeViewModel viewModel) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: _FilterTab(
              label: 'Abertos (${viewModel.chamadosAbertos.length})',
              isActive: viewModel.currentFilter == 'Abertos',
              onTap: () {
                viewModel.currentFilter = 'Abertos';
              },
            ),
          ),
          Expanded(
            child: _FilterTab(
              label: 'Concluídos (${viewModel.chamadosConcluidos.length})',
              isActive: viewModel.currentFilter == 'Concluídos',
              onTap: () {
                viewModel.currentFilter = 'Concluídos';
              },
            ),
          ),
          Expanded(
            child: _FilterTab(
              label: 'Todos (${viewModel.chamados.length})',
              isActive: viewModel.currentFilter == 'Todos',
              onTap: () {
                viewModel.currentFilter = 'Todos';
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChamadoCard(
      BuildContext context, Chamado chamado, HomeViewModel viewModel) {
    return Dismissible(
      key: Key('chamado_${chamado.id}'),
      direction: chamado.status == 'Concluído'
          ? DismissDirection.none
          : DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) async {},
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChamadoDetailView(chamado: chamado),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: chamado.prioridade == 'Alta'
                            ? Colors.red[50]
                            : chamado.prioridade == 'Média'
                                ? Colors.amber[50]
                                : Colors.green[50],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${chamado.prioridadeEmoji} ${chamado.prioridade}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: chamado.prioridade == 'Alta'
                              ? Colors.red[800]
                              : chamado.prioridade == 'Média'
                                  ? Colors.amber[800]
                                  : Colors.green[800],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '#${chamado.id} - ${chamado.assunto}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.category, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(chamado.tipo,
                        style:
                            TextStyle(fontSize: 12, color: Colors.grey[600])),
                    const SizedBox(width: 12),
                    Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(chamado.local,
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: chamado.statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${chamado.statusEmoji} ${chamado.status}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: chamado.statusColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatDate(chamado.createdAt),
                      style:
                          TextStyle(fontSize: 11, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(String date) {
    if (date.isEmpty) return '';
    try {
      final parts = date.split('T');
      if (parts.length >= 1) {
        final dateParts = parts[0].split('-');
        if (dateParts.length == 3) {
          return '${dateParts[2]}/${dateParts[1]}/${dateParts[0]}';
        }
      }
    } catch (_) {}
    return date;
  }

  void _navigateToNewChamado(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ChamadoFormView()),
    );
  }
}

class _FilterTab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterTab({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? const Color(0xFFFF0000) : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? const Color(0xFFFF0000) : Colors.grey[600],
          ),
        ),
      ),
    );
  }
}