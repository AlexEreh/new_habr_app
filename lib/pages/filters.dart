import 'package:flutter/material.dart';
import 'package:habr_app/models/post_preview.dart';
import 'package:habr_app/stores/filters_store.dart';
import 'package:habr_app/utils/filters/article_preview_filters.dart';
import 'package:habr_app/utils/log.dart';
import 'package:habr_app/utils/extensions/iterator_helper.dart';
import 'package:hive/hive.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FiltersPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).filters),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: _createFilterDialog,
      ),
    );
  }

  Widget _buildBody() {
    return ValueListenableBuilder<Box<Filter<PostPreview>>>(
      valueListenable: FiltersStorage().listenable(),
      builder: (context, box, child) =>
          ListView(
            children: box.values.mapIndexed<Widget>((i, filter) {
              if (filter is NicknameAuthorFilter) {
                return ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: Text(filter.nickname),
                  trailing: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => FiltersStorage().removeFilterAt(i),
                  ),
                );
              } else {
                logInfo("filter not supported");
              }
              return null;
            }).toList(),
          ),
    );
  }

  Future<void> _createFilterDialog() async {
    final type = await showDialog<_DialogType>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Создать фильтр по'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, _DialogType.AuthorNickname);
                },
                child: const Text('Никнейму автора'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, _DialogType.CompanyName);
                },
                child: const Text('Имени компании'),
              ),
            ],
          );
        });

    if (type == null) return;

    switch (type) {
      case _DialogType.AuthorNickname:
        await _createAuthorNicknameFilter();
        break;
      default:
        logInfo('$type not supported');
    }
  }

  Future<void> _createAuthorNicknameFilter() async {
    await showDialog<_DialogType>(
        context: context,
        builder: (BuildContext context) {
          return _AuthorNicknameFilterDialog();
        });
  }
}

enum _DialogType {
  AuthorNickname,
  CompanyName,
  Rating,
  // other
}

class _AuthorNicknameFilterDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AuthorNicknameFilterDialogState();
}

class _AuthorNicknameFilterDialogState
    extends State<_AuthorNicknameFilterDialog> {
  TextEditingController nickanameControll;

  @override
  void initState() {
    nickanameControll = TextEditingController();
  }

  bool nicknameValid() {
    return nickanameControll.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16.0),
      content: Row(
        children: [
          Expanded(
            child: TextField(
              controller: nickanameControll,
              autofocus: true,
              decoration: InputDecoration(
                  labelText: 'Author nickname', hintText: 'например, vds'),
            ),
          )
        ],
      ),
      actions: <Widget>[
        FlatButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            }),
        FlatButton(
            child: const Text('Create'),
            onPressed: () {
              if (nicknameValid())
                FiltersStorage().addFilter(
                    NicknameAuthorFilter(nickanameControll.text));
              Navigator.pop(context);
            })
      ],
    );
  }
}
