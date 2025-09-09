import 'package:api_course/api_services/api_services.dart';
import 'package:api_course/models/get/get_product.dart';
import 'package:flutter/material.dart';

class GetApiProductsScreen extends StatefulWidget {
  const GetApiProductsScreen({super.key});

  @override
  State<GetApiProductsScreen> createState() => _GetApiProductsScreenState();
}

class _GetApiProductsScreenState extends State<GetApiProductsScreen> {
  final ApiServices _apiServices = ApiServices();

  List<Product> products = [];
  bool isLoading = false;
  String? error;

  void getProducts() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final result = (await _apiServices.getProductsList());
      setState(() {
        if (result != null) products = result;
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
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Get API Integration (Products)"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "Reload Products",
            onPressed: getProducts,
          ),
        ],
      ),
      body: Visibility(
        visible: isLoading == false,
        replacement: const Center(child: CircularProgressIndicator()),
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  products[index].image ?? 'https://placehold.co/100x100',
                ),
              ),
              title: Text(products[index].title ?? 'No title'),
              subtitle: Text(products[index].category ?? 'No category'),
              trailing: Text(
                '★ ${products[index].rating?.rate?.toStringAsFixed(1) ?? '-'}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                // handle tap if needed
              },
            );
          },
        ),
      ),
    );
  }
}
