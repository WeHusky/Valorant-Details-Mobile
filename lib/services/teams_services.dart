import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tugas_akhir_valorant/model/teams_models.dart';

class TeamsService {
  final String baseUrl = 'https://vlr.orlandomm.net/api/v1/teams';

  Future<Map<String, List<TeamModel>>> fetchTeamsByRegion() async {
    final Map<String, List<TeamModel>> regionTeams = {
      'North America (NA)': [],
      'Europe (EU)': [],
      'Asia-Pacific (APAC)': [],
      'Korea': [],
      'Japan': [],
      'South America': [],
      'India/Southeast Asia': [],
      'Middle East/North Africa (MENA)': [],
      'Other': [],
    };

    try {
      bool hasNext = true;
      int currentPage = 1;

      while (hasNext) {
        final response = await http.get(Uri.parse('$baseUrl?page=$currentPage'));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          if (data['data'] == null) break;

          final List teams = data['data'];

          for (var t in teams) {
            final team = TeamModel.fromJson(t);
            final region = _mapCountryToRegion(team.country);
            regionTeams[region]?.add(team);
          }

          hasNext = data['pagination']?['hasNextPage'] ?? false;
          currentPage++;
        } else {
          print('⚠️ Failed to load page $currentPage (status: ${response.statusCode})');
          hasNext = false; // berhenti biar gak infinite loop
        }
      }
    } catch (e) {
      print('❌ Error fetching teams by region: $e');
    }

    return regionTeams;
  }

  /// 🧭 Fungsi bantu untuk mapping negara ke region besar
  String mapCountryToRegion(String country) => _mapCountryToRegion(country);

  String _mapCountryToRegion(String country) {
    final c = (country ?? '').toLowerCase();

    if (c.contains('america') || c.contains('usa') || c.contains('canada')) {
      return 'North America (NA)';
    } else if (c.contains('europe') ||
        c.contains('turkey') ||
        c.contains('uk') ||
        c.contains('germany') ||
        c.contains('france')) {
      return 'Europe (EU)';
    } else if (c.contains('asia') ||
        c.contains('pacific') ||
        c.contains('indonesia') ||
        c.contains('malaysia') ||
        c.contains('philippines') ||
        c.contains('singapore') ||
        c.contains('thailand') ||
        c.contains('vietnam')) {
      return 'Asia-Pacific (APAC)';
    } else if (c.contains('japan')) {
      return 'Japan';
    } else if (c.contains('korea')) {
      return 'Korea';
    } else if (c.contains('south america') ||
        c.contains('brazil') ||
        c.contains('chile') ||
        c.contains('argentina')) {
      return 'South America';
    } else if (c.contains('india') || c.contains('southeast')) {
      return 'India/Southeast Asia';
    } else if (c.contains('middle east') ||
        c.contains('mena') ||
        c.contains('saudi') ||
        c.contains('egypt')) {
      return 'Middle East/North Africa (MENA)';
    } else {
      return 'Other';
    }
  }
}
