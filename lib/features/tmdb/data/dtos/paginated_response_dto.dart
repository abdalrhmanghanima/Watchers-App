class PaginatedResponseDto<T> {
  const PaginatedResponseDto({
    required this.items,
    required this.page,
    required this.totalPages,
    required this.totalResults,
  });

  final List<T> items;
  final int page;
  final int totalPages;
  final int totalResults;

  factory PaginatedResponseDto.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) itemParser,
  ) {
    final rawItems = json['results'];
    final items = rawItems is List
        ? rawItems.whereType<Map>().map((e) {
            return itemParser(Map<String, dynamic>.from(e));
          }).toList()
        : <T>[];
    return PaginatedResponseDto(
      items: items,
      page: json['page'] as int? ?? 1,
      totalPages: json['total_pages'] as int? ?? 0,
      totalResults: json['total_results'] as int? ?? 0,
    );
  }
}
