import 'package:flutter/material.dart';
import '../models/chamado_model.dart';

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
            // Cabeçalho com status e prioridade
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
                                chamado.statusColor.withOpacity(0.15),
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

            // Descrição
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

            // Observação
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

            // Histórico
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

            // Botão para atualizar status (se não concluído)
            if (chamado.status != 'Concluído')
              Consumer<HomeViewModel>(
                builder: (context, viewModel, _) {
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
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (_) => const Center(
                                          child:
                                              CircularProgressIndicator()),
                                    );
                                    final success = await viewModel
                                        .updateStatus(chamado.id, status);
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                      if (success) {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Status atualizado para $status'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      }
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