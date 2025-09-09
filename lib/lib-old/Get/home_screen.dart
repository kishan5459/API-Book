import "package:api_course/lib-old/Model/get_model.dart";
import "package:api_course/lib-old/Services/get_services.dart";
import "package:flutter/material.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CommandsModel> commandsModel = [];
  getComments() {
    GetApiServices().getCommentsModel().then((value) {
      setState(() {
        commandsModel = value!;
      });
    });
  }

  @override
  void initState() {
    getComments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100]!,
      appBar: AppBar(title: const Text("Get API")),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: commandsModel.length,
        itemBuilder: (context, index) {
          final apidata = commandsModel[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              color: Colors.blue[100],
              elevation: 5,
              borderRadius: BorderRadius.circular(20),
              child: Row(
                children: [
                  const SizedBox(width: 3),
                  CircleAvatar(
                    backgroundColor: Colors.blue[300],
                    child: Text(
                      apidata.id.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.175,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          apidata.name.toString(),
                          maxLines: 1,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        Text(
                          apidata.email.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        Text(
                          apidata.body.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
