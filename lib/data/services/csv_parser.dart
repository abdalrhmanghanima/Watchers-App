class CsvParser {
  const CsvParser();

  List<Map<String, String>> parse(String input) {
    final rows = _parseRows(input);
    if (rows.isEmpty) return const [];
    final header = rows.first;
    return [
      for (var r = 1; r < rows.length; r++)
        {
          for (var c = 0; c < header.length; c++)
            header[c]: c < rows[r].length ? rows[r][c] : '',
        },
    ];
  }

  List<List<String>> _parseRows(String input) {
    final rows = <List<String>>[];
    var row = <String>[];
    final buffer = StringBuffer();
    var inQuotes = false;
    var i = 0;
    while (i < input.length) {
      final char = input[i];
      if (inQuotes) {
        if (char == '"') {
          if (i + 1 < input.length && input[i + 1] == '"') {
            buffer.write('"');
            i += 2;
            continue;
          }
          inQuotes = false;
          i += 1;
          continue;
        }
        buffer.write(char);
        i += 1;
        continue;
      }
      if (char == '"') {
        inQuotes = true;
        i += 1;
        continue;
      }
      if (char == ',') {
        row.add(buffer.toString());
        buffer.clear();
        i += 1;
        continue;
      }
      if (char == '\r' || char == '\n') {
        row.add(buffer.toString());
        buffer.clear();
        if (char == '\r' && i + 1 < input.length && input[i + 1] == '\n') {
          i += 1;
        }
        if (row.length != 1 || row.single.isNotEmpty) {
          rows.add(row);
        }
        row = <String>[];
        i += 1;
        continue;
      }
      buffer.write(char);
      i += 1;
    }
    if (buffer.isNotEmpty || row.isNotEmpty) {
      row.add(buffer.toString());
      rows.add(row);
    }
    return rows;
  }
}