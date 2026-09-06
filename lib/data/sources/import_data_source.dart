import '../models/raw_import_data.dart';

abstract class ImportDataSource {
  Future<RawImportData> load();
}