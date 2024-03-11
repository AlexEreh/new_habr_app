import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/material.dart';

class HeroPhotoViewRouteWrapper extends StatelessWidget {
  const HeroPhotoViewRouteWrapper({super.key,
    this.imageProvider,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    required this.tag,
  });

  final ImageProvider? imageProvider;
  final Decoration? backgroundDecoration;
  final String tag;
  final dynamic minScale;
  final dynamic maxScale;

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();
    return KeyboardListener(
      focusNode: focusNode,
      autofocus: true,
      onKeyEvent: (event) {
        if (event.logicalKey == LogicalKeyboardKey.escape) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: PhotoView(
          imageProvider: imageProvider,
          backgroundDecoration: backgroundDecoration as BoxDecoration?,
          minScale: minScale,
          maxScale: maxScale,
          heroAttributes: PhotoViewHeroAttributes(tag: tag),
        ),
      ),
    );
  }
}
