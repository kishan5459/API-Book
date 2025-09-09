import 'package:api_course/api_services/api_services.dart';
import 'package:api_course/models/get/get_users_list.dart';
import 'package:flutter/material.dart';

class GetApiUsersScreen extends StatefulWidget {
  const GetApiUsersScreen({super.key});

  @override
  State<GetApiUsersScreen> createState() => _GetApiUsersScreenState();
}

class _GetApiUsersScreenState extends State<GetApiUsersScreen> {
  final ApiServices _apiServices = ApiServices();

  GetUsersListModel getUsersListModel = GetUsersListModel();
  bool isLoading = false;
  String? error;

  void getUsersList() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final results = (await _apiServices.getUsersList("2"))!;
      setState(() {
        getUsersListModel = results;
        isLoading = false;
      });
    } catch (error) {
      print(error.toString());
      setState(() {
        isLoading = false;
        this.error = error.toString();
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsersList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Get API Integration (Users)"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "Reload Users",
            onPressed: getUsersList,
          ),
        ],
      ),
      body: Visibility(
        visible: isLoading == false,
        replacement: const Center(child: CircularProgressIndicator()),
        child: ListView.builder(
          itemCount: getUsersListModel.data?.length ?? 0,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  getUsersListModel.data?[index].avatar ??
                      "https://placehold.co/600x400",
                ),
              ),
              title: Text(getUsersListModel.data?[index].firstName ?? ""),
              subtitle: Text(getUsersListModel.data?[index].email ?? ""),
            );
          },
        ),
      ),
    );
  }
}
