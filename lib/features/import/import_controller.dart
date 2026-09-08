import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/imported_stats.dart';
import '../../data/repositories/imported_stats_repository.dart';
import 'imported_stats_store.dart';

final importRepositoryProvider = Provider<ImportedStatsRepository>(
  (_) => LocalDatasetImportRepository(),
);

class ImportController extends AsyncNotifier<ImportedUserStats?> {
  @override
  Future<ImportedUserStats?> build() async => null;

  Future<bool> import() async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref.read(importRepositoryProvider).importStats(),
    );
    state = result;
    if (result.hasValue) {
      ImportedStatsStore.instance.handleImport(result.value);
    }
    return result.hasValue;
  }
}

final importControllerProvider =
    AsyncNotifierProvider<ImportController, ImportedUserStats?>(
  ImportController.new,
);