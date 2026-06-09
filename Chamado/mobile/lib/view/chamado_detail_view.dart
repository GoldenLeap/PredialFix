import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/chamado_model.dart';
import '../view_models/home_view_model.dart';

class ChamadoDetailView extends StatelessWidget {
  final Chamado chamado;

  const ChamadoDetailView({super.key, required this.chamado});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chamado #${chamado.id}'),
        backgroundColor: const Color(0xFFFF0000),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
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
                              fontWeight: FontWeight.bold,
                              color: chamado.prioridade == 'Alta'
                                  ? Colors.red[800]
                                  : chamado.prioridade == 'Média'
                                      ? Colors.amber[800]
                                      : Colors.green[800],
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color:
                                chamado.statusColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${chamado.statusEmoji} ${chamado.status}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: chamado.statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      chamado.assunto,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _detailRow(Icons.category, chamado.tipo),
                    _detailRow(Icons.location_on, chamado.local),
                    _detailRow(Icons.person, 'Usuário ID: ${chamado.usuarioId}'),
                    if (chamado.tipoServico.isNotEmpty)
                      _detailRow(
                          Icons.build, 'Tipo: ${chamado.tipoServico}'),
                    _detailRow(Icons.calendar_today,
                        'Aberto em: ${_formatDate(chamado.createdAt)}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Card(
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Descrição',
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      chamado.descricao,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Consumer<HomeViewModel>(
              builder: (context, viewModel, _) {
                if (viewModel.userCargo == 'solicitante') {
                  return const SizedBox.shrink();
                }

                final total = chamado.custoMaoObra + chamado.custoMateriais;

                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Execução & Financeiro',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        _detailRow(Icons.engineering, 'Técnico: ${chamado.tecnicoNome ?? "Não atribuído"}'),
                        const Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Mão de Obra:', style: TextStyle(fontSize: 13, color: Colors.grey)),
                            Text('R\$ ${chamado.custoMaoObra.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Materiais:', style: TextStyle(fontSize: 13, color: Colors.grey)),
                            Text('R\$ ${chamado.custoMateriais.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Custo Total:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFFFF0000))),
                            Text('R\$ ${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFFFF0000))),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            if (chamado.imagemUrl != null && chamado.imagemUrl!.isNotEmpty) ...[
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Imagem do problema',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          _resolveImageUrl(chamado.imagemUrl),
                          width: double.infinity,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 120,
                              color: Colors.grey[100],
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.broken_image_outlined,
                                        size: 32, color: Colors.grey),
                                    SizedBox(height: 8),
                                    Text(
                                      'Não foi possível carregar a imagem',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            if (chamado.observacao != null && chamado.observacao!.isNotEmpty)
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Observação',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        chamado.observacao!,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),

            if (chamado.historicos.isNotEmpty) ...[
              const Text(
                'Histórico de alterações',
                style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...chamado.historicos.map((h) => Card(
                    margin: const EdgeInsets.only(bottom: 6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.swap_horiz, size: 20),
                      ),
                      title: Text(
                        '${h.statusAnterior} → ${h.statusNovo}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(_formatDate(h.dataAlteracao)),
                    ),
                  )),
              const SizedBox(height: 16),
            ],

            if (chamado.status != 'Concluído')
              Consumer<HomeViewModel>(
                builder: (context, viewModel, _) {
                  if (viewModel.userCargo == 'solicitante') {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Atualizar status',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ...Chamado.statusList
                          .where((s) => s != chamado.status)
                          .map((status) => Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 6),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (viewModel.tecnicos.isEmpty) {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (_) => const Center(
                                            child: CircularProgressIndicator()),
                                      );
                                      await viewModel.fetchTecnicos();
                                      if (context.mounted) {
                                        Navigator.pop(context);
                                      }
                                    }

                                    if (context.mounted) {
                                      _showStatusTransitionDialog(context, viewModel, status);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: status == 'Concluído'
                                        ? Colors.blue
                                        : status == 'Em Execução'
                                            ? Colors.orange
                                            : Colors.amber,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8)),
                                  ),
                                  child: Text(status),
                                ),
                              )),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        ],
      ),
    );
  }

  void _showStatusTransitionDialog(BuildContext context, HomeViewModel viewModel, String targetStatus) {
    final formKey = GlobalKey<FormState>();
    int? selectedTecnicoId = chamado.tecnicoId;
    final maoObraCtrl = TextEditingController(text: chamado.custoMaoObra > 0 ? chamado.custoMaoObra.toString() : '');
    final materiaisCtrl = TextEditingController(text: chamado.custoMateriais > 0 ? chamado.custoMateriais.toString() : '');
    final obsCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Mudar para: $targetStatus'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<int>(
                        decoration: const InputDecoration(labelText: 'Técnico Responsável', border: OutlineInputBorder()),
                        value: selectedTecnicoId,
                        items: viewModel.tecnicos.map((t) => DropdownMenuItem<int>(
                          value: t['id'] as int,
                          child: Text(t['name'] as String),
                        )).toList(),
                        onChanged: (val) => setState(() => selectedTecnicoId = val),
                        validator: (val) => val == null ? 'Selecione um técnico' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: maoObraCtrl,
                        decoration: const InputDecoration(labelText: 'Custo Mão de Obra (R\$)', border: OutlineInputBorder()),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return null;
                          final n = double.tryParse(v);
                          if (n == null || n < 0) return 'Valor inválido';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: materiaisCtrl,
                        decoration: const InputDecoration(labelText: 'Custo Materiais (R\$)', border: OutlineInputBorder()),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return null;
                          final n = double.tryParse(v);
                          if (n == null || n < 0) return 'Valor inválido';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: obsCtrl,
                        decoration: const InputDecoration(labelText: 'Observação (Opcional)', border: OutlineInputBorder()),
                        maxLines: 2,
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
                      final obs = obsCtrl.text.trim();
                      final maoObra = double.tryParse(maoObraCtrl.text) ?? 0.0;
                      final mat = double.tryParse(materiaisCtrl.text) ?? 0.0;
                      
                      Navigator.pop(ctx);

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => const Center(child: CircularProgressIndicator()),
                      );

                      final success = await viewModel.updateStatus(
                        chamado.id,
                        targetStatus,
                        observacao: obs.isNotEmpty ? obs : null,
                        tecnicoId: selectedTecnicoId,
                        custoMaoObra: maoObra,
                        custoMateriais: mat,
                      );

                      if (context.mounted) {
                        Navigator.pop(context);
                        if (success) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Chamado atualizado para $targetStatus!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Erro ao atualizar chamado.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF0000), foregroundColor: Colors.white),
                  child: const Text('Confirmar'),
                ),
              ],
            );
          }
        );
      }
    );
  }

  String _resolveImageUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    var resolved = url;
    if (resolved.contains('localhost')) {
      resolved = resolved.replaceAll('localhost', '10.0.2.2:8000');
    } else if (resolved.contains('127.0.0.1')) {
      resolved = resolved.replaceAll('127.0.0.1', '10.0.2.2:8000');
    }
    return resolved;
  }

  String _formatDate(String date) {
    if (date.isEmpty) return '';
    try {
      final parts = date.split('T');
      if (parts.isNotEmpty) {
        final dateParts = parts[0].split('-');
        if (dateParts.length == 3) {
          return '${dateParts[2]}/${dateParts[1]}/${dateParts[0]}';
        }
      }
    } catch (_) {}
    return date;
  }
}