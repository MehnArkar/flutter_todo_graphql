import 'package:flutter/material.dart';
import 'package:flutter_todo_graphql/core/services/graphql_services.dart';
import 'package:flutter_todo_graphql/features/todo/pages/todo_page.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: graphQlServices.client,
      child:  MaterialApp(
        scaffoldMessengerKey: scaffoldMessengerKey,
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme:ThemeData.dark(
            useMaterial3: true
          ),
          home: const IndexPage()
      )
    );
  }
}

class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const TodoPage();
  }
}





