import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiServices {
  Future<Map<String, dynamic>> addTransaction(Map<String, dynamic> item) async {
    Map<String, dynamic> responseRequest = {
      "messages": {
        "code": 1,
        "message": "Invalid Card Type",
      },
      "response": {}
    };
    try {
      final response = await http
          .post(
              Uri.parse(
                  "https://filipworks.com/api2/api/v1/filipay/transaction"),
              headers: {
                'Authorization':
                    'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiZnVuY3Rpb24gbm93KCkgeyBbbmF0aXZlIGNvZGVdIH0iLCJpYXQiOjE2OTcwOTcyNjl9.tT7GdpjGqGRRuP83ts2Ok2arhVu8sAyFKWjd8M7do9k',
                'Content-Type': 'application/json',
                // Add other headers if needed`
              },
              body: jsonEncode(item))
          .timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        // Successful response
        responseRequest = json.decode(response.body);
        print('addTransaction response: $responseRequest');
        if (responseRequest['messages']['code'].toString() == "0") {
          return responseRequest;
        } else {
          return responseRequest;
        }
      } else {
        // Handle error responses
        print('addTransaction response Error: ${response.statusCode}');
        print('addTransaction Response body: ${response.body}');
        return responseRequest;
      }
    } catch (e) {
      print('addtransaction error: $e');
      return responseRequest;
    }
  }

  Future<Map<String, dynamic>> updateTransaction(
      Map<String, dynamic> item) async {
    Map<String, dynamic> responseRequest = {
      "messages": {
        "code": 1,
        "message": "Invalid Card Type",
      },
      "response": {}
    };
    try {
      final response = await http
          .put(
              Uri.parse(
                  "https://filipworks.com/api2/api/v1/filipay/transaction/${item['ticketNumber']}"),
              headers: {
                'Authorization':
                    'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiZnVuY3Rpb24gbm93KCkgeyBbbmF0aXZlIGNvZGVdIH0iLCJpYXQiOjE2OTcwOTcyNjl9.tT7GdpjGqGRRuP83ts2Ok2arhVu8sAyFKWjd8M7do9k',
                'Content-Type': 'application/json',
                // Add other headers if needed`
              },
              body: jsonEncode(item))
          .timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        // Successful response
        responseRequest = json.decode(response.body);
        print('updateTransaction response: $responseRequest');
        if (responseRequest['messages']['code'].toString() == "0") {
          return responseRequest;
        } else {
          return responseRequest;
        }
      } else {
        // Handle error responses
        print('updateTransaction response Error: ${response.statusCode}');
        print('updateTransaction Response body: ${response.body}');
        return responseRequest;
      }
    } catch (e) {
      print('updateTransaction error: $e');
      return responseRequest;
    }
  }
}
