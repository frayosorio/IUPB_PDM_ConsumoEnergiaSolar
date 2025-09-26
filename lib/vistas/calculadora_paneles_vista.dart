import 'package:consumo_energia_solar/modelos/ciudad.dart';
import 'package:consumo_energia_solar/servicios/ciudad_servicio.dart';
import 'package:flutter/material.dart';

class CalculadoraPaneles extends StatefulWidget {
  const CalculadoraPaneles({super.key});

  @override
  State<CalculadoraPaneles> createState() => _CalculadoraPanelesState();
}

class _CalculadoraPanelesState extends State<CalculadoraPaneles> {
  DateTime _desde = DateTime.now();
  DateTime _hasta = DateTime.now();
  final _txtConsumo = TextEditingController();
  String _resultado = "";
  final CiudadServicio _ciudadesServicio = CiudadServicio();
  List<Ciudad> _ciudades = [];

  void _calcularPaneles() {
    _resultado = "";
  }

  Future<void> _cargarCiudades() async {
    try {
      final ciudades = await _ciudadesServicio.cargarCiudades();
      _ciudades = ciudades;
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    _cargarCiudades();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculadora de Paneles Solares')),
      body: SingleChildScrollView(
        child: Form(
          child: Column(
            children: [
              DropdownButtonFormField<Ciudad>(
                items: _ciudades.map((ciudad) {
                  return DropdownMenuItem<Ciudad>(
                    value: ciudad,
                    child: Text(ciudad.nombre),
                  );
                }).toList(),
                onChanged: (valor) {},
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: "Desde"),
                      readOnly: true,
                      onTap: () async {
                        final valorSeleccionado = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                          initialDate: _desde,
                        );
                        if (valorSeleccionado != null) {
                          setState(() {
                            _desde = valorSeleccionado;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: "Hasta"),
                      readOnly: true,
                      onTap: () async {
                        final valorSeleccionado = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                          initialDate: _hasta,
                        );
                        if (valorSeleccionado != null) {
                          setState(() {
                            _hasta = valorSeleccionado;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _txtConsumo,
                decoration: const InputDecoration(
                  labelText: "Consumo de energía (kWh/mes)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (valor) {
                  if (valor == null || valor.isEmpty) {
                    return "Ingrese el consumo";
                  }
                  if (double.tryParse(valor) == null) {
                    return "Ingrese un número válido";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _calcularPaneles,
                child: const Text("Calcular Paneles"),
              ),
              const SizedBox(height: 16),
              Text(_resultado, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
