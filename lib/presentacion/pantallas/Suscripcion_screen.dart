import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notea_frontend/infraestructura/api/remoteDataUsuario.dart';
import 'package:http/http.dart' as http;
import '../../infraestructura/Repositorio/repositorioUsuarioImpl.dart';
import 'Succes_Screen.dart';

class Suscripcion extends StatefulWidget {
  final String idUsuario;
  const Suscripcion({super.key, required this.idUsuario});

  @override
  _SuscripcionState createState() => _SuscripcionState();
}

class _SuscripcionState extends State<Suscripcion> {
  int value = 0;

  final TipoSuscripciones = ['1 mes', '6 meses', '12 meses'];
  final PrecioSuscripciones = ['7 Usd', '36 Usd', ' 50 Usd'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          InfoSuscripciones(),
          SizedBox(
            height: 20,
          ),
          Text(
            'Elige uno de nuestros planes de pago:',
            style: TextStyle(
              color: Colors.black87.withOpacity(0.5),
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.separated(
              itemCount: TipoSuscripciones.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Radio(
                    activeColor: Colors.green,
                    value: index,
                    groupValue: value,
                    onChanged: (i) => setState(() => value = i!),
                  ),
                  title: Text(
                    "${TipoSuscripciones[index]} / ${PrecioSuscripciones[index]}",
                    style: const TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.bold),
                  ),
                  trailing: const Icon(Icons.payment),
                );
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 20, 100, 165)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(
                                  color: Color.fromARGB(255, 20, 100, 165))))),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return DatosPago(
                            idSuscriptor: widget.idUsuario,
                          );
                        });
                  },
                  child: const Text("Suscribirse")),
              SizedBox(
                width: 5,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 20, 100, 165)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(
                                  color: Color.fromARGB(255, 20, 100, 165))))),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Regresar'))
            ],
          ),
        ],
      ),
    );
  }
}

class InfoSuscripciones extends StatelessWidget {
  const InfoSuscripciones({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        Container(
            decoration: BoxDecoration(
                color: Colors.blue,
                border: Border.all(
                    width: 6, color: Color.fromARGB(255, 27, 124, 203)),
                borderRadius: BorderRadius.circular(20)),
            child: Column(children: const [
              Text(
                'SUSCRIPCION FREEMIUM',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "Todas las notas en la palma de tu mano!\n Mejora a IA y obten nuevas funcionalidades!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "(SUSCRIPCION ACTUAL)",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ])),
        SizedBox(
          height: 10,
        ),
        Container(
            decoration: BoxDecoration(
                color: Colors.amberAccent,
                border: Border.all(
                    width: 6, color: Color.fromARGB(255, 212, 178, 53)),
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: const [
                Text(
                  'SUSCRIPCIÓN IA',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "Lleva tus notas al siguiente nivel!\n Con la suscripcion IA podras extraer texto de tus imagenes y usar tu voz para escribir tus notas.\n No esperes mas y mejora tu suscripcion!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
              ],
            )),
      ],
    );
  }
}

//WIDGETS CREADOS PARA ESTA VENTANA
//Meter esto en una archivo a parte de widgets
class DatosPago extends StatefulWidget {
  final String idSuscriptor;

  const DatosPago({super.key, required this.idSuscriptor});
  @override
  State<DatosPago> createState() => _DatosPagoState();
}

class _DatosPagoState extends State<DatosPago> {
  final TextEditingController _NumeroTarjeta = new TextEditingController();
  final TextEditingController _NombreTarjeta = new TextEditingController();
  final TextEditingController _CVV = new TextEditingController();
  final TextEditingController _Fecha = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      color: Colors.white,
      child: Form(
        child: Column(
          children: [
            TextFormField(
              controller: _NombreTarjeta,
              decoration: const InputDecoration(
                  labelText: 'Nombre de beneficiario',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(8)),
              maxLines: 1,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.deny(RegExp('[0-9]')),
                LengthLimitingTextInputFormatter(20)
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: _NumeroTarjeta,
              decoration: const InputDecoration(
                  labelText: "Ingrese numero de tarjeta",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(8)),
              maxLines: 1,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              maxLength: 20,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: TextFormField(
                    controller: _CVV,
                    decoration: const InputDecoration(
                        labelText: "CVV",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(8)),
                    maxLines: 1,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    maxLength: 3,
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: TextFormField(
                    controller: _Fecha,
                    decoration: const InputDecoration(
                        labelText: "F.Vencimiento",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(8),
                        hintText: 'DD/MM/YYYY'),
                    maxLines: 1,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[0-9/]")),
                    ],
                    maxLength: 10,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 20, 100, 165)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(
                                        color: Color.fromARGB(
                                            255, 20, 100, 165))))),
                    onPressed: () async {
                      String IdUser = widget.idSuscriptor;
                      print(IdUser);

                      final repositorio = RepositorioUsuarioImpl(
                          remoteDataSource:
                              RemoteDataUsuarioImp(client: http.Client()));
                      final usuario =
                          await repositorio.suscriptionusuario(IdUser);
                      //BUSCAR AQUI

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const sucess(),
                        ),
                      );
                    },
                    child: const Text('Confirmar')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _NombreTarjeta.dispose();
    _NumeroTarjeta.dispose();
    super.dispose();
  }
}

//Meter esto en una archivo a parte de widgets
class HeaderLabel extends StatelessWidget {
  final String headerText;
  const HeaderLabel({
    super.key,
    required this.headerText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        headerText,
        style: const TextStyle(
          color: Color.fromARGB(255, 46, 46, 45),
          fontSize: 20,
        ),
      ),
    );
  }
}
