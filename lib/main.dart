import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'build_text_field.dart';
import 'controller.dart';

const request = "https://api.hgbrasil.com/finance?key=13fe3c46";

void main() async {
  runApp(MaterialApp(
    home: const Home(),
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white,
      inputDecorationTheme: const InputDecorationTheme(
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          helperStyle: TextStyle(color: Colors.amber),
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white))),
    ),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(Uri.parse(request));
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Controller controller = Controller();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('\$Conversor\$'),
        backgroundColor: Colors.amber,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  controller.clearAll();
                });
              },
              icon: Icon(
                Icons.refresh,
              ))
        ],
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Center(
                  child: Text(
                    'Carregando Dados...',
                    style: TextStyle(color: Colors.amber, fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                );
              default:
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Erro ao carregar Dados :(',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 25,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  controller.dolar =
                      snapshot.data?['results']['currencies']['USD']['buy'];
                  controller.euro =
                      snapshot.data?['results']['currencies']['EUR']['buy'];

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(
                          Icons.monetization_on,
                          size: 150,
                          color: Colors.amber,
                        ),
                        BuildTextField(
                          label: 'Reais',
                          prefix: 'R\$',
                          textEC: controller.realController,
                          function: controller.realChanged,
                        ),
                        Divider(),
                        BuildTextField(
                          label: 'Dólares',
                          prefix: '\$',
                          textEC: controller.dolarController,
                          function: controller.dolarChanged,
                        ),
                        Divider(),
                        BuildTextField(
                          label: 'Euros',
                          prefix: 'Є',
                          textEC: controller.euroController,
                          function: controller.euroChanged,
                        ),
                      ],
                    ),
                  );
                }
            }
          }),
    );
  }
}
