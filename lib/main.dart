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
  double? dolar;
  double? euro;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('\$ Conversor de Moedas'),
        centerTitle: true,
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
                    children: const [
                      Icon(
                        Icons.monetization_on,
                        size: 150,
                        color: Colors.orange,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Real',
                          labelStyle: TextStyle(
                            color: Colors.orange,
                          ),
                          border: OutlineInputBorder(),
                          prefixText: 'R\$',
                        ),
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 25,
                        ),
                      ),
                      Divider(),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Dólar',
                          labelStyle: TextStyle(
                            color: Colors.orange,
                          ),
                          border: OutlineInputBorder(),
                          prefixText: '\$',
                        ),
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 25,
                        ),
                      ),
                      Divider(),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Euro',
                          labelStyle: TextStyle(
                            color: Colors.orange,
                          ),
                          border: OutlineInputBorder(),
                          prefixText: '€',
                        ),
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}
