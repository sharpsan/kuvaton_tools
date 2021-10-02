enum Endpoint {
  lolCategory,
  topCategory,
  randomCategory,
}

/// Categories are structured as {root}/{pageNumber}/{category}
class API {
  static final String host = 'kuvaton.com';
  static final int port = 443;

  Uri endpointUri(Endpoint endpoint, {dynamic prefixPath}) => Uri(
        scheme: 'https',
        host: host,
        port: port,
        path: _buildPath([
          prefixPath,
          _paths[endpoint],
        ]),
      );

  Uri lolCategory({int pageNumber = 1}) =>
      endpointUri(Endpoint.lolCategory, prefixPath: pageNumber);
  Uri topCategory({int pageNumber = 1}) =>
      endpointUri(Endpoint.topCategory, prefixPath: pageNumber);
  Uri randomCategory({int pageNumber = 1}) =>
      endpointUri(Endpoint.randomCategory, prefixPath: pageNumber);

  static Map<Endpoint, String> _paths = {
    Endpoint.lolCategory: 'lol',
    Endpoint.topCategory: 'top',
    Endpoint.randomCategory: 'rand',
  };

  // build a path with parts separated by '/'
  String _buildPath(List<dynamic> pathSegments) {
    String path = '';
    for (int i = 0; i < pathSegments.length; i++) {
      var segment = pathSegments[i];
      if (segment != null && segment != '') {
        path += '$segment';
      }
      if (i != pathSegments.length - 1 && path != '') {
        path += '/';
      }
    }
    return path;
  }
}
