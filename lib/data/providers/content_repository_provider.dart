import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/show.dart';
import '../repositories/content_repository.dart';
import '../sources/mock_content_repository.dart';

final contentRepositoryProvider = Provider<ContentRepository>(
  (_) => MockContentRepository(),
);

final userShowsProvider = FutureProvider<List<Show>>((ref) {
  return ref.watch(contentRepositoryProvider).getShows();
});