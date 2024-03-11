import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:habr_app/habr/api.dart';
import 'package:habr_app/routing/routing.dart';
import 'package:habr_app/widgets/widgets.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  createState() => _SearchPageState();
}

class SearchData {
  String query;
  Order order;

  SearchData({required this.query, required this.order});
}

class _SearchPageState extends State<SearchPage> {
  final queryController = TextEditingController();
  ValueNotifier<Order> orderBy = ValueNotifier(Order.relevance);

  @override
  void dispose() {
    queryController.dispose();
    orderBy.dispose();
    super.dispose();
  }

  void _onSearch() {
    final info = SearchData(query: queryController.text, order: orderBy.value);
    openSearchResult(context, info);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.search),
        actions: const [],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Card(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      textInputAction: TextInputAction.search,
                      onFieldSubmitted: (_) => _onSearch(),
                      autofocus: true,
                      controller: queryController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.keywords,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            queryController.clear();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                RadioGroup<Order>(
                  groupValue: orderBy,
                  title: AppLocalizations.of(context)!.sort,
                  enumToText: {
                    Order.relevance: AppLocalizations.of(context)!.relevance,
                    Order.date: AppLocalizations.of(context)!.date,
                    Order.rating: AppLocalizations.of(context)!.rating,
                  },
                ),
              ].map((e) => DefaultConstraints(child: e)).toList(),
            ),
          ),
          DefaultConstraints(
            child: Container(
              padding: const EdgeInsets.all(5),
              child: SearchButton(onPressed: _onSearch),
            ),
          ),
        ],
      ),
    );
  }
}

class RadioGroup<Enum> extends StatelessWidget {
  final Map<Enum, String> enumToText;
  final ValueNotifier<Enum?> groupValue;
  final String? title;

  const RadioGroup(
      {super.key,
      this.title,
      required this.groupValue,
      required this.enumToText});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ValueListenableBuilder<Enum?>(
        valueListenable: groupValue,
        builder: (context, group, child) {
          return Column(
            children: [
              ListTile(
                leading: Text(title!),
                trailing: const Icon(Icons.sort),
              ),
              ...enumToText.keys.map<Widget>(
                (e) => RadioListTile(
                  title: Text(enumToText[e]!),
                  // activeColor: Colors.blueGrey,
                  value: e,
                  groupValue: group,
                  onChanged: (dynamic value) {
                    groupValue.value = value;
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
