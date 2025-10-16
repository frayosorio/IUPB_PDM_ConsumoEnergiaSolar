import 'package:consumo_energia_solar/modelos/ciudad.dart';
import 'package:consumo_energia_solar/servicios/ciudad_servicio.dart';
import 'package:consumo_energia_solar/servicios/nasa_api_servicio.dart';
import 'package:flutter/material.dart';

class CalculadoraPaneles extends StatefulWidget {
  const CalculadoraPaneles({super.key});

  @override
  State<CalculadoraPaneles> createState() => _CalculadoraPanelesState();
}

class _CalculadoraPanelesState extends State<CalculadoraPaneles> {
  final _formKey = GlobalKey<FormState>();
  Ciudad? _ciudadSeleccionada;
  final NasaApiServicio _nasaApiServicio = NasaApiServicio();

  DateTime _desde = DateTime.now();
  DateTime _hasta = DateTime.now();
  final _txtConsumo = TextEditingController();

  String _resultado = "";
  final CiudadServicio _ciudadesServicio = CiudadServicio();
  List<Ciudad> _ciudades = [];

  // Variable de estado para controlar la carga
  bool _cargando = true;

  Future<void> _calcularPaneles() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _resultado = 'Calculando...';
      });
      final consumoKw = double.tryParse(_txtConsumo.text);
      if (_ciudadSeleccionada != null && consumoKw != null) {
        final radiacionPromedio = await _nasaApiServicio.getRadiacionSolar(
          _ciudadSeleccionada!.latitud,
          _ciudadSeleccionada!.longitud,
          _desde,
          _hasta,
        );

        if (radiacionPromedio > 0) {
          //calculo de los paneles
          const eficienciaPanel = 0.2;
          const areaPanel = 1.7;

          final energiaGeneradaPanelDiaria =
              (radiacionPromedio * eficienciaPanel * areaPanel) / 1000;
          final panelesNecesarios = consumoKw / 30 / energiaGeneradaPanelDiaria;

          setState(() {
            _resultado =
                'Se necesitam ${panelesNecesarios.ceil()} paneles solares';
          });
        } else {
          setState(() {
            _resultado =
                "No se pudo obtener la radación. Pruebe intentar en otras fechas";
          });
        }
      }
    }
  }

  Future<void> _cargarCiudades() async {
    try {
      final ciudades = await _ciudadesServicio.cargarCiudades();
      setState(() {
        _ciudades = ciudades;
        _cargando = false;
      });
    } catch (e) {
      setState(() {
        _cargando = false;
        _resultado = 'Error al cargar los datos. Revisa el archivo JSON.';
      });
    }
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
          key: _formKey,
          child: Column(
            children: [
              if (_cargando)
                const Center(child: CircularProgressIndicator())
              else
                DropdownButtonFormField<Ciudad>(
                  items: _ciudades.map((ciudad) {
                    return DropdownMenuItem<Ciudad>(
                      value: ciudad,
                      child: Text(ciudad.nombre),
                    );
                  }).toList(),
                  onChanged: (Ciudad? ciudad) {
                    setState(() {
                      _ciudadSeleccionada = ciudad;
                    });
                  },
                  validator: (ciudad) =>
                      ciudad == null ? "Debe seleccionar la ciudad" : null,
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: "Desde"),
                      readOnly: true,
                      controller: TextEditingController(
                        text: _desde.toString().substring(0, 10),
                      ),
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
                      controller: TextEditingController(
                        text: _hasta.toString().substring(0, 10),
                      ),
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
