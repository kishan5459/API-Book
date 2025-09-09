import 'package:api_course/api_services/api_services.dart';
import 'package:flutter/material.dart';

class GetApiUsersWithoutModelScreen extends StatefulWidget {
  const GetApiUsersWithoutModelScreen({super.key});

  @override
  State<GetApiUsersWithoutModelScreen> createState() =>
      _GetApiUsersWithoutModelScreenState();
}

class _GetApiUsersWithoutModelScreenState
    extends State<GetApiUsersWithoutModelScreen> {
  final ApiServices _apiServices = ApiServices();

  dynamic users;
  bool isLoading = false;
  String? error;

  void getUsersList() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final result = await _apiServices.getUsersWithoutModel();
      setState(() {
        if (result != null) {
          users = result;
        }
        isLoading = false;
      });
    } catch (err) {
      setState(() {
        isLoading = false;
        error = err.toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUsersList();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ LOADING STATE
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Get API Integration (Users Without Model)"),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // ✅ ERROR STATE
    if (error != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Get API Integration (Users Without Model)"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                error!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: getUsersList,
                child: const Text("Try Again"),
              ),
            ],
          ),
        ),
      );
    }

    // ✅ SUCCESS STATE
    return Scaffold(
      appBar: AppBar(
        title: const Text("Get API Integration (Users Without Model)"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "Reload Users",
            onPressed: getUsersList,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: users?['data'].length ?? 0,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                users['data'][index]['avatar'] ?? "",
              ),
            ),
            title: Text(
              "${users['data'][index]['first_name']} ${users['data'][index]['last_name'] ?? ""}",
            ),
            subtitle: Text(users['data'][index]['email'] ?? ""),
          );
        },
      ),
    );
  }
}
