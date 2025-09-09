import 'package:flutter/material.dart';
import 'todo_model.dart';
import 'todo_api_service.dart';

class AddEditTodoScreen extends StatefulWidget {
  final Todo? todo;
  final int? userId;

  AddEditTodoScreen({super.key, this.todo, this.userId}) {
    // Validate that either todo or userId is provided
    assert(
      todo != null || userId != null,
      'Either todo or userId must be provided',
    );
  }

  @override
  _AddEditTodoScreenState createState() => _AddEditTodoScreenState();
}

class _AddEditTodoScreenState extends State<AddEditTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = TodoApiService();
  final _todoController = TextEditingController();
  bool _completed = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      _todoController.text = widget.todo!.todo;
      _completed = widget.todo!.completed;
    }
  }

  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (widget.todo == null) {
        // For new todos, use the provided userId
        await _apiService.addTodo(
          todo: _todoController.text,
          completed: _completed,
          userId: widget.userId!,
        );
      } else {
        // For existing todos, use the todo's userId
        await _apiService.updateTodo(
          id: widget.todo!.id,
          todo: _todoController.text,
          completed: _completed,
        );
      }

      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.todo == null ? 'Add Todo' : 'Edit Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              TextFormField(
                controller: _todoController,
                decoration: const InputDecoration(
                  labelText: 'Todo',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a todo';
                  }
                  return null;
                },
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Completed'),
                value: _completed,
                onChanged: (value) {
                  setState(() {
                    _completed = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child:
                      _isLoading
                          ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                          : Text(
                            widget.todo == null ? 'Add Todo' : 'Update Todo',
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
