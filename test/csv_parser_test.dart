import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/data/services/csv_parser.dart';

void main() {
  const parser = CsvParser();

  test('parses a header plus simple rows', () {
    const input = 'name,age\nA,1\nB,2\n';
    final rows = parser.parse(input);
    expect(rows, hasLength(2));
    expect(rows[0], {'name': 'A', 'age': '1'});
    expect(rows[1], {'name': 'B', 'age': '2'});
  });

  test('leaves blank trailing fields as empty strings', () {
    const input = 'name,age\nA,\n';
    final rows = parser.parse(input);
    expect(rows.single['age'], isEmpty);
  });

  test('handles quoted fields containing commas', () {
    const input = 'title,note\n"The Count, of Monte Cristo",ok\n';
    final rows = parser.parse(input);
    expect(rows.single['title'], 'The Count, of Monte Cristo');
    expect(rows.single['note'], 'ok');
  });

  test('handles escaped quotes inside quoted fields', () {
    const input = 'body\n"He said ""hi"""\n';
    final rows = parser.parse(input);
    expect(rows.single['body'], 'He said "hi"');
  });

  test('handles CRLF line endings', () {
    const input = 'a,b\r\n1,2\r\n3,4\r\n';
    final rows = parser.parse(input);
    expect(rows, hasLength(2));
    expect(rows[1], {'a': '3', 'b': '4'});
  });

  test('does not split on newlines inside quoted fields', () {
    const input = 'a,b\n"line one\nline two",x\n';
    final rows = parser.parse(input);
    expect(rows, hasLength(1));
    expect(rows.single['a'], 'line one\nline two');
  });

  test('supplies empty strings for missing trailing columns', () {
    const input = 'a,b,c\n1,2\n';
    final rows = parser.parse(input);
    expect(rows.single, {'a': '1', 'b': '2', 'c': ''});
  });

  test('drops trailing empty lines', () {
    const input = 'a,b\n1,2\n\n\n';
    final rows = parser.parse(input);
    expect(rows, hasLength(1));
  });

  test('returns an empty list for an empty input', () {
    expect(parser.parse(''), isEmpty);
    expect(parser.parse('\n'), isEmpty);
  });
}