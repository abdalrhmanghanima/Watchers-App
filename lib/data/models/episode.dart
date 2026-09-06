import 'cast_member.dart';

class Episode {
  const Episode({
    required this.number,
    required this.title,
    required this.duration,
    required this.synopsis,
    required this.watched,
    required this.airDate,
    this.id,
    this.imageUrl,
    this.cast = const [],
  });

  final int number;
  final String title;
  final int duration;
  final String synopsis;
  final bool watched;
  final String airDate;
  final String? id;
  final String? imageUrl;
  final List<CastMember> cast;
}
