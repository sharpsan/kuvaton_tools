import 'package:flutter/foundation.dart';
import 'package:http_interceptor/http_client_with_interceptor.dart';
import 'package:kuvaton_client_flutter/interceptors/logger_interceptor.dart';
import 'package:kuvaton_client_flutter/services/api/api.dart';
import 'package:kuvaton_client_flutter/services/api/entries_response.dart';
import 'package:kuvaton_client_flutter/services/scraper/kuvaton_scraper_service.dart';

class ApiService {
  final API api = API();
  final KuvatonScraperService scraper = KuvatonScraperService();
  final HttpClientWithInterceptor client =
      HttpClientWithInterceptor.build(interceptors: [
    LoggerInterceptor(),
  ]);

  Future<EntriesResponse> getPage({
    @required endpoint,
    int pageNumber,
  }) async {
    if (endpoint == Endpoint) {
      throw Exception('You must define the [Endpoint] to be used.');
    }
    Uri uri;
    if (endpoint == Endpoint.lolCategory) {
      uri = api.lolCategory(pageNumber: pageNumber ?? 1);
    } else if (endpoint == Endpoint.topCategory) {
      uri = api.topCategory(pageNumber: pageNumber ?? 1);
    } else if (endpoint == Endpoint.randomCategory) {
      uri = api.randomCategory(pageNumber: pageNumber ?? 1);
    }
    final response = await client.get(uri.toString());
    if (response.statusCode == 200) {
      List<EntryResponse> entries = scraper
          .parseEntries(response.body)
          .map((entry) => EntryResponse(
                imageFilename: entry.imageFilename,
                imageUrl: entry.imageUrl,
              ))
          .toList();
      return EntriesResponse(
        statusCode: response.statusCode,
        entries: entries,
      );
    }
    print(
        'Request $uri failed\nResponse: ${response.statusCode} ${response.reasonPhrase}');
    throw response;
  }
}
