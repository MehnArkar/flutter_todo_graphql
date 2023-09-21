
import 'package:flutter/material.dart';
import 'package:flutter_todo_graphql/core/constants/app_constant.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQlServices{
  static HttpLink httpLink = HttpLink(
      AppConstants.baseUrl,
    defaultHeaders: {
        'Content-Type':'application/json',
      'Hasura-Client-Name':'hasura-console',
      'x-hasura-admin-secret':'5SInhOlCnQPp06SoZFfCVgdArdto7vG2TbLFBbeOqhUMbzUG0yL0vpCPzkv7bsmB'
    }
  );
  // static AuthLink authLink = AuthLink();
  static Link link = httpLink as Link;
  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      cache: GraphQLCache(),
      link: link,
    ),
  );
}

GraphQlServices graphQlServices = GraphQlServices();