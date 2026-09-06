import '../models/imported_content.dart';
import '../models/imported_stats.dart';
import '../services/imported_history_mapper.dart';
import '../services/imported_stats_calculator.dart';
import '../sources/bundle_import_data_source.dart';
import '../sources/import_data_source.dart';

abstract class ImportedStatsRepository {
  Future<ImportedUserStats> importStats();

  Future<ImportedContentHistory> importHistory();
}

class LocalDatasetImportRepository implements ImportedStatsRepository {
  LocalDatasetImportRepository({
    ImportDataSource? source,
    ImportedStatsCalculator? calculator,
    ImportedHistoryMapper? mapper,
  }) : _source = source ?? BundleImportDataSource(),
       _calculator = calculator ?? const ImportedStatsCalculator(),
       _mapper = mapper ?? const ImportedHistoryMapper();

  final ImportDataSource _source;
  final ImportedStatsCalculator _calculator;
  final ImportedHistoryMapper _mapper;

  @override
  Future<ImportedUserStats> importStats() async {
    final data = await _source.load();
    return _calculator.calculate(data);
  }

  @override
  Future<ImportedContentHistory> importHistory() async {
    final data = await _source.load();
    return _mapper.map(data);
  }
}