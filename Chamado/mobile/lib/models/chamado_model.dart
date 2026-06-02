import 'package:flutter/material.dart';
class Chamado {
  final int id;
  final String tipo;
  final String local;
  final String assunto;
  final String descricao;
  final String prioridade;
  final String tipoServico;
  final String status;
  final String? imagemUrl;
  final String? observacao;
  final int usuarioId;
  final String createdAt;
  final double custoTotal;
  final double custoMaoObra;
  final double custoMateriais;
  final String? tecnicoNome;
  final int? tecnicoId;
  final List<Historico> historicos;

  Chamado({ 
    required this.id,
    required this.tipo,
    required this.local,
    required this.assunto,
    required this.descricao,
    required this.prioridade,
    required this.tipoServico,
    required this.status,
    this.imagemUrl,
    this.observacao,
    required this.usuarioId,
    required this.createdAt,
    this.custoTotal = 0.0,
    this.custoMaoObra = 0.0,
    this.custoMateriais = 0.0,
    this.tecnicoNome,
    this.tecnicoId,
    this.historicos = const [],
  });

  factory Chamado.fromJson(Map<String, dynamic> json) {
    final historicosJson = json['historicos'] as List? ?? [];
    return Chamado(
      id: json['id'],
      tipo: json['tipo'] ?? '',
      local: json['local'] ?? '',
      assunto: json['assunto'] ?? '',
      descricao: json['descricao'] ?? '',
      prioridade: json['prioridade'] ?? '',
      tipoServico: json['tipo_servico'] ?? '',
      status: json['status'] ?? '',
      imagemUrl: json['imagem_url'],
      observacao: json['observacao']?.toString(),
      usuarioId: json['usuario_id'] ?? json['user_id'] ?? 0,
      createdAt: json['created_at'] ?? '',
      custoTotal: double.tryParse(json['custo_total']?.toString() ?? '0') ?? 0.0,
      custoMaoObra: double.tryParse(json['custo_mao_obra']?.toString() ?? '0') ?? 0.0,
      custoMateriais: double.tryParse(json['custo_materiais']?.toString() ?? '0') ?? 0.0,
      tecnicoNome: json['tecnico']?['name'],
      tecnicoId: json['tecnico_id'] ?? json['tecnico']?['id'],
      historicos: historicosJson.map((h) => Historico.fromJson(h as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipo': tipo,
      'local': local,
      'assunto': assunto,
      'descricao': descricao,
      'prioridade': prioridade,
      'tipo_servico': tipoServico,
      'status': status,
      'imagem_url': imagemUrl,
      'observacao': observacao,
      'usuario_id': usuarioId,
      'created_at': createdAt,
    };
  }

  String get statusEmoji {
    switch (status) {
      case 'Aberto':
        return '🟢';
      case 'Em Análise':
        return '🟡';
      case 'Em Execução':
        return '🟠';
      case 'Concluído':
        return '✅';
      default:
        return '⚪';
    }
  }

  Color get statusColor {
    switch (status) {
      case 'Aberto':
        return Colors.green;
      case 'Em Análise':
        return Colors.amber;
      case 'Em Execução':
        return Colors.orange;
      case 'Concluído':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String get prioridadeEmoji {
    switch (prioridade) {
      case 'Alta':
        return '🔴';
      case 'Média':
        return '🟡';
      case 'Baixa':
        return '🟢';
      default:
        return '⚪';
    }
  }

  static List<String> tipos = ['Elétrica', 'Hidráulica', 'Infraestrutura', 'Outros'];
  static List<String> prioridades = ['Baixa', 'Média', 'Alta'];
  static List<String> tipoServicos = ['Interno', 'Externo'];
  static List<String> statusList = ['Aberto', 'Em Análise', 'Em Execução', 'Concluído'];
}

class Historico {
  final String statusAnterior;
  final String statusNovo;
  final String dataAlteracao;

  Historico({
    required this.statusAnterior,
    required this.statusNovo,
    required this.dataAlteracao,
  });

  factory Historico.fromJson(Map<String, dynamic> json) {
    return Historico(
      statusAnterior: json['status_anterior'] ?? '',
      statusNovo: json['status_novo'] ?? '',
      dataAlteracao: json['data_alteracao'] ?? '',
    );
  }
}