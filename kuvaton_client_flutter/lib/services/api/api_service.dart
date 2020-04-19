import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:kuvaton_client_flutter/services/api/api.dart';
import 'package:kuvaton_client_flutter/services/api/entries_response.dart';
import 'package:kuvaton_client_flutter/services/scraper/kuvaton_scraper_service.dart';

class ApiService {
  final API api = API();
  final KuvatonScraperService scraper = KuvatonScraperService();

  Future<EntriesResponse> getPage({
    @required endpoint,
    int pageNumber,
  }) async {
    Uri uri;
    if (endpoint == Endpoint.page) {
      uri = api.pageUri(pageNumber);
    } else if (endpoint == Endpoint.lolPageFirst) {
      uri = api.lolPageFirst();
    } else if (endpoint == Endpoint.topPageFirst) {
      uri = api.topPageFirst();
    } else if (endpoint == Endpoint.randomPageFirst) {
      uri = api.randomPageFirst();
    }
    final response = await http.get(uri.toString());
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
