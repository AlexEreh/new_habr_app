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

abstract class Span {}

class BlockSpan implements Span {
  Node child;

  BlockSpan(this.child);
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
  String text;
  String link;

  LinkSpan(this.text, this.link);
}

class TextParagraph implements Node {
  String text;

  TextParagraph(this.text);

  @override
  String get type => "text_paragraph";
}

class HeadLine implements Node {
  String text;
  String mode;

  HeadLine(this.text, this.mode);

  @override
  String get type => "headline";
}

class Image implements Node {
  String src;
  String? caption;

  Image(this.src, {this.caption});

  @override
  String get type => "image";
}

class Code implements Node {
  String text;
  String? language;

  Code(this.text, this.language);

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

  MathFormula(this.formula);

  @override
  String get type => "formula";
}
