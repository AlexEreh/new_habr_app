import 'package:flutter/material.dart';
import 'package:habr_app/models/post_preview.dart';
import 'package:habr_app/stores/filters_store.dart';
import 'package:habr_app/utils/filters/article_preview_filters.dart';
import 'package:habr_app/utils/log.dart';
import 'package:habr_app/widgets/adaptive_ui.dart';
import 'package:itertools/itertools.dart';
import 'package:hive/hive.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tuple_dart/tuple.dart';

class FiltersPage extends StatefulWidget {
  const FiltersPage({super.key});

  @override
  State<StatefulWidget> createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.filters),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _createFilterDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  List<Tuple2<int, ChildT>>
      _filterChildType<ChildT extends Filter<PostPreview>>(
          Iterable<Tuple2<int, Filter<PostPreview>>> filtersWithIndex) {
    return filtersWithIndex
        .where((e) => e.item2 is ChildT)
        .map((e) => e.withItem2(e.item2 as ChildT))
        .toList(growable: false);
  }

  Widget _buildBody() {
    final filtersStore = FiltersStorage();
    removeFilter(int i) => () => filtersStore.removeFilterAt(i);
    return ValueListenableBuilder<Box<Filter<PostPreview>>>(
      valueListenable: filtersStore.listenable(),
      builder: (context, box, child) {
        final filtersWithIndex = box.values.enumerate().toList();
        final filtersByAuthor =
            _filterChildType<NicknameAuthorFilter>(filtersWithIndex);
        final filtersByCompany =
            _filterChildType<CompanyNameFilter>(filtersWithIndex);

        return ListView(
          children: [
            if (filtersByAuthor.isNotEmpty)
              FiltersGroup<NicknameAuthorFilter>(
                filters: filtersByAuthor,
                leading: const Icon(Icons.person_outline),
                titleBuilder: (filter) => Text(filter.nickname),
                onRemoveBuilder: removeFilter,
              ),
            if (filtersByCompany.isNotEmpty)
              FiltersGroup<CompanyNameFilter>(
                filters: filtersByCompany,
                leading: const Icon(Icons.groups),
                titleBuilder: (filter) => Text(filter.companyName),
                onRemoveBuilder: removeFilter,
              ),
          ].map((e) => DefaultConstraints(child: e)).toList(growable: false),
        );
      },
    );
  }

  Future<void> _createFilterDialog() async {
    final type = await showDialog<_DialogType>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(AppLocalizations.of(context)!.createFilterBy),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, _DialogType.AuthorNickname);
                },
                child: Text(AppLocalizations.of(context)!.authorNicknameFilter),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, _DialogType.CompanyName);
                },
                child: Text(AppLocalizations.of(context)!.companyNameFilter),
              ),
            ],
          );
        });

    if (type == null) return;

    switch (type) {
      case _DialogType.AuthorNickname:
        await _createAuthorNicknameFilter();
        break;
      case _DialogType.CompanyName:
        await _createCompanyNameFilter();
        break;
      default:
        logInfo('$type not supported');
    }
  }

  Future<void> _createAuthorNicknameFilter() async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return _AuthorNicknameFilterDialog();
        });
  }

  Future<void> _createCompanyNameFilter() async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return _CompanyNameFilterDialog();
        });
  }
}

class FiltersGroup<FilterT extends Filter<PostPreview>>
    extends StatelessWidget {
  final Iterable<Tuple2<int, FilterT>> filters;
  final Widget leading;
  final Widget Function(FilterT) titleBuilder;
  final void Function() Function(int) onRemoveBuilder;

  const FiltersGroup({super.key,
    required this.filters,
    required this.leading,
    required this.titleBuilder,
    required this.onRemoveBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: filters.map((tuple) {
          final index = tuple.item1;
          final filter = tuple.item2;
          return ListTile(
              leading: leading,
              title: titleBuilder(filter),
              trailing: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: onRemoveBuilder(index),
              ));
        }).toList(growable: false),
      ),
    );
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
  TextEditingController? nickanameControll;

  @override
  void initState() {
    super.initState();
    nickanameControll = TextEditingController();
  }

  bool nicknameValid() {
    return nickanameControll!.text.isNotEmpty;
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
                labelText: AppLocalizations.of(context)!.authorNickname,
                hintText: AppLocalizations.of(context)!.authorNicknameHint,
              ),
            ),
          )
        ],
      ),
      actions: <Widget>[
        TextButton(
            child: Text(AppLocalizations.of(context)!.cancel),
            onPressed: () {
              Navigator.pop(context);
            }),
        TextButton(
            child: Text(AppLocalizations.of(context)!.create),
            onPressed: () {
              if (nicknameValid())
                FiltersStorage()
                    .addFilter(NicknameAuthorFilter(nickanameControll!.text));
              Navigator.pop(context);
            })
      ],
    );
  }
}

class _CompanyNameFilterDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CompanyNameFilterDialogState();
}

class _CompanyNameFilterDialogState extends State<_CompanyNameFilterDialog> {
  TextEditingController? nickanameControll;

  @override
  void initState() {
    super.initState();
    nickanameControll = TextEditingController();
  }

  bool nicknameValid() {
    return nickanameControll!.text.isNotEmpty;
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
              decoration: const InputDecoration(
                labelText: "Имя компании",
                hintText: "Например, RUVDS.com",
              ),
            ),
          )
        ],
      ),
      actions: <Widget>[
        TextButton(
            child: Text(AppLocalizations.of(context)!.cancel),
            onPressed: () {
              Navigator.pop(context);
            }),
        TextButton(
            child: Text(AppLocalizations.of(context)!.create),
            onPressed: () {
              if (nicknameValid())
                FiltersStorage()
                    .addFilter(CompanyNameFilter(nickanameControll!.text));
              Navigator.pop(context);
            })
      ],
    );
  }
}
