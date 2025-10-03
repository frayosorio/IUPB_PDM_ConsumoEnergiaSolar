import "dart:convert";

import "package:http/http.dart" as http;

class NasaApiServicio {
  static const urlBase = "https://power.larc.nasa.gov/api/temporal/daily/point";

  Future<double> getRadiacionSolar(
    double latitud,
    double longitud,
    DateTime desde,
    DateTime hasta,
  ) async {
    final textoDesde =
        "${desde.year}${desde.month.toString().padLeft(2, "0")}${desde.day.toString().padLeft(2, "0")}";
    final textoHasta =
        "${hasta.year}${hasta.month.toString().padLeft(2, "0")}${hasta.day.toString().padLeft(2, "0")}";

    final url = Uri.parse(
      "$urlBase?parameters=ALLSKY_SFC_SW_DWN&start=$textoDesde&end=$textoHasta&latitude=$latitud&longitude=$longitud&format=JSON&community=RE",
    );

    final respuesta = await http.get(url);
    if (respuesta.statusCode == 200) {
      final datos = jsonDecode(respuesta.body);
      final valores = datos["properties"]["parameter"]["ALLSKY_SFC_SW_DWN"];
      if (valores != null && valores.isNotEmpty) {
        final radiacionTotal = valores.values.reduce(
          (suma, valor) => {suma + (valor ?? 0)},
        );
        final promedioRadiacion = radiacionTotal / valores.length;
        return promedioRadiacion;
      }
    }
    return 0.0;
  }
}
