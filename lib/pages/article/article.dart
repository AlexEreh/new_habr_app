import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:habr_app/utils/platform_helper.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:habr_app/stores/habr_storage.dart';
import 'package:habr_app/models/models.dart' as models;
import 'package:habr_app/models/models.dart';
import 'package:habr_app/stores/app_settings.dart';
import 'package:habr_app/stores/bookmarks_store.dart';
import 'package:habr_app/stores/loading_state.dart';
import 'package:habr_app/utils/date_to_text.dart';
import 'package:habr_app/widgets/widgets.dart';
import 'package:habr_app/routing/routing.dart';
import 'package:share/share.dart';
import 'package:habr_app/app_error.dart';
import 'package:habr_app/pages/article/components/post_store.dart';
import 'package:habr_app/widgets/scroll_data.dart';

class ArticlePage extends StatefulWidget {
  final String articleId;

  const ArticlePage({super.key, required this.articleId});

  @override
  createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  String get articleId => widget.articleId;
  late ValueNotifier<bool> showFloatingActionButton;
  ScrollController? _controller;

  _ArticlePageState();

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    showFloatingActionButton = ValueNotifier(false);
    _controller!.addListener(floatingButtonShowListener);
  }

  Future shareArticle(BuildContext context) async {
    final RenderBox box = context.findRenderObject() as RenderBox;
    await Share.share('https://habr.com/post/$articleId',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  Widget buildAppBarTitle(context, PostStorage store) {
    String? title;
    switch (store.loadingState) {
      case LoadingState.inProgress:
        return const LoadAppBarTitle();
      case LoadingState.isFinally:
        title = store.post!.title;
        break;
      case LoadingState.isCorrupted:
        title = AppLocalizations.of(context)!.notLoaded;
        break;
      default:
        title = "";
    }
    return Text(
      title,
      overflow: TextOverflow.fade,
    );
  }

  Widget buildBody(BuildContext context, PostStorage postStorage) {
    switch (postStorage.loadingState) {
      case LoadingState.inProgress:
        return const Center(child: CircularProgressIndicator());
      case LoadingState.isFinally:
        return ArticleView(
          article: postStorage.post,
          controller: _controller,
        );
      case LoadingState.isCorrupted:
        switch (postStorage.lastError.errCode) {
          case ErrorType.serverError:
            return const Center(child: LotOfEntropy());
          default:
            return Center(
              child: LossInternetConnection(
                onPressReload: () => postStorage.reload(),
              ),
            );
        }
      default:
        throw UnsupportedError(
            "Loading state ${postStorage.loadingState} not supported");
    }
  }

  @override
  Widget build(BuildContext context) {
    final habrStorage = context.watch<HabrStorage>();
    return ChangeNotifierProvider(
      create: (context) {
        final habrStorage = Provider.of<HabrStorage>(context, listen: false);
        final store = PostStorage(widget.articleId, storage: habrStorage);
        store.reload();
        store.addListener(() {
          showFloatingActionButton.value =
              store.loadingState == LoadingState.isFinally;
        });
        return store;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Consumer<PostStorage>(
            builder: (context, store, _) => buildAppBarTitle(context, store),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () => shareArticle(context),
            ),
            Builder(
              builder: (context) => PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (val) {
                  final store =
                      Provider.of<PostStorage>(context, listen: false);
                  switch (val) {
                    case MoreButtons.cache:
                      habrStorage.addArticleInCache(widget.articleId);
                      break;
                    case MoreButtons.bookmark:
                      addBookMark(store);
                      break;
                    case MoreButtons.backToBookmark:
                      returnToBookmark(store);
                      break;
                  }
                },
                itemBuilder: (context) => MoreButtons.values
                    .map((val) => PopupMenuItem(value: val, child: Text(val)))
                    .toList(),
              ),
            )
          ],
        ),
        body: Consumer<PostStorage>(
          builder: (context, store, _) => buildBody(context, store),
        ),
        floatingActionButton: ValueListenableBuilder(
          valueListenable: showFloatingActionButton,
          builder: (BuildContext context, bool value, Widget? child) =>
              HideFloatingActionButton(
                tooltip: AppLocalizations.of(context)!.comments,
                visible: value,
                onPressed: () => openCommentsPage(context, articleId),
                duration: const Duration(milliseconds: 300),
                child: const Icon(Icons.chat_bubble_outline),
          ),
        ),
      ),
    );
  }

  void addBookMark(PostStorage postStorage) {
    if (postStorage.loadingState == LoadingState.isFinally) {
      final position = _controller!.offset;
      final post = postStorage.post!;
      final preview = PostPreview(
        id: articleId,
        title: post.title,
        flows: [],
        publishDate: post.publishDate,
        statistics: const models.Statistics.zero(),
        author: post.author,
      );
      BookmarksStore().addBookmark(articleId, position, preview);
    }
  }

  void returnToBookmark(PostStorage postStorage) {
    if (postStorage.loadingState == LoadingState.isFinally) {
      final position = BookmarksStore().getPosition(articleId);
      if (position != null) {
        int duration = (_controller!.offset - position).abs().round();
        _controller!.animateTo(position,
            duration: Duration(milliseconds: duration), curve: Curves.easeOut);
      }
    }
  }

  void floatingButtonShowListener() {
    final needShow =
        _controller!.position.userScrollDirection == ScrollDirection.forward;
    if (needShow != showFloatingActionButton.value) {
      showFloatingActionButton.value = needShow;
    }
  }

  @override
  void dispose() {
    _controller!.removeListener(floatingButtonShowListener);
    showFloatingActionButton.dispose();
    super.dispose();
  }
}

class MoreButtons {
  static const String cache = "Сохранить";
  static const String bookmark = "Запомнить позицию";
  static const String backToBookmark = "Вернуться в позицию";

  static const List<String> values = [cache, bookmark, backToBookmark];
}

class ArticleInfo extends StatelessWidget {
  final PostInfo? article;

  const ArticleInfo({super.key, this.article});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Text(dateToStr(
                    article!.publishDate, Localizations.localeOf(context)))),
            InkWell(
              child: SmallAuthorPreview(article!.author),
              onTap: () => openUser(context, article!.author.alias),
            ),
          ],
        ),
        const SizedBox(
          height: 7,
        ),
        Text(
          article!.title,
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}

class ArticleView extends StatelessWidget {
  final ParsedPost? article;
  final ScrollController? controller;

  const ArticleView({super.key, this.article, this.controller});

  @override
  Widget build(BuildContext context) {
    final appSettings = context.watch<AppSettings>();
    final textAlign = appSettings.articleTextAlign;
    const padding = EdgeInsets.symmetric(horizontal: 10);
    final listview = SingleChildScrollView(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      controller: controller,
      child: CenterAdaptiveConstraint(
        child: Column(
          children: [
            Padding(
              padding: padding,
              child: ArticleInfo(
                article: article,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            HtmlView(
              article!.parsedBody,
              textAlign: textAlign,
              imagesWithPadding: false,
              padding: padding,
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                  child: MediumAuthorPreview(article!.author)),
              onTap: () =>
                  openUser(context, article!.author.alias), // open user page
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: padding,
              child: CommentsButton(
                onPressed: () => openCommentsPage(context, article!.id),
              ),
            ),
          ],
        ),
      ),
    );
    return ScrollConfiguration(
      behavior: ScrollData(
        thickness: 4,
        isAlwaysShow: isDesktop(context),
      ),
      child: listview,
    );
  }
}
