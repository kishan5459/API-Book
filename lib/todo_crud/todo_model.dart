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
  bool completed;
  final int userId;
  final bool? isDeleted;
  final DateTime? deletedOn;

  Todo({
    required this.id,
    required this.todo,
    required this.completed,
    required this.userId,
    this.isDeleted,
    this.deletedOn,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      todo: json['todo'],
      completed: json['completed'],
      userId: json['userId'],
      isDeleted: json['isDeleted'],
      deletedOn:
          json['deletedOn'] != null ? DateTime.parse(json['deletedOn']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'todo': todo,
    'completed': completed,
    'userId': userId,
    'isDeleted': isDeleted,
    'deletedOn': deletedOn?.toIso8601String(),
  };
}
