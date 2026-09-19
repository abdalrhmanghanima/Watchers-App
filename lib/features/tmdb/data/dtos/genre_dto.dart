class GenreDto {
  const GenreDto({required this.id, required this.name});

  final int id;
  final String name;

  factory GenreDto.fromJson(Map<String, dynamic> json) {
    return GenreDto(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
    );
  }
}
