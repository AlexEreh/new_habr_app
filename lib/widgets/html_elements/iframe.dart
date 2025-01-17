import 'package:flutter/material.dart';
import 'package:habr_app/widgets/link.dart';

class Iframe extends StatelessWidget {
  final String? src;
  const Iframe({super.key, this.src});

  @override
  Widget build(BuildContext context) {
    return TextLink(url: src, title: 'Медиаэлемент');
  }
}