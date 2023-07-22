import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../network/api_manager.dart';
import '../model/aticle.dart';

enum FetchStatus {
  loading, success, fail
}

class ArticleListViewModel with ChangeNotifier {

  ArticleListViewModel({required this.apiManager});

  final ApiManager apiManager;

  List<Article> _articles = [];
  List<Article> _filterArticles = [];
  FetchStatus _fetchStatus = FetchStatus.loading;

  String get title => 'Article List';
  FetchStatus get fetchStatus => _fetchStatus;
  List<Article> get filterArticles => _filterArticles;

  Future<void> fetchArticles() async {
    http.Response? response = await apiManager.get('/posts');

    if (response == null || response.statusCode != 200) {
      _fetchStatus = FetchStatus.fail;
      notifyListeners();
      return;
    }

    try {
      List articleJsonList = jsonDecode(response.body) as List;
      _articles = articleJsonList.map((e) => Article.fromJson(e)).toList();
      _filterArticles = _articles;
      _fetchStatus = FetchStatus.success;
      notifyListeners();
    } catch (e) {
      _fetchStatus = FetchStatus.fail;
      notifyListeners();
    }
  }

  void onSearchTextChange(String text) {
    if (text.isEmpty) {
      _filterArticles = _articles;
      notifyListeners();
      return;
    }

    _filterArticles = _articles.where((element) => element.title.contains(text)).toList();
    notifyListeners();
  }
}