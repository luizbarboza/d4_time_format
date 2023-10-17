import 'dart:convert';
import 'dart:io';

import 'package:d4_time_format/d4_time_format.dart';
import 'package:test/test.dart';

void main() {
  final enUs = jsonDecode(File("./test/locale/en-US.json").readAsStringSync());
  final frFr = jsonDecode(File("./test/locale/fr-FR.json").readAsStringSync());

  test("timeFormat(specifier) defaults to en-US", () {
    expect(timeFormat("%c")(DateTime(2000, 1, 1)), "1/1/2000, 12:00:00 AM");
  });

  test("timeParse(specifier) defaults to en-US", () {
    expect(timeParse("%c")("1/1/2000, 12:00:00 AM")!.millisecondsSinceEpoch,
        DateTime(2000, 1, 1).millisecondsSinceEpoch);
  });

  test("timeFormat(specifier) defaults to en-US", () {
    expect(timeFormat("%c")(DateTime.utc(2000, 1, 1)), "1/1/2000, 12:00:00 AM");
  });

  test("utcParse(specifier) defaults to en-US", () {
    expect(utcParse("%c")("1/1/2000, 12:00:00 AM")!.millisecondsSinceEpoch,
        DateTime.utc(2000, 1, 1).millisecondsSinceEpoch);
  });

  test("timeFormatDefaultLocale(definition) returns the new default locale",
      () {
    final locale = timeFormatDefaultLocaleFromJson(frFr);
    try {
      expect(locale.format("%c")(DateTime(2000, 1, 1)),
          "samedi  1 janvier 2000 à 00:00:00");
    } finally {
      timeFormatDefaultLocaleFromJson(enUs);
    }
  });

  test("timeFormatDefaultLocale(definition) affects timeFormat", () {
    timeFormatDefaultLocaleFromJson(frFr);
    try {
      expect(timeFormat("%c")(DateTime(2000, 1, 1)),
          "samedi  1 janvier 2000 à 00:00:00");
    } finally {
      timeFormatDefaultLocaleFromJson(enUs);
    }
  });

  test("timeFormatDefaultLocale(definition) affects timeParse", () {
    timeFormatDefaultLocaleFromJson(frFr);
    try {
      expect(
          timeParse("%c")("samedi  1 janvier 2000 à 00:00:00")!
              .millisecondsSinceEpoch,
          DateTime(2000, 1, 1).millisecondsSinceEpoch);
    } finally {
      timeFormatDefaultLocaleFromJson(enUs);
    }
  });

  test("timeFormatDefaultLocale(definition) affects timeFormat", () {
    timeFormatDefaultLocaleFromJson(frFr);
    try {
      expect(timeFormat("%c")(DateTime.utc(2000, 1, 1)),
          "samedi  1 janvier 2000 à 00:00:00");
    } finally {
      timeFormatDefaultLocaleFromJson(enUs);
    }
  });

  test("timeFormatDefaultLocale(definition) affects utcParse", () {
    timeFormatDefaultLocaleFromJson(frFr);
    try {
      expect(
          utcParse("%c")("samedi  1 janvier 2000 à 00:00:00")!
              .millisecondsSinceEpoch,
          DateTime.utc(2000, 1, 1).millisecondsSinceEpoch);
    } finally {
      timeFormatDefaultLocaleFromJson(enUs);
    }
  });
}

DateTime? Function(String) utcParse(String specifier) {
  return timeParse(specifier, isUtc: true);
}
