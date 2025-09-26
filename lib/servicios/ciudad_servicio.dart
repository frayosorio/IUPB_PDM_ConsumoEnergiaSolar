import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:consumo_energia_solar/modelos/ciudad.dart';

class CiudadServicio {
  Future<List<Ciudad>> cargarCiudades() async {
    try {
      final String contenidoArchivo = await rootBundle.loadString('assets/datos/capitales_colombia.json');
      final datosJson = jsonDecode(contenidoArchivo) as List;

      return datosJson
        .map((objetoJson) => Ciudad.fromJson(objetoJson) )
        .toList();
    } catch (e) {
      print('Error al cargar las ciudades: $e');
      throw Exception('No se pudieron cargar las ciudades');
    }
  }
}
