import 'package:habr_app/models/author_info.dart';
import 'package:habr_app/models/models.dart';
import 'package:html/parser.dart' show parseFragment;

AuthorAvatarInfo prepareAvatarUrl(String? url) {
  if (url == null) return const AuthorAvatarInfo(url: null);
  if (url.startsWith("//")) url = url.replaceFirst("//", "https://");
  return AuthorAvatarInfo(url: url);
}

Author parseAuthorFromJson(Map<String, dynamic> json) {
  return Author(
    id: json['id'],
    alias: json['alias'],
    avatar: prepareAvatarUrl(json['avatarUrl']),
    speciality: json['speciality'],
    fullName:
        json['fullname'] == null ? null : _prepareHtmlString(json['fullname']),
  );
}

bool _commentIsBanned(Map<String, dynamic> json) {
  return json['author'] == null;
}

Comments parseCommentsFromJson(Map<String, dynamic> data) {
  return Comments(
    threads: (data['threads'] as List).cast<String>().map(int.parse).toList(),
    comments: (data['comments'] as Map<String, dynamic>)
        .map<int, Comment>((key, value) {
      return MapEntry(int.parse(key), parseCommentFromJson(value));
    }),
  );
}

Comment parseCommentFromJson(Map<String, dynamic> json) {
  final isBanned = _commentIsBanned(json);
  return Comment(
      id: int.parse(json['id']),
      parentId: json['parentId'] == null ? null : int.parse(json['parentId']),
      level: json['level'],
      banned: isBanned,
      timePublished: isBanned ? null : DateTime.parse(json['timePublished']),
      timeChanged: json['timeChanged'] == null
          ? null
          : DateTime.parse(json['timeChanged']),
      children:
          (json['children'] as List).cast<String>().map(int.parse).toList(),
      author: isBanned ? null : parseAuthorFromJson(json['author']),
      message: json['message']);
}

Post parsePostFromJson(Map<String, dynamic> data) {
  return Post(
    id: data['id'],
    title: _prepareHtmlString(data['titleHtml']),
    body: data['textHtml'],
    publishDate: DateTime.parse(data['timePublished']),
    author: parseAuthorFromJson(data['author']),
  );
}

PostPreviews parsePostPreviewsFromJson(Map<String, dynamic> data) {
  return PostPreviews(
    maxCountPages: data['pagesCount'],
    previews: data['publicationIds'].map<PostPreview>((id) {
      final article = data['publicationRefs'][id];
      return PostPreview(
          id: id,
          isCorporative: article['isCorporative'],
          title: _prepareHtmlString(article['titleHtml']),
          hubs: article['hubs']
              .map<String>((flow) => flow['title'] as String)
              .toList(),
          htmlPreview: "<div>${article['leadData']['textHtml']}</div>",
          flows: article['flows']
              .map<String>((flow) => flow['title'] as String)
              .toList(),
          publishDate: DateTime.parse(article['timePublished']),
          author: parseAuthorFromJson(article['author']),
          statistics: Statistics.fromJson(article['statistics']));
    }).toList(),
  );
}

AuthorInfo parseAuthorInfoFromJson(Map<String, dynamic> data) {
  return AuthorInfo(
      alias: data['alias'],
      fullName: data['fullname'],
      speciality: data['speciality'],
      avatar: prepareAvatarUrl(data['avatarUrl']),
      postCount: data['counterStats']['postCount'],
      followCount: data['followStats']['followCount'],
      followersCount: data['followStats']['followersCount'],
      lastActivityTime: DateTime.parse(data['lastActivityDateTime']),
      registerTime: DateTime.parse(data['registerDateTime']),
      rating: data['rating'].round(),
      karma: data['scoreStats']['score']);
}

String _prepareHtmlString(String str) {
  return parseFragment(str).text?.trim() ?? '';
}
