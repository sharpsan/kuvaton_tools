import 'package:flutter/foundation.dart';

enum Endpoint {
  page,
  lolPageFirst,
  topPageFirst,
  randomPageFirst,
}

class API {
  static final String host = 'kuvaton.com';
  static final int port = 443;

  Uri endpointUri(Endpoint endpoint, {String path}) => Uri(
        scheme: 'https',
        host: host,
        port: port,
        path: _buildPath([
          _paths[endpoint],
          path,
        ]),
      );

  Uri pageUri(int pageNumber) =>
      endpointUri(Endpoint.page, path: pageNumber.toString());
  Uri lolPageFirst() => endpointUri(Endpoint.lolPageFirst);
  Uri topPageFirst() => endpointUri(Endpoint.topPageFirst);
  Uri randomPageFirst() => endpointUri(Endpoint.randomPageFirst);

  static Map<Endpoint, String> _paths = {
    Endpoint.page: '',
    Endpoint.lolPageFirst: '1/lol',
    Endpoint.topPageFirst: '1/top',
    Endpoint.randomPageFirst: '1/rand',
  };

  // build a path with parts separated by '/'
  String _buildPath(List<dynamic> pathSegments) {
    String path = '';
    for (int i = 0; i < pathSegments.length; i++) {
      var segment = pathSegments[i];
      if (segment != null && segment != '') {
        path += segment;
      }
      if (i != pathSegments.length - 1 && path != '') {
        path += '/';
      }
    }
    return path;
  }
}
