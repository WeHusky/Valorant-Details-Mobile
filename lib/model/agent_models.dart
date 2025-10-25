class AgentModel {
  final String displayName;
  final String description;
  final String fullPortrait;
  final RoleModel role;
  final List<AbilityModel> abilities;

  AgentModel({
    required this.displayName,
    required this.description,
    required this.fullPortrait,
    required this.role,
    required this.abilities,
  });

  factory AgentModel.fromJson(Map<String, dynamic> json) {
    return AgentModel(
      displayName: json['displayName'] ?? "-",
      description: json['description'] ?? "-",
      fullPortrait: json['fullPortrait'] ?? "",
      role: json['role'] != null
          ? RoleModel.fromJson(json['role'])
          : RoleModel.empty(),
      abilities: (json['abilities'] as List<dynamic>?)
              ?.map((ability) => AbilityModel.fromJson(ability))
              .toList() ??
          [],
    );
  }
}

class RoleModel {
  final String displayName;
  final String description;
  final String displayIcon;

  RoleModel({
    required this.displayName,
    required this.description,
    required this.displayIcon,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      displayName: json['displayName'] ?? "-",
      description: json['description'] ?? "-",
      displayIcon: json['displayIcon'] ?? "",
    );
  }

  factory RoleModel.empty() {
    return RoleModel(
      displayName: "-",
      description: "-",
      displayIcon: "",
    );
  }
}

class AbilityModel {
  final String slot;
  final String displayName;
  final String description;
  final String displayIcon;

  AbilityModel({
    required this.slot,
    required this.displayName,
    required this.description,
    required this.displayIcon,
  });

  factory AbilityModel.fromJson(Map<String, dynamic> json) {
    return AbilityModel(
      slot: json['slot'] ?? "-",
      displayName: json['displayName'] ?? "-",
      description: json['description'] ?? "-",
      displayIcon: json['displayIcon'] ?? "",
    );
  }
}
