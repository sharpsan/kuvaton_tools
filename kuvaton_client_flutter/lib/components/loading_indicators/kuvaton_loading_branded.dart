import 'package:flutter/material.dart';
import 'package:kuvaton_client_flutter/resources/resources.dart';

class KuvatonLoadingBranded extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CircularProgressIndicator(),
        SizedBox(width: 22),
        Image.asset(Images.kuvatonComLogoUusi),
      ],
    );
  }
}
