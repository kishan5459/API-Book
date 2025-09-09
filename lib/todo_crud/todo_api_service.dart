import 'package:http/http.dart' as http;
import 'dart:convert';
import 'todo_model.dart';

class TodoApiService {
  static const String _baseUrl = 'https://dummyjson.com/todos';

  Future<TodoListResponse> getTodos({int skip = 0, int limit = 10}) async {
    try {
      final url = Uri.parse('$_baseUrl?skip=$skip&limit=$limit');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return TodoListResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load todos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading todos: $e');
    }
  }

  Future<TodoListResponse> getUserTodos(int userId) async {
    try {
      final url = Uri.parse('$_baseUrl/user/$userId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return TodoListResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load user todos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading user todos: $e');
    }
  }

  Future<Todo> addTodo({
    required String todo,
    required bool completed,
    required int userId,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/add');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'todo': todo,
          'completed': completed,
          'userId': userId,
        }),
      );

      if (response.statusCode == 201) {
        return Todo.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to add todo: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding todo: $e');
    }
  }

  Future<Todo> updateTodo({
    required int id,
    bool? completed,
    String? todo,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/$id');
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          if (completed != null) 'completed': completed,
          if (todo != null) 'todo': todo,
        }),
      );

      if (response.statusCode == 200) {
        return Todo.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update todo: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating todo: $e');
    }
  }

  Future<Todo> deleteTodo(int id) async {
    try {
      final url = Uri.parse('$_baseUrl/$id');
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        return Todo.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to delete todo: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting todo: $e');
    }
  }
}
