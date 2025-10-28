class TeamModel {
  final String id;
  final String url;
  final String name;
  final String img;
  final String country;
  final String? region;

  TeamModel({
    required this.id,
    required this.url,
    required this.name,
    required this.img,
    required this.country,
    required this.region,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      id: json['id'] ?? '',
      url: json['url'] ?? '',
      name: json['name'] ?? '',
      img: json['img'] ?? '',
      country: json['country'] ?? '',
      region: json['region'] ?? json['country'] ?? '',
    );
  }
}

class TeamsResponse {
  final String status;
  final String region;
  final int size;
  final Pagination pagination;
  final List<TeamModel> data;

  TeamsResponse({
    required this.status,
    required this.region,
    required this.size,
    required this.pagination,
    required this.data,
  });

  factory TeamsResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List? ?? [];
    return TeamsResponse(
      status: json['status'] ?? '',
      region: json['region'] ?? '',
      size: json['size'] ?? 0,
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
      data: list.map((e) => TeamModel.fromJson(e)).toList(),
    );
  }
}

class Pagination {
  final int page;
  final int limit;
  final int totalElements;
  final int totalPages;
  final bool hasNextPage;

  Pagination({
    required this.page,
    required this.limit,
    required this.totalElements,
    required this.totalPages,
    required this.hasNextPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json['page'] ?? 0,
      limit: json['limit'] ?? 0,
      totalElements: json['totalElements'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      hasNextPage: json['hasNextPage'] ?? false,
    );
  }
}
