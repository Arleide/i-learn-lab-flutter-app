import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:i_learn_lab_app_flutter/core/util/api_path.dart';
import 'package:i_learn_lab_app_flutter/modules/categories/categoria.dart';

import 'package:http/http.dart' as http;

class CategoriaService {

  final String _baseUrl = '${ApiPath.BASE_URL}categorias';

  Future<List<Categoria>> listarTodas() async {

    try{
      final resultado = await http.get(Uri.parse(_baseUrl))
          .timeout(const Duration(seconds: 30));

      print(resultado.body);

      if(resultado.statusCode == HttpStatus.ok ) {
        final List<dynamic> jsonList = jsonDecode(resultado.body);
        return jsonList.map((item) => Categoria.fromJson(item)).toList();
      }else {
        throw Exception('Erro ao listar categorias');
      }

    } on SocketException {
      throw Exception('Erro e conexão');
    } on TimeoutException {
      throw Exception('Tempo esgotado');
    } catch (ex) {
        throw Exception('Erro insperado');
    }

  }

}
