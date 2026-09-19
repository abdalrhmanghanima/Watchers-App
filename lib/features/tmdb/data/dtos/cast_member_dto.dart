class CastMemberDto {
  const CastMemberDto({
    required this.id,
    required this.name,
    required this.character,
    required this.order,
    this.profilePath,
  });

  final int id;
  final String name;
  final String character;
  final int order;
  final String? profilePath;

  factory CastMemberDto.fromJson(Map<String, dynamic> json) {
    return CastMemberDto(
      id: _toInt(json['id']) ?? 0,
      name: json['name'] as String? ?? '',
      character: json['character'] as String? ?? '',
      order: _toInt(json['order']) ?? 0,
      profilePath: json['profile_path'] as String?,
    );
  }

  static int? _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return null;
  }
}