import 'package:flutter/material.dart';
import 'package:flutter_exercise/network/api_manager.dart';
import 'package:provider/provider.dart';

import '../model/aticle.dart';
import '../vm/view_model.dart';

class ArticleListPage extends StatefulWidget {
  const ArticleListPage({super.key});

  @override
  State<ArticleListPage> createState() => _ArticleListPageState();
}

class _ArticleListPageState extends State<ArticleListPage> {

  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<ArticleListViewModel>(context, listen: false).fetchArticles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ArticleListViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: buildSearchTextField(viewModel),
      ),
      body: Center(
        child: buildBodyWidget(viewModel),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget buildBodyWidget(ArticleListViewModel viewModel) {
    switch (viewModel.fetchStatus) {
      case FetchStatus.loading:
        return const CircularProgressIndicator();
      case FetchStatus.fail:
        return buildFailuerWidget(viewModel);
      case FetchStatus.success:
        return builArticleListWidget(viewModel);
    }
  }

  Widget buildFailuerWidget(ArticleListViewModel viewModel) {
    return Column(
      children: [
        const Text('Fail to fetch articles'),
        TextButton(
          onPressed: () => viewModel.fetchArticles(),
          style: ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),),
          child: const Text('Retry'),
        ),
      ],
    );
  }

  Widget builArticleListWidget(ArticleListViewModel viewModel) {
    return ListView.builder(
        itemCount: viewModel.filterArticles.length,
        itemBuilder: (_, int index) {
          return ArticleView(article: viewModel.filterArticles[index]);
        }
    );
  }

  Widget buildSearchTextField(ArticleListViewModel viewModel) {
    return ListTile(
      leading: const Icon(Icons.search),
      title: TextField(
        controller: textEditingController,
        decoration: const InputDecoration(
            hintText: 'Search',
            border: InputBorder.none
        ),
        onChanged: (value) {
          viewModel.onSearchTextChange(value);
        },
      ),
      trailing: IconButton(
        icon: const Icon(Icons.cancel),
        onPressed: () {
          textEditingController.clear();
          viewModel.onSearchTextChange('');
      },),
    );
  }

}

class ArticleView extends StatelessWidget {
  const ArticleView({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(article.title, style: const TextStyle(color: Colors.black, fontSize: 20),),
          const SizedBox(height: 6),
          Text(article.body, maxLines: 2, style: const TextStyle(color: Colors.black45, fontSize: 15),),
          const SizedBox(height: 6,),
          Container(color: Colors.brown, height: 1,),
        ],
      ),
    );
  }

}