import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habr_app/routing/routing.dart';
import 'package:habr_app/stores/articles_store.dart';
import 'package:habr_app/stores/filters_store.dart';
import 'package:habr_app/stores/habr_storage.dart';
import 'package:habr_app/utils/filters/article_preview_filters.dart';
import 'package:habr_app/utils/page_loaders/preview_loader.dart';
import 'package:habr_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ArticlesList extends StatelessWidget {
  const ArticlesList({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final drawerIsPartOfBody = width > 1000;
    return Scaffold(
      drawer: drawerIsPartOfBody ? null : const MainMenu(),
      appBar: AppBar(
        title: Center(
          child: Text(
            "HABR",
            style: GoogleFonts.montserrat(
                fontSize: 28, fontWeight: FontWeight.w500),
          ),
        ),
        actions: [
          IconButton(
              tooltip: AppLocalizations.of(context)!.search,
              icon: const Icon(Icons.search),
              onPressed: () => openSearch(context))
        ],
      ),
      body: ChangeNotifierProvider(
        create: (context) {
          final habrStorage = Provider.of<HabrStorage>(context, listen: false);
          return ArticlesStorage(
              FlowPreviewLoader(flow: PostsFlow.dayTop, storage: habrStorage),
              filter: AnyFilterCombine(FiltersStorage().getAll().toList()));
        },
        child: Row(
          children: [
            if (drawerIsPartOfBody) const DesktopHomeMenu(),
            const Expanded(child: ArticlesListBody()),
          ],
        ),
      ),
    );
  }
}
