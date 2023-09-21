import 'package:flutter/material.dart';
import 'package:flutter_todo_graphql/core/services/graphql_queries.dart';
import 'package:flutter_todo_graphql/features/todo/widgets/todo_card.dart';
import 'package:flutter_todo_graphql/main.dart';
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
            return Center(child: Text('Exception : ${result.exception}'));
          }
          if (result.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
              itemCount: result.data!["todo"].length,
              itemBuilder: (context,index)=>ToDoCard(
                  task: result.data!["todo"][index]["task"],
                  isCompleted: result.data!["todo"][index]["isCompleted"],
                  delete: () async => await onDeleteToDo(context,result,index),
                  toggleIsComplete: ()async=> await onUpdateToDo(context, result, index)

              )
          );
        }
    );
  }

  onAddToDo(BuildContext context,String taskName) async{
    await GraphQLProvider.of(context).value.mutate(
        MutationOptions(
            document: gql(GraphQlQueries.addTaskQuery(taskName)),
            onCompleted: (_){
              showSnackBar('Added Todo');
            }
        )
    );
  }

  onDeleteToDo(BuildContext context,result,index)async{
   await GraphQLProvider.of(context).value.mutate(
        MutationOptions(
            document: gql(GraphQlQueries.deleteTaskMutation(result, index)),
          onCompleted: (_){
            showSnackBar('Deleted Todo');
          }
        )
    );
  }

  onUpdateToDo(BuildContext context,result,index)async{
    await GraphQLProvider.of(context).value.mutate(
        MutationOptions(document: gql(GraphQlQueries.toggleIsCompletedMutation(result, index)),
            onCompleted: (toggleResult){
                showSnackBar('Updated Todo');
            }
        )
    );

  }

  showSnackBar(String message){
    scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(content: Text(message))
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
                      decoration: const InputDecoration(
                        labelText: 'Task name'
                      ),
                    ),
                    const SizedBox(height: 25,),
                    ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await onAddToDo(context, txtTodoName.text.trim());
                        },
                        child:const Text(
                          "Add",
                          style: TextStyle(color: Colors.white),
                        ))
                    // Mutation(
                    //   options: MutationOptions(
                    //     document: gql(GraphQlQueries.addTaskQuery(txtTodoName.text.trim())),
                    //     // or do something with the result.data on completion
                    //     onCompleted: (dynamic resultData) {
                    //       showSnackBar('Added');
                    //     },
                    //   ),
                    //   builder:(runMutation,result){
                    //     return ElevatedButton(
                    //         onPressed: () async {
                    //            runMutation({});
                    //         },
                    //         child: Text(
                    //           "Add",
                    //           style: TextStyle(color: Colors.white),
                    //         ));
                    //   }
                    //
                    // ),
                  ],
                ),
              )
            ],
          )
        )
    );
  }
}
