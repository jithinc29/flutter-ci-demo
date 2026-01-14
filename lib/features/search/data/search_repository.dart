import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchRepository {
  final String apiKey = 'a909d2d4e2msh6666bbe08bbdb4ep1a2b0ejsnd2a5a326bf5c';
  final String baseUrl = 'https://booking-com15.p.rapidapi.com/api/v1/hotels';

  Future<String> getDestinationId(String query) async {
    final url = Uri.parse('$baseUrl/searchDestination');
    final headers = {
      'X-RapidAPI-Key': apiKey,
      'X-RapidAPI-Host': 'booking-com15.p.rapidapi.com',
    };
    final params = {
      'query': query,
    };

    final response = await http.get(url.replace(queryParameters: params), headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Destination search response: $data'); // Debug
      if (data['data'] != null && data['data'].isNotEmpty) {
        return data['data'][0]['dest_id'];
      }
    }
    throw Exception('Destination not found. Try a more specific query like "Paris, France". Response: ${response.body}');
  }

  Future<List<dynamic>> searchHotels({
    required String checkinDate,
    required String checkoutDate,
    required String destId,
    int adultsNumber = 1,
    int roomNumber = 1,
  }) async {
    final url = Uri.parse('$baseUrl/searchHotels');
    final headers = {
      'X-RapidAPI-Key': apiKey,
      'X-RapidAPI-Host': 'booking-com15.p.rapidapi.com',
    };
    final params = {
      'dest_id': destId,
      'search_type': 'CITY',
      'arrival_date': checkinDate,
      'departure_date': checkoutDate,
      'adults_number': adultsNumber.toString(),
      'room_number': roomNumber.toString(),
      'locale': 'en-gb',
      'currency_code': 'USD',
      'order_by': 'popularity',
      'units': 'metric',
    };

    final response = await http.get(url.replace(queryParameters: params), headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Hotel search response: $data'); // Debug
      if (data['data'] != null && data['data']['hotels'] != null) {
        return data['data']['hotels'];
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load hotels: ${response.statusCode} - ${response.body}');
    }
  }
}