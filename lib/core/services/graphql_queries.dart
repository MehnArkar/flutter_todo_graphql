class GraphQlQueries{
  static String fetchTodoQuery() {
    return (
        """query TodoQuery{
               todo {
                  id
                  isCompleted
                  task
                  }} """);
  }

  static String addTaskQuery(task) {
    return ("""mutation AddTask{
              insert_todo(objects: {isCompleted: false, task: "$task"}) {
                returning {id} }
                 }""");
  }
}