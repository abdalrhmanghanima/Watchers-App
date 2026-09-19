class TmdbCastMember {
  const TmdbCastMember({
    required this.id,
    required this.name,
    required this.character,
    required this.order,
    this.profileUrl,
  });

  final int id;
  final String name;
  final String character;
  final int order;
  final String? profileUrl;
}