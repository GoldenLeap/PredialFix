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
            const SizedBox(height: 16),
            _buildTimeline(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline() {
    final stages = ['Aberto', 'Em Análise', 'Aguardando Material', 'Em Execução', 'Concluído'];
    final currentIndex = stages.indexOf(widget.chamado.status);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: stages.asMap().entries.map((entry) {
        int idx = entry.key;
        String stage = entry.value;
        bool isCompleted = currentIndex >= idx;
        bool isCurrent = currentIndex == idx;
        return Expanded(
          child: Column(
            children: [
              Container(
                width: 24, height: 24,
                decoration: BoxDecoration(
                  color: isCompleted ? Colors.red : Colors.grey.shade300,
                  shape: BoxShape.circle,
                  border: isCurrent ? Border.all(color: Colors.red.shade900, width: 2) : null,
                ),
                child: isCompleted ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
              ),
              const SizedBox(height: 4),
              Text(
                stage, 
                textAlign: TextAlign.center, 
                style: TextStyle(fontSize: 9, fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal, color: isCompleted ? Colors.black87 : Colors.grey),
              ),
            ],
          ),
        );
      }).toList(),
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
            const Text('Orçamento & Execução', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _detailRow(Icons.engineering, 'Técnico: ${widget.chamado.tecnicoNome ?? "Não atribuído"}'),
            const Divider(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Icons.person, color: Colors.blue, size: 20),
                            if (widget.chamado.status != 'Concluído')
                              InkWell(
                                onTap: () => _showUpdateLaborCostDialog(),
                                child: const Icon(Icons.edit, color: Colors.blue, size: 16),
                              )
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text('Mão de Obra', style: TextStyle(fontSize: 12, color: Colors.blue)),
                        Text('R\$ ${widget.chamado.custoMaoObra.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.inventory_2, color: Colors.orange, size: 20),
                        const SizedBox(height: 8),
                        const Text('Materiais', style: TextStyle(fontSize: 12, color: Colors.orange)),
                        Text('R\$ ${widget.chamado.custoMateriais.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.orange)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Custo Total:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                Text('R\$ ${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFF0000))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdateLaborCostDialog() {
    final viewModel = Provider.of<HomeViewModel>(context, listen: false);
    final ctrl = TextEditingController(text: widget.chamado.custoMaoObra > 0 ? widget.chamado.custoMaoObra.toString() : '');
    final form = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Editar Mão de Obra'),
        content: Form(
          key: form,
          child: TextFormField(
            controller: ctrl,
            decoration: const InputDecoration(labelText: 'Valor (R\$)', border: OutlineInputBorder()),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Obrigatório';
              if (double.tryParse(v) == null) return 'Valor inválido';
              return null;
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            onPressed: () async {
              if (form.currentState!.validate()) {
                final val = double.parse(ctrl.text);
                Navigator.pop(ctx);
                _showLoading();
                final success = await viewModel.updateLaborCost(widget.chamado.id, widget.chamado.status, val);
                if (mounted) {
                  Navigator.pop(context); // close loading
                  if (success) {
                    _showSnack('Custo atualizado!');
                    Navigator.pop(context); // close detail view to refresh
                  } else {
                    _showSnack('Erro ao atualizar custo', isError: true);
                  }
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF0000), foregroundColor: Colors.white),
            child: const Text('Salvar'),
          ),
        ],
      )
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
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.swap_horiz, size: 16),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text('${h.statusAnterior} → ${h.statusNovo}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                    Text(_formatDate(h.dataAlteracao), style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
                if (h.observacao != null && h.observacao!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.yellow.shade50, borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.yellow.shade200)),
                    child: Text('"${h.observacao}"', style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: Colors.black87)),
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(Icons.person, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text('Por: ${h.alteradoPor}', style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
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
    
    // Grouping logic for the dropdown (not required to physically group in a flat dropdown, but we add category to string)
    // We will track unit prices
    final Map<int, double> unitPrices = {
      for (var m in materiais) 
        m['id'] as int: (m['valor_unitario'] as num?)?.toDouble() ?? 0.0
    };

    int? selectedMaterialId;
    final qtyCtrl = TextEditingController(text: '1');
    final formKey = GlobalKey<FormState>();

    showDialog(context: context, builder: (ctx) => StatefulBuilder(builder: (context, setState) {
      final double unitPrice = selectedMaterialId != null ? unitPrices[selectedMaterialId] ?? 0.0 : 0.0;
      final int qty = int.tryParse(qtyCtrl.text) ?? 0;
      final double subtotal = unitPrice * qty;

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
                items: materiais.map((m) {
                  final preco = (m['valor_unitario'] as num?)?.toDouble() ?? 0.0;
                  return DropdownMenuItem<int>(
                    value: m['id'] as int,
                    child: Text('[${m['categoria'] ?? 'Outros'}] ${m['nome']} (Estoque: ${m['quantidade_atual']} | R\$ $preco)'),
                  );
                }).toList(),
                onChanged: (val) => setState(() => selectedMaterialId = val),
                validator: (val) => val == null ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: qtyCtrl,
                decoration: const InputDecoration(labelText: 'Quantidade', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                onChanged: (val) => setState(() {}),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Obrigatório';
                  if (int.tryParse(v) == null || int.parse(v) <= 0) return 'Inválido';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Subtotal:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                    Text('R\$ ${subtotal.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
                  ],
                ),
              )
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
                    _showSnack('Material adicionado!');
                    Navigator.pop(context); // Pop view to refresh
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