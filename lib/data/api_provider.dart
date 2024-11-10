import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tapintapout/core/utils.dart';

class ApiProvider {
  http.Client? _client = http.Client();
  bool _canceledFetchingFilipaycard = false;
  final String baseUrl =
      'https://filipworks.com/api2/api/v1/filipay'; // Replace with actual URL
  final String token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiZnVuY3Rpb24gbm93KCkgeyBbbmF0aXZlIGNvZGVdIH0iLCJpYXQiOjE2OTcwOTcyNjl9.tT7GdpjGqGRRuP83ts2Ok2arhVu8sAyFKWjd8M7do9k';

  Future<Map<String, dynamic>> login(
      String email, String password, String deviceId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/driver/auth'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(
            {'email': email, 'password': password, 'deviceId': deviceId}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Check if the expected 'response' field is present
        if (data.containsKey('response')) {
          return data;
        } else {
          return {
            "messages": {"code": 1, "message": "Something went wrong"},
            "response": {}
          };
        }
      } else {
        // Handle HTTP error responses
        return {
          "messages": {"code": 1, "message": "Something went wrong"},
          "response": {}
        };
      }
    } catch (e) {
      print('Error Login: $e');
      return {
        "messages": {"code": 1, "message": "Slow or No Internet Connection"},
        "response": {}
      };
    }
  }

  // login() {}

  Future<List<dynamic>> fetchRoutes() async {
    try {
      final response = await http.get(
          Uri.parse(
              '$baseUrl/directions/${coopInfoController.coopInfo.value?.id}'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          });
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('route data: ${data}');
        // Check if the expected 'response' field is present
        if (data.containsKey('response')) {
          return data['response'];
        } else {
          print('Invalid response format');
          throw Exception('Invalid response format');
        }
      } else {
        print(
            'Failed to load routes: ${response.statusCode} ${response.reasonPhrase}');
        // Handle HTTP error responses
        throw Exception(
            'Failed to load routes: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching routes: $e');
      return [];
    }
  }

  Future<List<dynamic>> fetchStations() async {
    try {
      final response = await http.get(
          Uri.parse(
              '$baseUrl/getMarkers/${coopInfoController.coopInfo.value?.id}'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          });
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey('response')) {
          return data['response'];
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception(
            'Failed to load stations: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching stations: $e');
      return [];
    }
  }

  Future<List<dynamic>> fetchFilipayCards() async {
    try {
      if (_client == null) {
        _client = http.Client();
      }
      final response = await _client?.get(
          Uri.parse('http://172.232.77.205:3000/api/v1/filipay/filipaycard'),
          headers: {
            'Authorization':
                'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiZnVuY3Rpb24gbm93KCkgeyBbbmF0aXZlIGNvZGVdIH0iLCJpYXQiOjE2OTcwOTcyNjl9.tT7GdpjGqGRRuP83ts2Ok2arhVu8sAyFKWjd8M7do9k',
            'Content-Type': 'application/json',
          });

      if (response?.statusCode == 200) {
        final data = json.decode(response!.body);
        if (data.containsKey('response')) {
          return data['response'];
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception(
            'Failed to load filipaycard: ${response?.statusCode} ${response?.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching fetchFilipayCards: $e');
      return [];
    }
  }

  Future<List<dynamic>> fetchVehicles() async {
    try {
      final response = await http.get(
          Uri.parse(
              'https://filipworks.com/api2/api/v1/filipay/vehicle/${coopInfoController.coopInfo.value?.id}'),
          headers: {
            'Authorization':
                'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiZnVuY3Rpb24gbm93KCkgeyBbbmF0aXZlIGNvZGVdIH0iLCJpYXQiOjE2OTcwOTcyNjl9.tT7GdpjGqGRRuP83ts2Ok2arhVu8sAyFKWjd8M7do9k',
            'Content-Type': 'application/json',
          });
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey('response')) {
          return data['response'];
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception(
            'Failed to load fetchVehicles: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching fetchVehicles: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> tapinTransaction(
      Map<String, dynamic> item) async {
    try {
      print('tapinTransaction: $item');
      final response = await http.post(
          Uri.parse('https://filipworks.com/api2/api/v1/filipay/transaction'),
          headers: {
            'Authorization':
                'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiZnVuY3Rpb24gbm93KCkgeyBbbmF0aXZlIGNvZGVdIH0iLCJpYXQiOjE2OTcwOTcyNjl9.tT7GdpjGqGRRuP83ts2Ok2arhVu8sAyFKWjd8M7do9k',
            'Content-Type': 'application/json',
          },
          body: json.encode(item));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception(
            'Failed tapinTransaction: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error tapinTransaction: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> tapoutTransaction(
      Map<String, dynamic> item) async {
    try {
      final response = await http.put(
          Uri.parse(
              'https://filipworks.com/api2/api/v1/filipay/transaction/${item['ticketNumber']}'),
          headers: {
            'Authorization':
                'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiZnVuY3Rpb24gbm93KCkgeyBbbmF0aXZlIGNvZGVdIH0iLCJpYXQiOjE2OTcwOTcyNjl9.tT7GdpjGqGRRuP83ts2Ok2arhVu8sAyFKWjd8M7do9k',
            'Content-Type': 'application/json',
          },
          body: json.encode(item));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception(
            'Failed tapinTransaction: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error tapoutTransaction: $e');
      return {};
    }
  }

  void cancelRequest() {
    _client?.close();
    _client = null;
    print('canceled filipaycard: $_client');
  }

  void openRequest() {
    if (_client == null) {
      _client = http.Client(); // Recreate the client if it was closed
      print('filipaycard Reopened the http client');
    } else {
      print('filipaycard Client is already open');
    }
  }
}
