import 'package:flutter/foundation.dart';

import '../../data/models/imported_stats.dart';

class ImportedStatsStore extends ChangeNotifier {
  ImportedStatsStore._();

  static final ImportedStatsStore instance = ImportedStatsStore._();

  ImportedUserStats? _stats;

  ImportedUserStats? get stats => _stats;

  bool get hasImported => _stats != null;

  void handleImport(ImportedUserStats? stats) {
    _stats = stats;
    notifyListeners();
  }

  void clear() => handleImport(null);
}