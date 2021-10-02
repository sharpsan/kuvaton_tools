import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:kuvaton_client_flutter/services/scraper/parsed_entry.dart';

class KuvatonScraperService {
  List<ParsedEntry> parseEntries(String body) {
    Document document = _parseDocument(body);
    List<ParsedEntry> parsedEntries = _parseEntries(document);
    return parsedEntries;
  }

  Document _parseDocument(String body) {
    Document document = parse(body);
    return document;
  }

  // parse image entries (filename, imagepath, etc)
  List<ParsedEntry> _parseEntries(Document document) {
    List<Element> entries = document.body
            ?.querySelector('div#kuvaboxi')
            ?.querySelectorAll('div.kuvaboxi') ??
        [];
    List<ParsedEntry> parsedEntries = entries
        .map((entry) => ParsedEntry(
              imageFilename: _parseImageFilename(entry),
              imageUrl: _parseImageUrl(entry),
            ))
        .toList();
    return parsedEntries;
  }

  String? _parseImageFilename(Element element) {
    String? imageFilename = element.querySelector('.kuvaotsikko')?.text;
    return imageFilename;
  }

  String? _parseImageUrl(Element element) {
    String? imageUrl = element.querySelector('div a img')?.attributes['src'];
    return imageUrl;
  }
}
