class TodoListResponse {
  final List<Todo> todos;
  final int total;
  final int skip;
  final int limit;

  TodoListResponse({
    required this.todos,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory TodoListResponse.fromJson(Map<String, dynamic> json) {
    return TodoListResponse(
      todos:
          (json['todos'] as List).map((todo) => Todo.fromJson(todo)).toList(),
      total: json['total'],
      skip: json['skip'],
      limit: json['limit'],
    );
  }
}

class Todo {
  final int id;
  final String todo;
  final bool completed;
  final int userId;

  Todo({
    required this.id,
    required this.todo,
    required this.completed,
    required this.userId,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      todo: json['todo'],
      completed: json['completed'],
      userId: json['userId'],
    );
  }
}
