import 'dart:io';

import 'package:kuvaton_client_flutter/resources/resources.dart';
import 'package:test/test.dart';

void main() {
  test('images assets test', () {
    expect(true, File(Images.kuvatonComLogoUusi).existsSync());
  });
}
