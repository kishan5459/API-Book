import 'package:flutter/material.dart';
import 'todo_api_service.dart';
import 'todo_model.dart';
import 'add_edit_todo_screen.dart';

class TodoListScreen extends StatefulWidget {
  final int? userId;

  const TodoListScreen({super.key, this.userId});

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final _apiService = TodoApiService();
  final _scrollController = ScrollController();
  final List<Todo> _todos = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _skip = 0;
  final int _limit = 10;
  String? _errorMessage;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    _loadInitialTodos();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialTodos() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response =
          widget.userId != null
              ? await _apiService.getUserTodos(widget.userId!)
              : await _apiService.getTodos(skip: _skip, limit: _limit);

      setState(() {
        _todos.addAll(response.todos);
        _hasMore = _todos.length < response.total;
        _skip += _limit;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreTodos() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response =
          widget.userId != null
              ? await _apiService.getUserTodos(widget.userId!)
              : await _apiService.getTodos(skip: _skip, limit: _limit);

      setState(() {
        _todos.addAll(response.todos);
        _hasMore = _todos.length < response.total;
        _skip += _limit;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load more todos';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreTodos();
    }
  }

  Future<void> _refreshTodos() async {
    setState(() {
      _todos.clear();
      _skip = 0;
      _hasMore = true;
      _errorMessage = null;
      _successMessage = null;
    });
    await _loadInitialTodos();
  }

  Future<void> _toggleTodoCompletion(Todo todo) async {
    try {
      final updatedTodo = await _apiService.updateTodo(
        id: todo.id,
        completed: !todo.completed,
      );

      setState(() {
        final index = _todos.indexWhere((t) => t.id == todo.id);
        if (index != -1) {
          _todos[index] = updatedTodo;
        }
        _successMessage = 'Todo updated successfully';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to update todo';
      });
    }
  }

  Future<void> _deleteTodo(int id) async {
    try {
      await _apiService.deleteTodo(id);
      setState(() {
        _todos.removeWhere((todo) => todo.id == id);
        _successMessage = 'Todo deleted successfully';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to delete todo';
      });
    }
  }

  void _showDeleteConfirmationDialog(int id, String todoText) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: Text('Are you sure you want to delete "$todoText"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _deleteTodo(id);
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  void _navigateToAddTodo() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => AddEditTodoScreen(
              userId: widget.userId ?? 1, // Default to user 1 if not specified
            ),
      ),
    );

    if (result == true) {
      _refreshTodos();
    }
  }

  void _navigateToEditTodo(Todo todo) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => AddEditTodoScreen(
              todo: todo,
              userId: todo.userId, // Use the userId from the todo being edited
            ),
      ),
    );

    if (result == true) {
      _refreshTodos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.userId != null ? 'User ${widget.userId} Todos' : 'All Todos',
        ),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshTodos),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTodo,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          if (_successMessage != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _successMessage!,
                style: const TextStyle(color: Colors.green),
              ),
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshTodos,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _todos.length + (_hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= _todos.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final todo = _todos[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    child: ListTile(
                      leading: Checkbox(
                        value: todo.completed,
                        onChanged: (value) => _toggleTodoCompletion(todo),
                      ),
                      title: Text(
                        todo.todo,
                        style: TextStyle(
                          decoration:
                              todo.completed
                                  ? TextDecoration.lineThrough
                                  : null,
                        ),
                      ),
                      subtitle: Text('User ID: ${todo.userId}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _navigateToEditTodo(todo),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed:
                                () => _showDeleteConfirmationDialog(
                                  todo.id,
                                  todo.todo,
                                ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
