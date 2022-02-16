import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const hgBrasilKey = 'https://api.hgbrasil.com/finance?key=f5ddbcd6';

void main() async {
  http.Response response = await http.get(Uri.parse(hgBrasilKey));
  json.decode(response.body);

  runApp(const MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
