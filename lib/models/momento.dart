import 'dart:convert';

class Momento {
  final String id;
  final String caminhoFoto;
  final String anotacao;
  final String dataHora;

  Momento({
    required this.id,
    required this.caminhoFoto,
    required this.anotacao,
    required this.dataHora,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'caminhoFoto': caminhoFoto,
      'anotacao': anotacao,
      'dataHora': dataHora,
    };
  }

  factory Momento.fromMap(Map<String, dynamic> map) {
    return Momento(
      id: map['id']?.toString() ?? '',
      caminhoFoto: map['caminhoFoto']?.toString() ?? '',
      anotacao: map['anotacao']?.toString() ?? '',
      dataHora: map['dataHora']?.toString() ?? '',
    );
  }

  String toJson() => jsonEncode(toMap());

  factory Momento.fromJson(String source) =>
      Momento.fromMap(jsonDecode(source));
}