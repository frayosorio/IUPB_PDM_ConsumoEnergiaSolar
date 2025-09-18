import 'package:flutter/material.dart';

class CalculadoraPaneles extends StatefulWidget{
    const CalculadoraPaneles({super.key});

  @override
  State<CalculadoraPaneles> createState() => _CalculadoraPanelesState();
}

class _CalculadoraPanelesState extends State<CalculadoraPaneles> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculadora de Paneles Solares')),
      body: SingleChildScrollView(
         child: Form(
          child: Column(
            children:[
              DropdownButtonFormField(items: null, 
              onChanged: null
              ),
              const SizedBox(height:16),
              Row(
                children:[
                  TextFormField(
                    decoration: ,
                  ),
                  const SizedBox(height:16),
                  TextFormField(),
                ]
              ),
            ]
          )
         )
      )
    );
  }

}