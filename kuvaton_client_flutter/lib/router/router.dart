import 'package:auto_route/auto_route_annotations.dart';
import 'package:kuvaton_client_flutter/routes/home_route/home_route.dart';
import 'package:kuvaton_client_flutter/routes/image_route/image_route.dart';

/// Build:
/// `flutter packages pub run build_runner build --delete-conflicting-outputs`
///
/// Clean:
/// `flutter packages pub run build_runner clean`

@MaterialAutoRouter(
  generateNavigationHelperExtension: true,
  routes: <AutoRoute>[
    MaterialRoute(page: HomeRoute, initial: true),
    MaterialRoute(page: ImageRoute),
  ],
)
class $Router {}
