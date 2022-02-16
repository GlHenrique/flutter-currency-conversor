import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// theme: ThemeData(
//       hintColor: Colors.amber,
//       primaryColor: Colors.white,
//       inputDecorationTheme: InputDecorationTheme(
//         enabledBorder:
//             OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
//         focusedBorder:
//             OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
//         hintStyle: TextStyle(color: Colors.amber),
//       )),

const hgBrasilKey = 'https://api.hgbrasil.com/finance?key=f5ddbcd6';

Future<Map> getCurrencies() async {
  http.Response response = await http.get(Uri.parse(hgBrasilKey));
  return json.decode(response.body);
}

void main() async {
  runApp(MaterialApp(
    home: const Home(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.orange)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          hintStyle: TextStyle(color: Colors.amber),
        )),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController realController = TextEditingController();
  TextEditingController dolarController = TextEditingController();
  TextEditingController euroController = TextEditingController();

  late double dolar;
  late double euro;

  void _handleRealChange(String value) {
    if (value.isEmpty || value.startsWith(',')) {
      resetForm();
      return;
    }
    double real = double.parse(value.replaceFirst(',', '.'));
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _handleDolarChange(String value) {
    if (value.isEmpty || value.startsWith(',')) {
      resetForm();
      return;
    }
    double dolar = double.parse(value.replaceFirst(',', '.'));
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _handleEuroChange(String value) {
    if (value.isEmpty || value.startsWith(',')) {
      resetForm();
      return;
    }
    double euro = double.parse(value.replaceFirst(',', '.'));
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  void resetForm() {
    realController.clear();
    dolarController.clear();
    euroController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: const Text('\$ Conversor de Moedas'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: resetForm,
            ),
          ],
        ),
        body: FutureBuilder<Map>(
          future: getCurrencies(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Center(
                  child: Text(
                    'Carregando...',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.orange,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              default:
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Erro ao carregar os dados',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  dolar = snapshot.data?['results']['currencies']['USD']['buy'];
                  euro = snapshot.data?['results']['currencies']['EUR']['buy'];
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Icon(
                          Icons.monetization_on,
                          size: 150,
                          color: Colors.orange,
                        ),
                        customTextField(
                            'Real', 'R\$', realController, _handleRealChange),
                        const Divider(),
                        customTextField(
                            'Dólar', '\$', dolarController, _handleDolarChange),
                        const Divider(),
                        customTextField(
                            'Euro', '€', euroController, _handleEuroChange),
                      ],
                    ),
                  );
                }
            }
          },
        ),
      ),
    );
  }
}

Widget customTextField(
  String label,
  String prefix,
  TextEditingController controller,
  Function onChange,
) {
  return TextField(
    controller: controller,
    onChanged: (value) {
      onChange(value);
    },
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Colors.orange,
      ),
      border: const OutlineInputBorder(),
      prefixText: prefix,
    ),
    style: const TextStyle(
      color: Colors.orange,
      fontSize: 25,
    ),
  );
}
