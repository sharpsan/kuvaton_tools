import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:kuvaton_client_flutter/router/router.gr.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kuvaton Client',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //builder: ExtendedNavigator<Router>(router: Router()),
      builder: ExtendedNavigator.builder(
        router: Router(),
        initialRoute: '/',
        builder: (context, extendedNav) => extendedNav,
      ),
    );
  }
}
