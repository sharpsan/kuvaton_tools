import 'package:auto_route/auto_route_annotations.dart';
import 'package:kuvaton_client_flutter/routes/home_route/home_route.dart';
import 'package:kuvaton_client_flutter/routes/image_route/image_route.dart';

@MaterialAutoRouter(generateNavigationHelperExtension: true)
class $Router {
  @initial
  HomeRoute homeRoute;
  ImageRoute imageRoute;
}
