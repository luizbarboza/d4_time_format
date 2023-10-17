import 'dart:convert';
import 'dart:io';

import 'package:d4_time_format/d4_time_format.dart';
import 'package:test/test.dart';

void main() {
  test("locale data is valid", () async {
    for (var file in Directory("./test/locale/").listSync()) {
      Map<String, dynamic> locale =
          jsonDecode((file as File).readAsStringSync());
      expect(locale.keys.toList()..sort(), [
        "date",
        "dateTime",
        "days",
        "months",
        "periods",
        "shortDays",
        "shortMonths",
        "time"
      ]);
      TimeFormatLocale.fromJson(locale);
    }
  });
}
