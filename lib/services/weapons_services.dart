import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tugas_akhir_valorant/model/weapons_model.dart';

class WeaponService {
  final String baseUrl = 'https://valorant-api.com/v1/weapons';

  Future<List<WeaponsModel>> getWeapons() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List weaponList = data['data'];
      return weaponList.map((item) => WeaponsModel.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat data senjata dari Valorant API');
    }
  }
}
