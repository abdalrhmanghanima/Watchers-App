import '../models/search_result.dart';
import '../repositories/content_repository.dart';

class ImportedTitleMatch {
  const ImportedTitleMatch({
    required this.id,
    required this.title,
    required this.type,
  });

  final String id;
  final String title;
  final ContentType type;
}

abstract class ImportedTitleMatcher {
  Future<ImportedTitleMatch?> matchShow(String title);

  Future<ImportedTitleMatch?> matchMovie(String title);
}

class RepositoryTitleMatcher implements ImportedTitleMatcher {
  RepositoryTitleMatcher(this._repository);

  final ContentRepository _repository;

  static String _normalize(String value) => value.trim().toLowerCase();

  @override
  Future<ImportedTitleMatch?> matchShow(String title) async {
    final query = _normalize(title);
    if (query.isEmpty) return null;
    final results = await _repository.search(title);
    for (final result in results) {
      if (result.type == ContentType.show &&
          _normalize(result.title) == query) {
        return ImportedTitleMatch(
          id: result.id,
          title: result.title,
          type: result.type,
        );
      }
    }
    return null;
  }

  @override
  Future<ImportedTitleMatch?> matchMovie(String title) async {
    final query = _normalize(title);
    if (query.isEmpty) return null;
    final results = await _repository.search(title);
    for (final result in results) {
      if (result.type == ContentType.movie &&
          _normalize(result.title) == query) {
        return ImportedTitleMatch(
          id: result.id,
          title: result.title,
          type: result.type,
        );
      }
    }
    return null;
  }
}