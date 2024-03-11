import 'package:habr_app/models/author_avatar_info.dart';

class AuthorInfo {
  final String alias;
  final String? fullName;
  final String? speciality;
  final String? about;
  final AuthorAvatarInfo? avatar;
  final int postCount;
  final int? followCount;
  final int? followersCount;
  final DateTime lastActivityTime;
  final DateTime registerTime;
  final int? rating;
  final num? karma;

  const AuthorInfo({
    required this.alias,
    this.fullName,
    this.speciality,
    this.about,
    this.avatar,
    required this.postCount,
    this.followCount,
    this.followersCount,
    required this.lastActivityTime,
    required this.registerTime,
    this.rating,
    this.karma,
  });
}
