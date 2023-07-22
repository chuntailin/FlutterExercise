import 'package:flutter/material.dart';
import 'package:flutter_exercise/network/api_manager.dart';
import 'package:provider/provider.dart';

import 'features/article/screen/view.dart';
import 'features/article/vm/view_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final ApiManager apiManager = ApiManager();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ArticleListViewModel(apiManager: apiManager),),
      ],
      child: MaterialApp(
        title: 'Flutter Exercise',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
        ),
        home: const ArticleListPage(),
      ),
    );
  }
}
