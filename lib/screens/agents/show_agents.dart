import 'package:flutter/material.dart';
import 'package:tugas_akhir_valorant/model/agent_models.dart';
import 'package:tugas_akhir_valorant/services/agent_services.dart';
import 'package:tugas_akhir_valorant/screens/agents/agents_detail.dart';

class ShowAgentPage extends StatefulWidget {
  const ShowAgentPage({super.key});

  @override
  State<ShowAgentPage> createState() => _ShowAgentPageState();
}

class _ShowAgentPageState extends State<ShowAgentPage> {
  final AgentService _agentService = AgentService();
  final TextEditingController searchTextController = TextEditingController();

  late Future<List<AgentModel>> _futureAgents;
  List<AgentModel> allAgents = [];
  List<AgentModel> filteredAgents = [];

  @override
  void initState() {
    super.initState();
    _futureAgents = _agentService.getAgents();
    _loadAgents();
    searchTextController.addListener(_applySearchFilter);
  }

  /// Ambil data agent dari API
  Future<void> _loadAgents() async {
    try {
      final agentData = await _agentService.getAgents();
      setState(() {
        allAgents = agentData;
        filteredAgents = agentData;
      });
    } catch (e) {
      debugPrint("Error loading agents: $e");
    }
  }

  /// Filter agent berdasarkan teks pencarian
  void _applySearchFilter() {
    final query = searchTextController.text.toLowerCase();

    setState(() {
      filteredAgents = allAgents.where((agent) {
        return agent.displayName.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1823),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "VALORANT AGENTS",
          style: TextStyle(
            fontFamily: 'Teko',
            fontSize: 28,
            letterSpacing: 2,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<AgentModel>>(
        future: _futureAgents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF4655)),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Terjadi kesalahan: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          return Column(
            children: [
              _buildSearchBar(),
              Expanded(
                child: filteredAgents.isEmpty
                    ? const Center(
                        child: Text(
                          'Tidak ada Agent ditemukan.',
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                    : _buildAgentGrid(filteredAgents),
              ),
            ],
          );
        },
      ),
    );
  }

  /// 🔍 Widget search bar
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: searchTextController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Cari Agent...',
          hintStyle: const TextStyle(color: Colors.white54),
          prefixIcon: const Icon(Icons.search, color: Colors.white70),
          filled: true,
          fillColor: const Color(0xFF1B252F),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: Color(0xFFFF4655), width: 2),
          ),
        ),
      ),
    );
  }

  /// 🧱 Grid daftar agent
  Widget _buildAgentGrid(List<AgentModel> agents) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: agents.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // dua kolom
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, index) {
        final agent = agents[index];
        return _buildAgentCard(agent);
      },
    );
  }

  /// 💥 Kartu individual agent
  Widget _buildAgentCard(AgentModel agent) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AgentDetailPage(agent: agent),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Foto Agent
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Image.network(
                  agent.fullPortrait ?? "",
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.white.withOpacity(0.3),
                      size: 50,
                    );
                  },
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFFF4655),
                        strokeWidth: 2,
                      ),
                    );
                  },
                ),
              ),
            ),

            // Nama Agent
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFF4655).withOpacity(0.9),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
              ),
              child: Text(
                agent.displayName.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Teko',
                  fontSize: 20,
                  letterSpacing: 1.5,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
