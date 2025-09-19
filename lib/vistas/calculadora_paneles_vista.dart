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

  _calcularPaneles() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculadora de Paneles Solares')),
      body: SingleChildScrollView(
        child: Form(
          child: Column(
            children: [
              DropdownButtonFormField(items: null, onChanged: null),
              const SizedBox(height: 16),
              Row(
                children: [
                  TextFormField(
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
                  const SizedBox(height: 16),
                  TextFormField(
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
              Text(
                _resultado,
                textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
