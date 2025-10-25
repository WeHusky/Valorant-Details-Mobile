import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tugas_akhir_valorant/model/agent_models.dart'; 

class AgentService {
  final String baseUrl = 'https://valorant-api.com/v1';

  Future<List<AgentModel>> getAgents() async {
    final String fullUrl = '$baseUrl/agents';
    final response = await http.get(Uri.parse(fullUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List agents = data['data'];
      List playableAgents = agents.where((a) => a['isPlayableCharacter'] == true).toList();

      return playableAgents.map((v) => AgentModel.fromJson(v)).toList();
    } else {
      throw Exception('Gagal memuat data agents');
    }
  }
}
