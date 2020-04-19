// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:kuvaton_client_flutter/routes/home_route/home_route.dart';
import 'package:kuvaton_client_flutter/routes/image_route/image_route.dart';

abstract class Routes {
  static const homeRoute = '/';
  static const imageRoute = '/image-route';
}

class Router extends RouterBase {
  //This will probably be removed in future versions
  //you should call ExtendedNavigator.ofRouter<Router>() directly
  static ExtendedNavigatorState get navigator =>
      ExtendedNavigator.ofRouter<Router>();

  @override
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.homeRoute:
        return MaterialPageRoute<dynamic>(
          builder: (_) => HomeRoute(),
          settings: settings,
        );
      case Routes.imageRoute:
        if (hasInvalidArgs<ImageRouteArguments>(args, isRequired: true)) {
          return misTypedArgsRoute<ImageRouteArguments>(args);
        }
        final typedArgs = args as ImageRouteArguments;
        return MaterialPageRoute<dynamic>(
          builder: (_) => ImageRoute(
              imageUrl: typedArgs.imageUrl,
              imageFilename: typedArgs.imageFilename),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}

//**************************************************************************
// Arguments holder classes
//***************************************************************************

//ImageRoute arguments holder class
class ImageRouteArguments {
  final String imageUrl;
  final String imageFilename;
  ImageRouteArguments({@required this.imageUrl, @required this.imageFilename});
}

//**************************************************************************
// Navigation helper methods extension
//***************************************************************************

extension RouterNavigationHelperMethods on ExtendedNavigatorState {
  Future pushHomeRoute() => pushNamed(Routes.homeRoute);
  Future pushImageRoute({
    @required String imageUrl,
    @required String imageFilename,
  }) =>
      pushNamed(Routes.imageRoute,
          arguments: ImageRouteArguments(
              imageUrl: imageUrl, imageFilename: imageFilename));
}
