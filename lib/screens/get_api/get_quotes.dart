import 'package:api_course/api_services/api_services.dart';
import 'package:api_course/models/get/get_quotes.dart';
import 'package:flutter/material.dart';

class GetQuotesScreen extends StatefulWidget {
  const GetQuotesScreen({super.key});

  @override
  State<GetQuotesScreen> createState() => _GetQuotesScreenState();
}

class _GetQuotesScreenState extends State<GetQuotesScreen> {
  final ApiServices _apiServices = ApiServices();
  late Future<QuotesResponse> _future;

  @override
  void initState() {
    super.initState();
    _future = _fetchQuotes();
  }

  Future<QuotesResponse> _fetchQuotes() {
    return _apiServices.getQuotesResponse();
  }

  void _reloadQuotes() {
    setState(() {
      _future = _fetchQuotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quotes List"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "Reload Quotes",
            onPressed: _reloadQuotes,
          ),
        ],
      ),
      body: FutureBuilder<QuotesResponse>(
        future: _future,
        initialData: QuotesResponse(
          data: Quotes(data: []),
        ), // ✅ Provides an initial state
        builder: (context, snapshot) {
          final quotes = snapshot.data?.data?.data ?? [];

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (quotes.isEmpty) {
            return const Center(child: Text('No quotes available'));
          }

          return ListView.builder(
            itemCount: quotes.length,
            itemBuilder: (context, index) {
              final quote = quotes[index];
              return ListTile(
                title: Text(quote.content ?? 'No content'),
                subtitle: Text(quote.author ?? 'Unknown'),
              );
            },
          );
        },
      ),
    );
  }
}
