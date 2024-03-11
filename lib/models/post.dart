import 'package:habr_app/utils/html_to_json/element_builders.dart';

import 'author.dart';

abstract class PostInfo {
  String get id;

  String get title;

  DateTime get publishDate;

  Author get author;
}

class Post implements PostInfo {
  @override
  final String id;
  @override
  final String title;
  final String body;
  @override
  final DateTime publishDate;
  @override
  final Author author;

  const Post({
    required this.id,
    required this.title,
    required this.body,
    required this.publishDate,
    required this.author,
  });
}

class ParsedPost implements PostInfo {
  @override
  final String id;
  @override
  final String title;
  final Node parsedBody;
  @override
  final DateTime publishDate;
  @override
  final Author author;

  const ParsedPost({
    required this.id,
    required this.title,
    required this.parsedBody,
    required this.publishDate,
    required this.author,
  });
}
