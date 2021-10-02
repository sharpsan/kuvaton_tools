// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i3;
import 'package:flutter/material.dart' as _i4;

import '../routes/home_route/home_route.dart' as _i1;
import '../routes/image_route/image_route.dart' as _i2;

class AppRouter extends _i3.RootStackRouter {
  AppRouter([_i4.GlobalKey<_i4.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i3.PageFactory> pagesMap = {
    HomeRoute.name: (routeData) {
      return _i3.MaterialPageX<dynamic>(
          routeData: routeData, child: _i1.HomeRoute());
    },
    ImageRoute.name: (routeData) {
      final args = routeData.argsAs<ImageRouteArgs>();
      return _i3.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i2.ImageRoute(
              imageUrl: args.imageUrl, imageFilename: args.imageFilename));
    }
  };

  @override
  List<_i3.RouteConfig> get routes => [
        _i3.RouteConfig(HomeRoute.name, path: '/'),
        _i3.RouteConfig(ImageRoute.name, path: '/image-route')
      ];
}

/// generated route for [_i1.HomeRoute]
class HomeRoute extends _i3.PageRouteInfo<void> {
  const HomeRoute() : super(name, path: '/');

  static const String name = 'HomeRoute';
}

/// generated route for [_i2.ImageRoute]
class ImageRoute extends _i3.PageRouteInfo<ImageRouteArgs> {
  ImageRoute({required String? imageUrl, required String? imageFilename})
      : super(name,
            path: '/image-route',
            args: ImageRouteArgs(
                imageUrl: imageUrl, imageFilename: imageFilename));

  static const String name = 'ImageRoute';
}

class ImageRouteArgs {
  const ImageRouteArgs({required this.imageUrl, required this.imageFilename});

  final String? imageUrl;

  final String? imageFilename;
}
