import 'package:habr_app/utils/html_to_json.dart';
import 'package:habr_app/utils/html_to_json/element_builders.dart';

List<String> getImageUrlsFromHtml(String? html) {
  final parsedHtml = htmlAsParsedJson(html);
  final urls = getImagesFromParsedPost(parsedHtml).toList();
  return urls;
}

Iterable<String> getImagesFromParsedPost(Node? element) sync* {
  switch (element) {
    case Image():
      yield element.src;
    case NodeChild():
      yield* getImagesFromParsedPost(element.child);
    case NodeChildren():
      for (final child in element.children) {
        yield* getImagesFromParsedPost(child);
      }
    case Paragraph():
      for (final span in element.children) {
        if (span is BlockSpan) {
          yield* getImagesFromParsedPost(span.child);
        }
      }
  }
}
