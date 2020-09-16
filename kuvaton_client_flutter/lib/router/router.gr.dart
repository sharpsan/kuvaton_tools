// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../routes/home_route/home_route.dart';
import '../routes/image_route/image_route.dart';

class Routes {
  static const String homeRoute = '/';
  static const String imageRoute = '/image-route';
  static const all = <String>{
    homeRoute,
    imageRoute,
  };
}

class Router extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.homeRoute, page: HomeRoute),
    RouteDef(Routes.imageRoute, page: ImageRoute),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    HomeRoute: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => HomeRoute(),
        settings: data,
      );
    },
    ImageRoute: (data) {
      final args = data.getArgs<ImageRouteArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => ImageRoute(
          imageUrl: args.imageUrl,
          imageFilename: args.imageFilename,
        ),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Navigation helper methods extension
/// *************************************************************************

extension RouterExtendedNavigatorStateX on ExtendedNavigatorState {
  Future<dynamic> pushHomeRoute() => push<dynamic>(Routes.homeRoute);

  Future<dynamic> pushImageRoute({
    @required String imageUrl,
    @required String imageFilename,
  }) =>
      push<dynamic>(
        Routes.imageRoute,
        arguments: ImageRouteArguments(
            imageUrl: imageUrl, imageFilename: imageFilename),
      );
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// ImageRoute arguments holder class
class ImageRouteArguments {
  final String imageUrl;
  final String imageFilename;
  ImageRouteArguments({@required this.imageUrl, @required this.imageFilename});
}
