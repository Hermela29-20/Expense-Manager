import 'package:dio/dio.dart';
import '../models/expense_model.dart';

class ApiService {
  final Dio _dio = Dio();

  final String _baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  // GET
  Future<List<Expense>> fetchExpenses() async {
    try {
      final response = await _dio.get(_baseUrl);
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;

        return data.take(10).map((json) {
          return Expense(
            id: json['id'].toString(),
            title: json['title'],
            amount: 29.99,
            category: 'General',
          );
        }).toList();
      }
      throw Exception('Failed to load data');
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  // POST
  Future<Expense> addExpense(Expense expense) async {
    try {
      final response = await _dio.post(
        _baseUrl,
        data: {
          'title': expense.title,
          'body': 'Amount: ${expense.amount}, Category: ${expense.category}',
          'userId': 1,
        },
      );

      if (response.statusCode == 201) {
        return Expense(
          id: response.data['id'].toString(),
          title: expense.title,
          amount: expense.amount,
          category: expense.category,
        );
      }
      throw Exception('Failed to create data');
    } catch (e) {
      throw Exception('Error adding data: $e');
    }
  }

  // PUT
  Future<Expense> updateExpense(Expense expense) async {
    try {
      final response = await _dio.put(
        '$_baseUrl/${expense.id}',
        data: {
          'id': expense.id,
          'title': expense.title,
          'body': 'Amount: ${expense.amount}, Category: ${expense.category}',
          'userId': 1,
        },
      );

      if (response.statusCode == 200) {
        return expense; // Return the updated object
      }
      throw Exception('Failed to update data');
    } catch (e) {
      throw Exception('Error updating data: $e');
    }
  }

  // DELETE:
  Future<void> deleteExpense(String id) async {
    try {
      final response = await _dio.delete('$_baseUrl/$id');
      if (response.statusCode != 200) {
        throw Exception('Failed to delete data');
      }
    } catch (e) {
      throw Exception('Error deleting data: $e');
    }
  }
}
