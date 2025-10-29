import 'package:flutter/material.dart';
import 'package:tugas_akhir_valorant/model/agent_models.dart';

class AgentDetailPage extends StatefulWidget {
  final AgentModel agent;
  const AgentDetailPage({super.key, required this.agent});

  @override
  State<AgentDetailPage> createState() => _AgentDetailPageState();
}

class _AgentDetailPageState extends State<AgentDetailPage>
    with SingleTickerProviderStateMixin {
  int _selectedAbility = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();
  }

  void _onAbilityTap(int index) {
    _fadeController.reverse().then((_) {
      setState(() => _selectedAbility = index);
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final agent = widget.agent;
    final abilities = agent.abilities
        .where((a) => a.displayIcon != null)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0F1823),
      body: Stack(
        children: [
          /// Background image agent
          Positioned.fill(
            child: Hero(
              tag: agent.displayName,
              child: Image.network(
                agent.fullPortrait,
                fit: BoxFit.cover,
                color: Colors.black.withOpacity(0.25),
                colorBlendMode: BlendMode.darken,
              ),
            ),
          ),

          /// Tombol kembali
          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          /// Kontainer info bawah
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.1),
                  end: Offset.zero,
                ).animate(_fadeController),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Color(0xFF0F1923),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// ROLE
                      Row(
                        children: [
                          Image.network(
                            agent.role.displayIcon!,
                            width: 24,
                            height: 24,
                            color: const Color(0xFFE94057),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            agent.role.displayName.toUpperCase(),
                            style: const TextStyle(
                              fontFamily: 'Tungsten',
                              fontSize: 22,
                              color: Colors.white70,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      /// NAMA AGENT
                      Text(
                        agent.displayName.toUpperCase(),
                        style: const TextStyle(
                          fontFamily: 'Tungsten',
                          fontSize: 56,
                          color: Colors.white,
                          letterSpacing: 3,
                        ),
                      ),
                      const SizedBox(height: 8),

                      /// DESKRIPSI
                      Text(
                        agent.description,
                        style: const TextStyle(
                          fontFamily: 'Rajdhani',
                          fontSize: 15,
                          color: Colors.white70,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 24),

                      /// ICON ABILITIES
                      Row(
                        children: List.generate(abilities.length, (index) {
                          final ability = abilities[index];
                          final isSelected = _selectedAbility == index;

                          return GestureDetector(
                            onTap: () => _onAbilityTap(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: const EdgeInsets.only(right: 12),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFE94057).withOpacity(0.15)
                                    : Colors.white.withOpacity(0.05),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFFE94057)
                                      : Colors.white30,
                                  width: 1.6,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Image.network(
                                ability.displayIcon,
                                width: 36,
                                height: 36,
                                color: Colors.white,
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 20),

                      /// DETAIL ABILITY
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        transitionBuilder: (child, animation) =>
                            FadeTransition(opacity: animation, child: child),
                        child: Container(
                          key: ValueKey(_selectedAbility),
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white24,
                              width: 1.2,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// NAMA ABILITY
                              Text(
                                abilities[_selectedAbility].displayName
                                    .toUpperCase(),
                                style: const TextStyle(
                                  fontFamily: 'Tungsten',
                                  fontSize: 22,
                                  color: Color(0xFFE94057),
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 6),

                              /// PENJELASAN ABILITY
                              Text(
                                abilities[_selectedAbility].description,
                                style: const TextStyle(
                                  fontFamily: 'Rajdhani',
                                  fontSize: 15,
                                  color: Colors.white70,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      /// TOMBOL LOCK IN
                      Center(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE94057),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 70,
                              vertical: 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "LOCK IN",
                            style: TextStyle(
                              fontFamily: 'Tungsten',
                              fontSize: 22,
                              letterSpacing: 2,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
