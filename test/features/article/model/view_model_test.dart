import 'package:flutter_exercise/features/article/vm/view_model.dart';
import 'package:flutter_exercise/network/api_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

class MockApiManager extends Mock implements ApiManager {}

class MockArticleListResponse {
  static String body = '[{"userId": 1, "id": 1, "title": "title1", "body": "body"}, {"userId": 2, "id": 2, "title": "title2", "body": "body"}]';
}

void main() {
  group('ArticleListViewModel', () {
    late ArticleListViewModel viewModel;
    MockApiManager apiManager = MockApiManager();

    setUpAll(() => {
      viewModel = ArticleListViewModel(apiManager: apiManager)
    });

    test('test initial status', () async {
      expect(viewModel.fetchStatus, FetchStatus.loading);
    });

    test('test fetchArticles failed', () async {
      when(() => apiManager.get('/posts')).thenAnswer((_) => Future.value(null));

      await viewModel.fetchArticles();

      expect(viewModel.fetchStatus, FetchStatus.fail);
    });

    test('test fetchArticles success', () async {
      when(() => apiManager.get('/posts')).thenAnswer((_) => Future.value(Response(MockArticleListResponse.body, 200)));

      await viewModel.fetchArticles();

      expect(viewModel.fetchStatus, FetchStatus.success);
      expect(viewModel.filterArticles.length, 2);
    });

    test('test onSearchTextChange with empty string', () async {
      when(() => apiManager.get('/posts')).thenAnswer((_) => Future.value(Response(MockArticleListResponse.body, 200)));

      await viewModel.fetchArticles();

      viewModel.onSearchTextChange('');

      expect(viewModel.filterArticles.length, 2);
    });

    test('test onSearchTextChange with 1 ', () async {
      when(() => apiManager.get('/posts')).thenAnswer((_) => Future.value(Response(MockArticleListResponse.body, 200)));

      await viewModel.fetchArticles();

      viewModel.onSearchTextChange('1');

      expect(viewModel.filterArticles.length, 1);
    });
  });
}
