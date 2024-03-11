import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:habr_app/routing/routing.dart';

launchUrl(BuildContext context, String url) async {
  // TODO: open habr url in app
  if (url.startsWith(RegExp("https?://(m.)?habr.com"))) {
    final postRegexp = RegExp(
        r"https?://(m\.)?habr\.com/((ru|en)/)?(post|company/\w+/blog)/(\d+)/?");
    final matchPost = postRegexp.firstMatch(url);
    if (matchPost != null) {
      final postId = matchPost.group(5); // post id
      openArticle(context, postId!);
      return;
    } else {
      if (kDebugMode) {
        print("no match");
      }
    }
  }
  await launchUrl(context, url);
}
