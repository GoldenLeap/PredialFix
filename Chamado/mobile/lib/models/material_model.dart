class MaterialItem {
  final int id;
  final String nome;
  final String categoria;
  final String localizacao;
  final int quantidadeAtual;
  final int quantidadeMinima;
  final String unidade;
  final String? statusEstoque;

  MaterialItem({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.localizacao,
    required this.quantidadeAtual,
    required this.quantidadeMinima,
    required this.unidade,
    this.statusEstoque,
  });

  factory MaterialItem.fromJson(Map<String, dynamic> json) {
    return MaterialItem(
      id: json['id'],
      nome: json['nome'] ?? '',
      categoria: json['categoria'] ?? '',
      localizacao: json['localizacao'] ?? '',
      quantidadeAtual: (json['quantidade_atual'] as num?)?.toInt() ?? 0,
      quantidadeMinima: (json['quantidade_minima'] as num?)?.toInt() ?? 0,
      unidade: json['unidade'] ?? 'un',
      statusEstoque: json['status_estoque'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'categoria': categoria,
      'localizacao': localizacao,
      'quantidade_atual': quantidadeAtual,
      'quantidade_minima': quantidadeMinima,
      'unidade': unidade,
    };
  }
}
