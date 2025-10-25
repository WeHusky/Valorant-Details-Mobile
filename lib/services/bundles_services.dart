import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tugas_akhir_valorant/model/bundles_models.dart';

class BundlesService {
  final String baseUrl = 'https://valorant-api.com/v1/bundles';

  Future<List<BundlesModel>> fetchBundles() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null) {
          final List bundles = data['data'];
          return bundles.map((e) => BundlesModel.fromJson(e)).toList();
        } else {
          return [];
        }
      } else {
        throw Exception('Failed to load bundles (status: ${response.statusCode})');
      }
    } catch (e) {
      print('Error fetching bundles: $e');
      return [];
    }
  }
}
