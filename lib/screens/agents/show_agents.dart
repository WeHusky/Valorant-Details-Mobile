import 'package:flutter/material.dart';
import 'package:tugas_akhir_valorant/model/agent_models.dart';
import 'package:tugas_akhir_valorant/services/agent_services.dart';
import 'package:tugas_akhir_valorant/screens/agents/agents_detail.dart';

class ShowAgentsPage extends StatefulWidget {
  const ShowAgentsPage({super.key});

  @override
  State<ShowAgentsPage> createState() => _ShowAgentsPageState();
}

class _ShowAgentsPageState extends State<ShowAgentsPage> {
  final AgentService _agentService = AgentService();
  late Future<List<AgentModel>> _futureAgents;

  @override
  void initState() {
    super.initState();
    _futureAgents = _agentService.getAgents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1923),
      appBar: AppBar(
        title: const Text(
          'SELECT YOUR AGENT',
          style: TextStyle(
            fontFamily: 'Rajdhani',
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1B252F),
        elevation: 0,
      ),
      body: FutureBuilder<List<AgentModel>>(
        future: _futureAgents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFE94057)),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No agents found.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final agents = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.78,
            ),
            itemCount: agents.length,
            itemBuilder: (context, index) {
              final agent = agents[index];
              return AgentCard(agent: agent);
            },
          );
        },
      ),
    );
  }
}

class AgentCard extends StatefulWidget {
  final AgentModel agent;
  const AgentCard({super.key, required this.agent});

  @override
  State<AgentCard> createState() => _AgentCardState();
}

class _AgentCardState extends State<AgentCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 600),
            pageBuilder: (_, __, ___) => AgentDetailPage(agent: widget.agent),
          ),
        );
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: const Color(0xFF1B252F),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovered
                  ? const Color(0xFFE94057)
                  : Colors.white.withOpacity(0.15),
              width: 2,
            ),
            boxShadow: [
              if (_isHovered)
                BoxShadow(
                  color: const Color(0xFFE94057).withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
            ],
          ),
          child: Stack(
            children: [
              Hero(
                tag: widget.agent.displayName,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.agent.fullPortrait,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(Icons.error, color: Colors.redAccent),
                    ),
                  ),
                ),
              ),
              AnimatedOpacity(
                opacity: _isHovered ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      'CHOOSE',
                      style: TextStyle(
                        fontFamily: 'Rajdhani',
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFF0F1923),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Text(
                    widget.agent.displayName.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Rajdhani',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
