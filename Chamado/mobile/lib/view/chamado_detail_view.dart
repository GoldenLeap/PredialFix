import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../models/chamado_model.dart';
import '../view_models/home_view_model.dart';
import '../services/material_service.dart';

class ChamadoDetailView extends StatefulWidget {
  final Chamado chamado;

  const ChamadoDetailView({super.key, required this.chamado});

  @override
  State<ChamadoDetailView> createState() => _ChamadoDetailViewState();
}

class _ChamadoDetailViewState extends State<ChamadoDetailView> {
  final MaterialService _materialService = MaterialService();
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chamado #${widget.chamado.id}'),
        backgroundColor: const Color(0xFFFF0000),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 16),
            _buildDescriptionCard(),
            const SizedBox(height: 16),
            
            Consumer<HomeViewModel>(builder: (context, viewModel, _) {
              if (viewModel.userCargo == 'solicitante') return const SizedBox.shrink();
              return Column(
                children: [
                  _buildFinancialCard(),
                  const SizedBox(height: 16),
                  _buildMateriaisCard(viewModel),
                  const SizedBox(height: 16),
                  _buildEvidenciasCard(viewModel),
                  const SizedBox(height: 16),
                ],
              );
            }),

            if (widget.chamado.imagemUrl != null && widget.chamado.imagemUrl!.isNotEmpty) ...[
               _buildProblemImageCard(),
               const SizedBox(height: 16),
            ],

            if (widget.chamado.observacao != null && widget.chamado.observacao!.isNotEmpty)
              _buildObservationCard(),
            const SizedBox(height: 16),

            if (widget.chamado.historicos.isNotEmpty)
              _buildHistoricoList(),

            if (widget.chamado.status != 'Concluído')
              Consumer<HomeViewModel>(builder: (context, viewModel, _) {
                if (viewModel.userCargo == 'solicitante') return const SizedBox.shrink();
                return _buildStatusActions(viewModel);
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.chamado.prioridade == 'Alta' ? Colors.red[50] : widget.chamado.prioridade == 'Média' ? Colors.amber[50] : Colors.green[50],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${widget.chamado.prioridadeEmoji} ${widget.chamado.prioridade}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: widget.chamado.prioridade == 'Alta' ? Colors.red[800] : widget.chamado.prioridade == 'Média' ? Colors.amber[800] : Colors.green[800],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.chamado.statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${widget.chamado.statusEmoji} ${widget.chamado.status}',
                    style: TextStyle(fontWeight: FontWeight.bold, color: widget.chamado.statusColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(widget.chamado.assunto, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _detailRow(Icons.category, widget.chamado.tipo),
            _detailRow(Icons.location_on, widget.chamado.local),
            _detailRow(Icons.person, 'Usuário ID: ${widget.chamado.usuarioId}'),
            if (widget.chamado.tipoServico.isNotEmpty) _detailRow(Icons.build, 'Tipo: ${widget.chamado.tipoServico}'),
            _detailRow(Icons.calendar_today, 'Aberto em: ${_formatDate(widget.chamado.createdAt)}'),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Descrição', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(widget.chamado.descricao, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialCard() {
    final total = widget.chamado.custoMaoObra + widget.chamado.custoMateriais;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Execução & Financeiro', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _detailRow(Icons.engineering, 'Técnico: ${widget.chamado.tecnicoNome ?? "Não atribuído"}'),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Mão de Obra:', style: TextStyle(fontSize: 13, color: Colors.grey)),
                Text('R\$ ${widget.chamado.custoMaoObra.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Materiais:', style: TextStyle(fontSize: 13, color: Colors.grey)),
                Text('R\$ ${widget.chamado.custoMateriais.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
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
  }

  Widget _buildMateriaisCard(HomeViewModel viewModel) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Materiais Consumidos', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                if (widget.chamado.status != 'Concluído')
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Color(0xFFFF0000)),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => _showAddMaterialDialog(viewModel),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (widget.chamado.materiais == null || widget.chamado.materiais!.isEmpty)
              const Text('Nenhum material registrado.', style: TextStyle(color: Colors.grey, fontSize: 13))
            else
              ...widget.chamado.materiais!.map((mat) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${mat['quantidade']}x ${mat['nome']}',
                        style: const TextStyle(fontSize: 13),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text('R\$ ${mat['pivot']?['subtotal'] ?? 0.0}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
              )),
            if (widget.chamado.status != 'Concluído' && widget.chamado.status != 'Aguardando Material') ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _showSolicitarMaterialDialog(viewModel),
                  icon: const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                  label: const Text('Falta material? Solicitar', style: TextStyle(color: Colors.orange)),
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.orange)),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildEvidenciasCard(HomeViewModel viewModel) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Evidências Fotográficas', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                if (widget.chamado.status != 'Concluído')
                  IconButton(
                    icon: const Icon(Icons.camera_alt, color: Color(0xFFFF0000)),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => _showAddEvidenciaDialog(viewModel),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (widget.chamado.evidencias == null || widget.chamado.evidencias!.isEmpty)
              const Text('Nenhuma evidência anexada.', style: TextStyle(color: Colors.grey, fontSize: 13))
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: widget.chamado.evidencias!.length,
                itemBuilder: (context, index) {
                  final ev = widget.chamado.evidencias![index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(_resolveImageUrl(ev['caminho_arquivo']), fit: BoxFit.cover),
                        Positioned(
                          bottom: 0, left: 0, right: 0,
                          child: Container(
                            color: Colors.black54,
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              ev['tipo'].toString().toUpperCase(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              )
          ],
        ),
      ),
    );
  }

  Widget _buildProblemImageCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Imagem Inicial (Solicitante)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                _resolveImageUrl(widget.chamado.imagemUrl),
                width: double.infinity, fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildObservationCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Observação', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(widget.chamado.observacao!, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoricoList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Histórico de alterações', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...widget.chamado.historicos.map((h) => Card(
          margin: const EdgeInsets.only(bottom: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.swap_horiz, size: 20),
            ),
            title: Text('${h.statusAnterior} → ${h.statusNovo}', style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(_formatDate(h.dataAlteracao)),
          ),
        )),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildStatusActions(HomeViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Atualizar status', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...Chamado.statusList.where((s) => s != widget.chamado.status).map((status) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: ElevatedButton(
            onPressed: () async {
              if (viewModel.tecnicos.isEmpty) {
                _showLoading();
                await viewModel.fetchTecnicos();
                if (mounted) Navigator.pop(context);
              }
              if (mounted) _showStatusTransitionDialog(context, viewModel, status);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: status == 'Concluído' ? Colors.blue : status == 'Em Execução' ? Colors.orange : Colors.amber,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              foregroundColor: Colors.white,
            ),
            child: Text(status),
          ),
        )),
      ],
    );
  }

  void _showAddMaterialDialog(HomeViewModel viewModel) async {
    _showLoading();
    final materiaisResponse = await _materialService.getMateriais();
    if (!mounted) return;
    Navigator.pop(context);

    if (materiaisResponse == null || materiaisResponse['materiais'] == null) {
      _showSnack('Erro ao carregar materiais', isError: true);
      return;
    }

    final materiais = materiaisResponse['materiais'] as List;
    int? selectedMaterialId;
    final qtyCtrl = TextEditingController(text: '1');
    final formKey = GlobalKey<FormState>();

    showDialog(context: context, builder: (ctx) => StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        title: const Text('Adicionar Material'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Material', border: OutlineInputBorder()),
                value: selectedMaterialId,
                isExpanded: true,
                items: materiais.map((m) => DropdownMenuItem<int>(
                  value: m['id'] as int,
                  child: Text('[${m['categoria'] ?? 'Outros'}] ${m['nome']} (Estoque: ${m['quantidade_atual']})'),
                )).toList(),
                onChanged: (val) => setState(() => selectedMaterialId = val),
                validator: (val) => val == null ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: qtyCtrl,
                decoration: const InputDecoration(labelText: 'Quantidade', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Obrigatório';
                  if (int.tryParse(v) == null || int.parse(v) <= 0) return 'Inválido';
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                Navigator.pop(ctx);
                _showLoading();
                final success = await viewModel.adicionarMaterial(widget.chamado.id, selectedMaterialId!, int.parse(qtyCtrl.text));
                if (mounted) {
                  Navigator.pop(context);
                  if (success) {
                    _showSnack('Material adicionado e debitado do estoque!');
                    Navigator.pop(context); // Pop view to refresh or rely on provider
                  } else {
                    _showSnack('Erro ao adicionar material', isError: true);
                  }
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF0000), foregroundColor: Colors.white),
            child: const Text('Adicionar'),
          )
        ],
      );
    }));
  }

  void _showSolicitarMaterialDialog(HomeViewModel viewModel) {
    final obsCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text('Solicitar Compra'),
      content: Form(
        key: formKey,
        child: TextFormField(
          controller: obsCtrl,
          decoration: const InputDecoration(labelText: 'Quais materiais faltam?', border: OutlineInputBorder()),
          maxLines: 3,
          validator: (v) => v == null || v.trim().isEmpty ? 'Obrigatório' : null,
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar', style: TextStyle(color: Colors.grey))),
        ElevatedButton(
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              Navigator.pop(ctx);
              _showLoading();
              final success = await viewModel.solicitarMaterial(widget.chamado.id, obsCtrl.text);
              if (mounted) {
                Navigator.pop(context);
                if (success) {
                  _showSnack('Solicitação enviada. Gestão notificada.');
                  Navigator.pop(context);
                } else {
                  _showSnack('Erro ao solicitar', isError: true);
                }
              }
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
          child: const Text('Enviar Solicitação'),
        )
      ],
    ));
  }

  void _showAddEvidenciaDialog(HomeViewModel viewModel) {
    showModalBottomSheet(context: context, builder: (ctx) {
      return SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Tirar foto (Antes)'),
              onTap: () { Navigator.pop(ctx); _pickAndUploadImage(viewModel, 'antes', ImageSource.camera); },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blue),
              title: const Text('Tirar foto (Depois)'),
              onTap: () { Navigator.pop(ctx); _pickAndUploadImage(viewModel, 'depois', ImageSource.camera); },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeria (Geral)'),
              onTap: () { Navigator.pop(ctx); _pickAndUploadImage(viewModel, 'geral', ImageSource.gallery); },
            ),
          ],
        ),
      );
    });
  }

  Future<void> _pickAndUploadImage(HomeViewModel viewModel, String tipo, ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source, imageQuality: 70);
      if (image == null) return;
      if (!mounted) return;

      _showLoading();
      final success = await viewModel.uploadEvidencias(widget.chamado.id, [image.path], [tipo]);
      if (mounted) {
        Navigator.pop(context);
        if (success) {
          _showSnack('Evidência salva com sucesso!');
          Navigator.pop(context); // Pop view to refresh
        } else {
          _showSnack('Erro ao enviar foto', isError: true);
        }
      }
    } catch (e) {
      _showSnack('Erro de câmera: $e', isError: true);
    }
  }

  void _showStatusTransitionDialog(BuildContext context, HomeViewModel viewModel, String targetStatus) {
    final formKey = GlobalKey<FormState>();
    int? selectedTecnicoId = widget.chamado.tecnicoId;
    final maoObraCtrl = TextEditingController(text: widget.chamado.custoMaoObra > 0 ? widget.chamado.custoMaoObra.toString() : '');
    final materiaisCtrl = TextEditingController(text: widget.chamado.custoMateriais > 0 ? widget.chamado.custoMateriais.toString() : '');
    final obsCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
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
                    items: viewModel.tecnicos.map((t) => DropdownMenuItem<int>(value: t['id'] as int, child: Text(t['name'] as String))).toList(),
                    onChanged: (val) => setState(() => selectedTecnicoId = val),
                    validator: (val) => val == null ? 'Selecione um técnico' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: maoObraCtrl,
                    decoration: const InputDecoration(labelText: 'Custo Mão de Obra (R\$)', border: OutlineInputBorder()),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (v) => (v == null || v.trim().isEmpty) ? null : (double.tryParse(v) == null ? 'Inválido' : null),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: materiaisCtrl,
                    decoration: const InputDecoration(labelText: 'Custo Materiais (R\$)', border: OutlineInputBorder()),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (v) => (v == null || v.trim().isEmpty) ? null : (double.tryParse(v) == null ? 'Inválido' : null),
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
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar', style: TextStyle(color: Colors.grey))),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final obs = obsCtrl.text.trim();
                  final maoObra = double.tryParse(maoObraCtrl.text) ?? 0.0;
                  final mat = double.tryParse(materiaisCtrl.text) ?? 0.0;
                  
                  Navigator.pop(ctx);
                  _showLoading();

                  final success = await viewModel.updateStatus(
                    widget.chamado.id, targetStatus,
                    observacao: obs.isNotEmpty ? obs : null,
                    tecnicoId: selectedTecnicoId,
                    custoMaoObra: maoObra,
                    custoMateriais: mat,
                  );

                  if (mounted) {
                    Navigator.pop(context);
                    if (success) {
                      Navigator.pop(context); // volta pra tela inicial
                      _showSnack('Chamado atualizado para $targetStatus!');
                    } else {
                      _showSnack('Erro ao atualizar chamado.', isError: true);
                    }
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF0000), foregroundColor: Colors.white),
              child: const Text('Confirmar'),
            ),
          ],
        ),
      )
    );
  }

  void _showLoading() {
    showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: isError ? Colors.red : Colors.green));
  }

  Widget _detailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 6),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: Colors.grey))),
        ],
      ),
    );
  }

  String _resolveImageUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    var resolved = url;
    if (resolved.contains('localhost')) resolved = resolved.replaceAll('localhost', '10.0.2.2:8000');
    else if (resolved.contains('127.0.0.1')) resolved = resolved.replaceAll('127.0.0.1', '10.0.2.2:8000');
    return resolved;
  }

  String _formatDate(String date) {
    if (date.isEmpty) return '';
    try {
      final parts = date.split('T');
      if (parts.isNotEmpty) {
        final dateParts = parts[0].split('-');
        if (dateParts.length == 3) return '${dateParts[2]}/${dateParts[1]}/${dateParts[0]}';
      }
    } catch (_) {}
    return date;
  }
}