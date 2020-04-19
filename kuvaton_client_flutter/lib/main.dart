import 'package:flutter/material.dart';
import 'package:kuvaton_client_flutter/services/api/api.dart';
import 'package:kuvaton_client_flutter/services/api/api_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final ApiService apiService = ApiService();
  @override
  Widget build(BuildContext context) {
    apiService.getPage(endpoint: Endpoint.lolPageFirst).then((result) =>
        result.entries.forEach((entry) =>
            print('filename: ${entry.imageFilename}, url: ${entry.imageUrl}')));
    return Container();
  }
}
