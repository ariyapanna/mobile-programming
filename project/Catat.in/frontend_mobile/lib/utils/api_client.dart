import 'dart:convert';
import 'package:frontend_mobile/exceptions/api_exception.dart';
import 'package:http/http.dart' as http;

class ApiClient {
    final String baseUrl;
    final Map<String, String> defaultHeaders;

    ApiClient({
        required this.baseUrl,
        this.defaultHeaders = const {
            'Content-Type': 'application/json',
        },
    });

    Future<dynamic> get(String endpoint) async {
        final uri = Uri.parse('$baseUrl$endpoint');
        final response = await http.get(uri, headers: defaultHeaders);
        return _processResponse(response);
    }

    Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
        final uri = Uri.parse('$baseUrl$endpoint');
        final response = await http.post(uri, 
            headers: defaultHeaders, body: jsonEncode(body));
        return _processResponse(response);
    }

    Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
        final uri = Uri.parse('$baseUrl$endpoint');
        final response = await http.put(uri, 
            headers: defaultHeaders, body: jsonEncode(body));
        return _processResponse(response);
    }

    Future<dynamic> delete(String endpoint) async {
        final uri = Uri.parse('$baseUrl$endpoint');
        final response = await http.delete(uri, headers: defaultHeaders);
        return _processResponse(response);
    }

    dynamic _processResponse(http.Response response) {
        final jsonData = jsonDecode(response.body);
        if(response.statusCode >= 200 && response.statusCode < 300) 
        {
            return (response.body.isNotEmpty) ? jsonData : null;
        } 
        else 
        {
            throw ApiException(statusCode: response.statusCode, message: jsonData['message'] ?? 'Unknown error');
        }
    }
}
