import 'package:auto_route/auto_route.dart';
import 'package:kuvaton_client_flutter/routes/home_route/home_route.dart';
import 'package:kuvaton_client_flutter/routes/image_route/image_route.dart';

/// Build:
/// `flutter packages pub run build_runner build --delete-conflicting-outputs`
///
/// Clean:
/// `flutter packages pub run build_runner clean`

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: HomeRoute, initial: true),
    AutoRoute(page: ImageRoute),
  ],
)
class $AppRouter {}
