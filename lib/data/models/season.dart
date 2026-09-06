import 'episode.dart';

class Season {
  const Season({required this.number, required this.episodes});

  final int number;
  final List<Episode> episodes;
}
