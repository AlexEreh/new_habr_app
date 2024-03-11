import 'package:either_dart/either.dart';
import 'package:habr_app/app_error.dart';
import 'package:habr_app/models/author_info.dart';
import 'package:habr_app/models/models.dart';
import 'package:habr_app/utils/http_request_helper.dart';
import 'package:habr_app/utils/log.dart';
import 'package:http/http.dart' as http;

import 'json_parsing.dart';

enum ArticleFeeds { dayTop, weekTop, yearTop, time, news }

enum Flows {
  my,
  all,
  develop,
  admin,
  design,
  management,
  marketing,
  popularScience
}

enum Order { date, relevance, rating }

const orderToText = {
  Order.date: 'date',
  Order.rating: 'rating',
  Order.relevance: 'relevance'
};

class Habr {
  static const apiUrlV2 = "https://m.habr.com/kek/v2";

  Future<Either<AppError, PostPreviews>> findPosts(
    String query, {
    int page = 1,
    Order order = Order.relevance,
  }) async {
    String ordString = orderToText[order]!;
    final url =
        "$apiUrlV2/articles/?query=$query&order=$ordString&fl=ru&hl=ru&page=$page";
    final response = await safe(http.get(Uri.parse(url)));
    return response
        .then(checkHttpStatus)
        .map(parseJson)
        .map((data) => parsePostPreviewsFromJson(data));
  }

  Future<Either<AppError, PostPreviews>> posts({
    int page = 1,
  }) async {
    final url =
        "$apiUrlV2/articles/?period=daily&sort=date&fl=ru&hl=ru&page=$page";
    logInfo("Get articles by $url");
    final response = await safe(http.get(Uri.parse(url)));
    return response
        .then(checkHttpStatus)
        .mapAsync(asyncParseJson)
        .mapRight((data) => parsePostPreviewsFromJson(data));
  }

  Future<Either<AppError, PostPreviews>> userPosts(
    String user, {
    int page = 1,
  }) async {
    final url =
        "$apiUrlV2/articles/?user=$user&sort=date&fl=ru&hl=ru&page=$page";
    logInfo("Get articles by $url");
    final response = await safe(http.get(Uri.parse(url)));
    return response
        .then(checkHttpStatus)
        .mapAsync(asyncParseJson)
        .mapRight((data) => parsePostPreviewsFromJson(data));
  }

  Future<Either<AppError, AuthorInfo>> userInfo(String user) async {
    final url = "$apiUrlV2/users/$user/card?fl=ru&hl=ru";
    logInfo("Get user info by $url");
    final response = await safe(http.get(Uri.parse(url)));
    return response
        .then(checkHttpStatus)
        .mapAsync(asyncParseJson)
        .mapRight((data) => parseAuthorInfoFromJson(data));
  }

  Future<Either<AppError, Post>> article(String id) async {
    final url = "$apiUrlV2/articles/$id";
    logInfo("Get article by $url");
    final response = await safe(http.get(Uri.parse(url)));
    return response
        .then(checkHttpStatus)
        .mapAsync(asyncParseJson)
        .mapRight((data) => parsePostFromJson(data));
  }

  Future<Either<AppError, Comments>> comments(String articleId) async {
    final url = "$apiUrlV2/articles/$articleId/comments";
    logInfo("Get comments by $url");
    final response = await safe(http.get(Uri.parse(url)));
    return response
        .then(checkHttpStatus)
        .map(parseJson)
        .map((data) => parseCommentsFromJson(data));
  }
}
