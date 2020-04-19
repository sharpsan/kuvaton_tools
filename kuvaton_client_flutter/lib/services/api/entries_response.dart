import 'package:flutter/foundation.dart';

class EntryResponse {
  String imageFilename;
  String imageUrl;
  EntryResponse({
    @required this.imageFilename,
    @required this.imageUrl,
  });
}

class EntriesResponse {
  int statusCode;
  List<EntryResponse> entries;
  EntriesResponse({
    @required this.statusCode,
    @required this.entries,
  });
}
