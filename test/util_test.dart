import 'package:test/test.dart';
import 'package:fluminus/util.dart';

main() {
  group('DateTime formatters', () {
    test('datetimeToFormattedString', () {
      expect(datetimeToFormattedString(DateTime.fromMillisecondsSinceEpoch(1561630322209)), 'Thu, 27/6/2019 6:12 PM');
    });
  });
}
