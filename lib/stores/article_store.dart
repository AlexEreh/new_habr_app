import 'package:either_dart/either.dart';
import 'package:mobx/mobx.dart';

import 'package:habr_app/utils/page_loaders/page_loader.dart';
import 'package:habr_app/utils/filters/article_preview_filters.dart';
import 'package:habr_app/app_error.dart';
import 'package:habr_app/models/post_preview.dart';

import 'loading_state.dart';

part 'article_store.g.dart';

class ArticlesStorage extends ArticlesStorageBase with _$ArticlesStorage {
  final PageLoader<Either<AppError, PostPreviews>> loader;
  final Filter<PostPreview> filter;

  ArticlesStorage(
    this.loader, {
    this.filter = const NoneFilter<PostPreview>(),
  }) {
    loadFirstPage();
  }

  Future<Either<AppError, PostPreviews>> loadPage(int page) {
    return loader.load(page);
  }

  @override
  bool filterPreview(PostPreview preview) {
    return filter.filter(preview);
  }
}

abstract class ArticlesStorageBase with Store {
  @observable
  LoadingState firstLoading;
  bool loadItems = false;
  @observable
  List<PostPreview> previews = [];
  Set<String> _postIds = {};

  int maxPages = -1;
  int pages = 0;
  AppError lastError;

  @action
  Future reload() async {
    maxPages = -1;
    pages = 0;
    loadItems = false;
    loadFirstPage();
  }

  Future<Either<AppError, PostPreviews>> loadPage(int page);

  bool filterPreview(PostPreview preview);

  bool isNeedToAdd(PostPreview preview) =>
      !filterPreview(preview) && !_postIds.contains(preview.id);

  @action
  Future loadFirstPage() async {
    firstLoading = LoadingState.inProgress;
    final firstPage = await loadPage(1);
    firstLoading = firstPage.fold<LoadingState>((left) {
      lastError = left;
      return LoadingState.isCorrupted;
    }, (right) {
      previews.addAll(right.previews.where(isNeedToAdd));
      _postIds.addAll(right.previews.map((e) => e.id));
      maxPages = right.maxCountPages;
      pages = 1;
      return LoadingState.isFinally;
    });
  }

  Future<PostPreviews> loadPosts(int page) async {
    final postOrError = await loadPage(page);
    return postOrError.fold<PostPreviews>((err) {
      // TODO: informing user
      return PostPreviews(previews: [], maxCountPages: -1);
    }, (posts) => posts);
  }

  Future loadNextPage() async {
    final numberLoadingPage = pages + 1;
    loadItems = true;
    final nextPage = await loadPosts(numberLoadingPage);
    loadItems = false;
    previews.addAll(nextPage.previews.where(isNeedToAdd));
    _postIds.addAll(nextPage.previews.map((e) => e.id));
    pages = numberLoadingPage;
  }

  bool hasNextPages() {
    return pages < maxPages;
  }

  @action
  void removePreview(String id) {
    previews.removeWhere((element) => element.id == id);
    _postIds.remove(id);
    previews = List.from(previews);
  }

  @action
  void removeAllPreviews() {
    previews = [];
    _postIds = {};
  }
}
