import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/momento.dart';

class ArquivoService {
  static const String chaveMomentos = 'meus_momentos';

  Future<void> salvarMomentos(List<Momento> momentos) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lista = momentos.map((m) => m.toMap()).toList();
      final dados = jsonEncode(lista);
      await prefs.setString(chaveMomentos, dados);
    } catch (e) {
      debugPrint('ERRO AO SALVAR MOMENTOS: $e');
    }
  }

  Future<List<Momento>> carregarMomentos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dados = prefs.getString(chaveMomentos);

      if (dados == null || dados.isEmpty) {
        return [];
      }

      final lista = jsonDecode(dados);

      if (lista is! List) {
        return [];
      }

      return lista.map((item) {
        return Momento.fromMap(Map<String, dynamic>.from(item));
      }).toList();
    } catch (e) {
      debugPrint('ERRO AO CARREGAR MOMENTOS: $e');
      return [];
    }
  }
}