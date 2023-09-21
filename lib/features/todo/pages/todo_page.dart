import 'package:flutter/material.dart';
import 'package:flutter_todo_graphql/core/services/graphql_queries.dart';
import 'package:flutter_todo_graphql/features/todo/widgets/todo_card.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {

   return Scaffold(
     appBar: AppBar(
       centerTitle: true,
       title: const Text('Todo'),
     ),
     body: todoList(),
     floatingActionButton: FloatingActionButton(
       onPressed:()=> showAddTodoDialog(context),
       child: const Icon(Icons.add,color: Colors.white,),
     ),
   );
  }

  Widget todoList(){
    return Query(
        options: QueryOptions(document: gql(GraphQlQueries.fetchTodoQuery()),pollInterval: const Duration(seconds: 10)),
        builder: (QueryResult result, { VoidCallback? refetch, FetchMore? fetchMore }){
          if (result.hasException) {
            print(result.exception);
            return Text('Exception : ${result.exception}');
          }
          if (result.isLoading) {
            return const Text('Loading');
          }
          return ListView.builder(
              itemCount: result.data!["todo"].length,
              itemBuilder: (context,index)=>ToDoCard(
                  task: result.data!["todo"][index]["task"],
                  isCompleted: result.data!["todo"][index]["isCompleted"],
                  delete: ()async{
                    // await GraphQLProvider.of(context).value.mutate(MutationOptions(document: gql(document)));
                  },
                  toggleIsComplete: (){},
              )
          );
        }
    );
  }

  showAddTodoDialog(BuildContext context){
    TextEditingController txtTodoName = TextEditingController();
    return showDialog(
        context: context,
        builder: (context)=>Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
          ),
          child: Wrap(
            children: [
              Container(
                padding:const EdgeInsets.symmetric(horizontal: 25,vertical: 25),
                width: double.maxFinite,
                child: Column(
                  children: [
                    const Text('Add Todo',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: Colors.white),),
                    const SizedBox(height: 25,),
                    TextField(
                      controller: txtTodoName,
                      decoration: InputDecoration(
                        labelText: 'Task name'
                      ),
                    ),
                    const SizedBox(height: 25,),
                    ElevatedButton(
                        onPressed: ()async{
                          QueryResult result = await GraphQLProvider.of(context).value.mutate(MutationOptions(document: gql(GraphQlQueries.addTaskQuery(txtTodoName.text.trim()))));
                          Navigator.of(context).pop();
                          if(!result.hasException){
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Added'))
                          );
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(result.exception.toString()))
                            );
                          }
                        },
                        child: Text('ADD')),
                  ],
                ),
              )
            ],
          )
        )
    );
  }
}
