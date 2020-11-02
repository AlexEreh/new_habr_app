import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_view/photo_view.dart';
import 'package:habr_app/pages/image_view.dart';

class Picture extends StatelessWidget {
  final String url;
  final bool clickable;

  Picture.network(this.url, {this.clickable = false});

  // TODO: make asset constructor
  // Picture.asset(
  //   String assetName, {
  //   double height,
  //
  // }) :
  //       image = url.endsWith("svg") ? SvgPicture.asset(assetName)

  @override
  Widget build(BuildContext context) {
    Widget image;
    if (url.endsWith("svg")) {
      image = SvgPicture.network(url);
    } else {
      if (clickable) {
        image = _buildClickableImage(context);
      } else {
        image = Image.network(url);
      }
    }
    return image;
  }

  _buildClickableImage(BuildContext context) {
    final heroTag = url;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HeroPhotoViewRouteWrapper(
              tag: heroTag,
              imageProvider: NetworkImage(url),
            ),
          ),
        );
      },
      child: Container(
        child: Hero(
          tag: heroTag,
          child: Image.network(
            url,
          ),
        ),
      ),
    );
  }
}