import 'package:flutter/material.dart';
import 'package:habr_app/stores/app_settings.dart';
import 'package:habr_app/utils/html_to_json.dart';
import 'package:habr_app/utils/html_to_json/element_builders.dart' as view;
import 'package:habr_app/utils/log.dart';
import 'package:itertools/itertools.dart';
import 'package:provider/provider.dart';

import 'dividing_block.dart';
import 'html_elements/html_elements.dart';
import 'link.dart';
import 'picture.dart';

class HtmlView extends StatelessWidget {
  final view.Node node;
  final TextAlign? textAlign;
  final bool imagesWithPadding;
  final EdgeInsets? padding;

  const HtmlView(
    this.node, {
    super.key,
    this.textAlign,
    this.imagesWithPadding = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: inlineTree(
        node,
        context,
        BuildParams(
          textAlign: textAlign,
          imagesWithPadding: imagesWithPadding,
          padding: padding,
        ),
      ).toList(),
    );
  }

  HtmlView.unparsed(
    String? html, {
    super.key,
    this.textAlign,
    this.imagesWithPadding = false,
    this.padding,
  }) : node = htmlAsParsedJson(html);
}

class BuildParams {
  final TextAlign? textAlign;
  final bool imagesWithPadding;
  final EdgeInsets? padding;

  BuildParams({
    this.textAlign,
    required this.imagesWithPadding,
    this.padding,
  });

  BuildParams withoutPadding() {
    return BuildParams(
      textAlign: textAlign,
      imagesWithPadding: false,
    );
  }
}

Widget wrapPadding(Widget child, BuildParams params) => params.padding != null
    ? Padding(
        padding: params.padding!,
        child: child,
      )
    : child;

// may be null
Widget? buildTree(
  view.Node element,
  BuildContext context,
  BuildParams params, {
  bool isInline = false,
}) {
  final type = element.type;
  switch (element) {
    case view.HeadLine():
      logInfo('$type ${element.text}');
    case view.Paragraph():
      logInfo('$type ${element.children}');
    default:
      logInfo(type);
  }

  Widget? widget;
  switch (element) {
    case view.HeadLine():
      final mode =
          HeadLineType.values[int.parse(element.mode.substring(1)) - 1];
      widget = HeadLine(text: element.text, type: mode);
      widget = wrapPadding(widget, params);
    case view.TextParagraph():
      widget = Text(
        element.text,
        textAlign: params.textAlign,
      );
      widget = wrapPadding(widget, params);
    case view.Paragraph():
      widget = Text.rich(
        TextSpan(
            children: element.children
                .map<InlineSpan>((child) => buildInline(child, context, params))
                .toList()),
        textAlign: params.textAlign,
      );
      widget = wrapPadding(widget, params);
    case view.Scrollable():
      widget = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: buildTree(element.child, context, params),
      );
    case view.Image():
      widget = Picture.network(
        element.src,
        clickable: true,
      );
      if (element.caption != null) {
        widget = WrappedContainer(
          distance: 5,
          children: [
            widget,
            wrapPadding(
              Text(element.caption!,
                  style: Theme.of(context).textTheme.titleSmall),
              params,
            ),
          ],
        );
      }
      if (params.imagesWithPadding) {
        widget = Padding(
          padding: params.padding!,
          child: widget,
        );
      }
    case view.MathFormula():
      widget = Padding(
        padding: const EdgeInsets.only(top: 10),
        child: MathFormula(element.formula),
      );
      if (!isInline) {
        widget = Center(child: widget);
        widget = wrapPadding(widget, params);
      }
    case view.Code():
      final appSettings = Provider.of<AppSettings>(context, listen: false);
      widget = HighlightCode(
        element.text,
        language: element.language,
        padding: const EdgeInsets.all(10),
        themeMode: appSettings.codeThemeMode,
        themeNameDark: appSettings.darkCodeTheme,
        themeNameLight: appSettings.lightCodeTheme,
      );
    case view.BlockQuote():
      widget = BlockQuote(
        child: buildTree(
          element.child,
          context,
          params.withoutPadding(),
        ),
      );
      widget = wrapPadding(widget, params);
    case view.BlockList():
      widget = UnorderedList(
          children: element.children
              .map<Widget?>((li) => buildTree(
                    li,
                    context,
                    params.withoutPadding(),
                  ))
              .notNull
              .toList());
      widget = wrapPadding(widget, params);
    case view.BlockColumn():
      widget = WrappedContainer(
          children: element.children
              .map<Widget?>((child) => buildTree(child, context, params))
              .notNull
              .toList());
      widget = wrapPadding(widget, params);
    case view.Details():
      widget = Spoiler(
        title: element.title,
        child: buildTree(element.child, context, params),
      );
      widget = wrapPadding(widget, params);
    case view.Iframe():
      widget = Iframe(
        src: element.src,
      );
      widget = wrapPadding(widget, params);
    case view.Table():
      try {
        widget = Table(
          defaultColumnWidth: const IntrinsicColumnWidth(),
          border: TableBorder.all(
              color: Theme.of(context).textTheme.bodyMedium!.color!),
          children: element.rows
              .map((row) => TableRow(
                  children: row
                      .map((child) => TableCell(
                          child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: buildTree(child, context, params))))
                      .toList()))
              .toList(),
        );
      } catch (err) {
        widget = const Text("Unsupported table");
      }
      widget = wrapPadding(widget, params);
    default:
      logInfo("Not found case for $type");
  }

  return widget;
}

InlineSpan buildInline(
    view.Span element, BuildContext context, BuildParams params) {
  late InlineSpan span;
  switch (element) {
    case view.TextSpan():
      var style = const TextStyle();
      for (final mode in element.modes) {
        if (mode == 'bold' || mode == 'strong') {
          style = style.copyWith(fontWeight: FontWeight.w700);
        } else if (mode == 'italic' || mode == 'emphasis') {
          style = style.copyWith(fontStyle: FontStyle.italic);
        } else if (mode == 'underline') {
          style = style.copyWith(decoration: TextDecoration.underline);
        } else if (mode == 'strikethrough') {
          style = style.copyWith(decoration: TextDecoration.lineThrough);
        }
      }
      span = TextSpan(text: element.text, style: style);
    case view.LinkSpan():
      span = inlineTextLink(
          title: element.text, url: element.link, context: context);
    case view.BlockSpan():
      span = WidgetSpan(
          child: buildTree(element.child, context, params, isInline: true)!);
  }

  return span;
}

Iterable<Widget> inlineTree(
    view.Node? element, BuildContext context, BuildParams params) sync* {
  switch (element) {
    case view.BlockColumn():
      final children = element.children;
      for (int i = 0; i < children.length; i++) {
        final item = children[i];
        yield* inlineTree(item, context, params);
        if (i != children.length - 1) yield const SizedBox(height: 20);
      }
    case view.BlockList():
      for (final item in element.children) {
        yield wrapPadding(
            UnorderedItem(child: buildTree(item, context, params)!), params);
      }
    default:
      yield buildTree(element!, context, params)!;
  }
}
