import 'package:flutter/material.dart';
import 'package:habr_app/utils/page_loaders/preview_loader.dart';
import 'package:habr_app/pages/pages.dart';

void openArticle(BuildContext context, String articleId) {
  Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ArticlePage(articleId: articleId)));
}

void openCommentsPage(BuildContext context, String articleId) {
  Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => CommentsPage(
            articleId: articleId,
          )));
}

void openSearch(BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => const SearchPage()));
}

void openSearchResult(BuildContext context, SearchData info) {
  final loader = SearchLoader(info);
  Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SearchResultListPage(loader: loader)));
}

void openFilters(BuildContext context) {
  Navigator.pushNamed(context, "filters");
}

void openUser(BuildContext context, String username) {
  Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => UserPage(username: username)));
}

Map<String, WidgetBuilder> routes = {
  "settings": (BuildContext context) => const SettingsPage(),
  "articles": (BuildContext context) => const ArticlesList(),
  "articles/cached": (BuildContext context) => const CachedArticlesList(),
  "articles/bookmarks": (BuildContext context) => const BookmarksArticlesList(),
  "filters": (BuildContext context) => const FiltersPage(),
};
