import 'package:api_course/api_services/api_services.dart';
import 'package:api_course/models/post/create_job_response.dart';
import 'package:flutter/material.dart';

class PostApiUserJobAddScreen extends StatefulWidget {
  const PostApiUserJobAddScreen({super.key});

  @override
  State<PostApiUserJobAddScreen> createState() =>
      _PostApiUserJobAddScreenState();
}

class _PostApiUserJobAddScreenState extends State<PostApiUserJobAddScreen> {
  final ApiServices _apiServices = ApiServices();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _jobController = TextEditingController();

  String? error;
  bool isLoading = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      Map args = {"name": _nameController.text, "job": _jobController.text};
      debugPrint(args.toString());
      final CreatejobResponse result = await _apiServices.createJob(args);

      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text("New User created"),
              content: SizedBox(
                height: 200,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text("UserId : ${result.id}"),
                      Text("UserName : ${result.name}"),
                      Text("Job : ${result.job}"),
                      Text("CreatedAt : ${result.createdAt}"),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: Navigator.of(context).pop,
                  child: Text("OK"),
                ),
              ],
            ),
      );

      _nameController.clear();
      _jobController.clear();
    } catch (err, stack) {
      // handle error and diplsay in dialog box
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text("Error"),
              content: SizedBox(
                height: 150,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(err.toString()),
                      SizedBox(height: 10),
                      Text(stack.toString()),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: Navigator.of(context).pop,
                  child: Text("OK"),
                ),
              ],
            ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _jobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Post"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Enter Name",
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return "Name is Required";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _jobController,
                decoration: InputDecoration(
                  labelText: "Enter Job",
                  prefixIcon: Icon(Icons.work),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return "Job Name Is Required";
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.purple,
                  ),
                  onPressed: isLoading ? null : _submit,
                  child:
                      isLoading
                          ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                          : const Text("Submit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
