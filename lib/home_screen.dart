import 'package:api_course/models/put/update_product.dart';
import 'package:api_course/screens/get_api/get_quotes.dart';
import 'package:api_course/screens/post_api/post_api_register_screen.dart';
import 'package:api_course/screens/post_api/post_api_user_job_add_screen.dart';
import 'package:api_course/screens/put_api/put_api_update_product_screen.dart';
import 'package:api_course/todo_crud/todo_list_screen.dart';
import 'package:flutter/material.dart';
// Import your screens here
import 'package:api_course/screens/get_api/get_api_products_screen.dart';
import 'package:api_course/screens/get_api/get_api_users_without_model.dart';
import 'package:api_course/screens/get_api/get_api_users_screen.dart';
// ... import other screens here

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // List of screens with titles
    final screens = [
      {"title": "Get API Products", "widget": const GetApiProductsScreen()},
      {"title": "Get API Users", "widget": const GetApiUsersScreen()},
      {
        "title": "Get API Users Without Model",
        "widget": const GetApiUsersWithoutModelScreen(),
      },
      {"title": "Get Quotes", "widget": const GetQuotesScreen()},
      {
        "title": "Post API User-Job Add Screen",
        "widget": const PostApiUserJobAddScreen(),
      },
      {"title": "Post API Register", 'widget': const RegisterScreen()},
      {
        "title": "Put API Product",
        "widget": UpdateProductScreen(
          initialProduct: PutProduct(
            id: 1,
            title: 'Sample Product',
            price: 9.99,
            description: 'A sample product description',
            category: 'electronics',
            image:
                'https://images.unsplash.com/photo-1575543483595-568b7afb6b9e?q=80&w=435&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
          ),
        ),
      },
      {"title": "Todo CRUD", "widget": TodoListScreen()},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("All Practice Screens")),
      body: ListView.separated(
        itemCount: screens.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(screens[index]["title"].toString()),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => screens[index]["widget"] as Widget,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
