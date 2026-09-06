import 'package:flutter/services.dart';

import '../models/raw_import_data.dart';
import '../services/csv_parser.dart';
import 'import_data_source.dart';

class BundleImportDataSource implements ImportDataSource {
  BundleImportDataSource({AssetBundle? bundle})
    : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;

  static const List<String> _files = [
    ImportTables.trackingEpisodes,
    ImportTables.trackingMovies,
    ImportTables.watchedEpisodes,
    ImportTables.comments,
    ImportTables.ratingsEpisodes,
    ImportTables.ratingsMovies,
    ImportTables.followedShows,
  ];

  @override
  Future<RawImportData> load() async {
    const parser = CsvParser();
    final tables = <String, List<Map<String, String>>>{};
    for (final file in _files) {
      final content = await _bundle.loadString('assets/import/$file.csv');
      tables[file] = parser.parse(content);
    }
    return RawImportData(tables: tables);
  }
}