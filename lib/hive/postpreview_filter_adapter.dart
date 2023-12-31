import 'package:habr_app/models/post_preview.dart';
import 'package:habr_app/utils/filters/article_preview_filters.dart';
import 'package:hive/hive.dart';

class PostPreviewFilterAdapter extends TypeAdapter<Filter<PostPreview>> {
  @override
  final int typeId = 2;

  @override
  Filter<PostPreview> read(BinaryReader reader) {
    final obj = reader.readMap();
    switch (obj['type']) {
      case 'nickname':
        return NicknameAuthorFilter(obj['value']);
      case 'company_name':
        return CompanyNameFilter(obj['value']);
      default:
        return const NoneFilter();
    }
  }

  @override
  void write(BinaryWriter writer, Filter<PostPreview> obj) {
    if (obj is NicknameAuthorFilter) {
      writer.writeMap({
        'type': 'nickname',
        'value': obj.nickname,
      });
    } else if (obj is CompanyNameFilter) {
      writer.writeMap({
        'type': 'company_name',
        'value': obj.companyName,
      });
    }
  }
}
