import 'dart:convert';
import 'dart:io';

import 'package:api_course/models/get/get_product.dart';
import 'package:api_course/models/get/get_quotes.dart';
import 'package:api_course/models/get/get_users_list.dart';
import 'package:api_course/models/post/create_job_response.dart';
import 'package:api_course/models/post/register_response.dart';
import 'package:api_course/models/put/update_product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  // GET API SERVICES
  Future<GetUsersListModel?> getUsersList(String page) async {
    try {
      // response in object form
      var response = await http.get(
        Uri.parse("https://reqres.in/api/users?page=$page"),
        headers: {"My-Header": "Data"},
      );

      if (response.statusCode == 200) {
        GetUsersListModel getUsersListModel = GetUsersListModel.fromJson(
          jsonDecode(response.body),
        );
        return getUsersListModel;
      }
    } catch (err) {
      print(err.toString());
    }
    return null;
  }

  Future<List<Product>?> getProductsList([String? token]) async {
    try {
      // response in list form
      var response = await http.get(
        Uri.parse("https://fakestoreapi.com/products"),
      );

      // print(response);

      if (response.statusCode == 200) {
        List<Product> getProductsListModel = List<Product>.from(
          jsonDecode(response.body).map((product) => Product.fromJson(product)),
        );
        // print(getProductsListModel);
        return getProductsListModel;
      }
    } catch (err) {
      print(err.toString());
    }
    return null;
  }

  Future<dynamic> getUsersWithoutModel() async {
    try {
      var response = await http.get(
        Uri.parse("https://reqres.in/api/users?page=2"),
      );
      // print("api service ${response.statusCode} : ${response.body}");
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        return data;
      }
    } catch (error) {
      print(error.toString());
    }
    return null;
  }

  Future<QuotesResponse> getQuotesResponse() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.freeapi.app/api/v1/public/quotes?page=1&limit=10&query=human',
        ),
      );

      if (response.statusCode == 200) {
        final decodedBody = jsonDecode(response.body);
        return QuotesResponse.fromJson(decodedBody);
      } else {
        // Here we throw an exception, making error handling clear
        throw HttpException(
          'Request failed with status: ${response.statusCode}',
        );
      }
    } catch (error, stack) {
      // Log error for debugging
      debugPrint('Error in getQuotesResponse: $error\n$stack');

      // Here we can either:
      // A) Re-throw the error for the caller to handle
      throw Exception('Error getting quotes: $error');

      // OR
      // B) Return an empty QuotesResponse if you don’t want to crash
      // return QuotesResponse(data: Quotes(data: []));
    }
  }

  // POST API SERVICES
  Future<CreatejobResponse> createJob(Map userJobInfo) async {
    final jsonEncodedBody = jsonEncode({
      "name": userJobInfo["name"],
      "job": userJobInfo["job"],
    });

    try {
      final result = await http.post(
        Uri.parse("https://reqres.in/api/users"),
        headers: {"x-api-key": "reqres-free-v1"},
        body: jsonEncodedBody,
      );

      if (result.statusCode == 201) {
        final decodedBody = jsonDecode(result.body);
        return CreatejobResponse.fromJson(decodedBody);
      } else {
        throw HttpException('Request failed with status: ${result.statusCode}');
      }
    } catch (err, stack) {
      debugPrint('Error in createJob: $err\n$stack');
      throw Exception('Error in post request : $err');
    }
  }

  Future<RegisterApiResponse> registerUser({
    required String email,
    required String password,
    required String username,
    required String role,
  }) async {
    const baseUrl = 'https://api.freeapi.app/api/v1/users/register';
    const Map<String, String> headers = {'Content-Type': 'application/json'};
    try {
      final url = Uri.parse(baseUrl);
      final body = jsonEncode({
        'email': email,
        'password': password,
        'username': username,
        'role': role,
      });

      final response = await http.post(url, headers: headers, body: body);
      print(response.body);
      if (response.statusCode == 201) {
        return RegisterApiResponse.fromJson(jsonDecode(response.body));
      } else {
        final errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['message'] ?? 'Registration failed');
      }
    }
    // on http.ClientException catch (e) {
    //   throw Exception('Network error: ${e.message}');
    // } on FormatException {
    //   throw Exception('Invalid response format');
    catch (e) {
      throw Exception('Unexpected error: ${e.toString()}');
    }
  }

  // PUT SERVICES
  Future<PutProduct> updateProduct(PutProduct product) async {
    try {
      final url = Uri.parse('https://fakestoreapi.com/products/${product.id}');
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(product.toJson()),
      );

      if (response.statusCode == 200) {
        return PutProduct.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 400) {
        throw Exception('Bad request: Invalid product data');
      } else {
        throw Exception('Failed to update product: ${response.statusCode}');
      }
    } catch (err, stack) {
      throw Exception(
        'Failed to update product: ${err.toString()} \n ${stack.toString()}',
      );
    }
  }

  // PATCH SERVICES

  // DELETE SERVICES
}
