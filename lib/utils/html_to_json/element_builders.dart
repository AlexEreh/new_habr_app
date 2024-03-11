import 'text_mode.dart';

export 'text_mode.dart';

abstract class Node {
  String get type;
}

abstract class NodeChild extends Node {
  Node get child;
}

abstract class NodeChildren extends Node {
  List<Node> get children;
}

class Paragraph implements Node {
  List<Span> children;

  Paragraph.empty() : children = [];

  void addSpan(Span span) {
    children.add(span);
  }

  @override
  String get type => "paragraph";
}

interface class Span {}

class BlockSpan implements Span {
  final Node child;

  const BlockSpan(this.child);
}

class TextSpan implements Span {
  String text;
  List<String> modes;

  TextSpan(this.text, {List<TextMode> modes = const []})
      : modes = modes
            .map((mode) => mode.toString().substring('TextMode'.length + 1))
            .toList();
}

class LinkSpan implements Span {
  final String text;
  final String link;

  const LinkSpan(this.text, this.link);
}

class TextParagraph implements Node {
  final String _text;

  TextParagraph(final String text): _text = text.trim();

  String get text => _text;

  @override
  String get type => "text_paragraph";
}

class HeadLine implements Node {
  final String text;
  final String mode;

  const HeadLine(this.text, this.mode);

  @override
  String get type => "headline";
}

class Image implements Node {
  final String src;
  final String? caption;

  const Image(this.src, {this.caption});

  @override
  String get type => "image";
}

class Code implements Node {
  final String text;
  final String? language;

  const Code(this.text, this.language);

  @override
  String get type => "code";
}

enum ListType { unordered, ordered }

class BlockList implements NodeChildren {
  @override
  List<Node> children;
  ListType listType;

  BlockList(this.listType, this.children);

  @override
  String get type => "${listType}_list";
}

class Details implements NodeChild {
  String title;
  @override
  Node child;

  Details(this.title, this.child);

  @override
  String get type => "details";
}

class Scrollable implements NodeChild {
  @override
  Node child;

  Scrollable(this.child);

  @override
  String get type => "scrollable";
}

class BlockColumn implements NodeChildren {
  @override
  List<Node> children;

  BlockColumn(this.children);

  @override
  String get type => "column";
}

class BlockQuote implements NodeChild {
  @override
  Node child;

  BlockQuote(this.child);

  @override
  String get type => "quote";
}

class Iframe implements Node {
  String src;

  Iframe(this.src);

  @override
  String get type => "iframe";
}

class Table implements Node {
  // имплементирует ноду чтобы не применялись оптимизаци
  List<List<Node>> rows;

  Table(this.rows);

  @override
  String get type => "table";
}

class MathFormula implements Node {
  final String formula;

  const MathFormula(this.formula);

  @override
  String get type => "formula";
}
