class GraphQlQueries{

  static String toggleIsCompletedMutation(result, index) {
    return (
        """mutation ToggleTask{
         update_todo(where: {
          id: {_eq: ${result.data["todo"][index]["id"]}}},
          _set: {isCompleted: ${!result.data["todo"][index]["isCompleted"]}}) {
             returning {isCompleted } }
             }""");
  }

  static String fetchTodoQuery() {
    return (
        """query TodoQuery{
               todo {
                  id
                  isCompleted
                  task
                  }} """);
  }

  static String deleteTaskMutation(result, index) {
    return ("""mutation DeleteTask{       
              delete_todo(where: {id: {_eq: ${result.data["todo"][index]["id"]}}}) {
                 returning {id} }
                 }""");
  }

  static String addTaskQuery(task) {
    return ("""mutation AddTask{
              insert_todo(objects: {isCompleted: false, task: "$task"}) {
                returning {id} }
                 }""");
  }
}