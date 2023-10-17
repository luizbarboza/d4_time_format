import 'locale.dart';

TimeFormatLocale _locale = timeFormatDefaultLocale(
    dateTime: "%x, %X",
    date: "%-m/%-d/%Y",
    time: "%-I:%M:%S %p",
    periods: [
      "AM",
      "PM"
    ],
    days: [
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday"
    ],
    shortDays: [
      "Sun",
      "Mon",
      "Tue",
      "Wed",
      "Thu",
      "Fri",
      "Sat"
    ],
    months: [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ],
    shortMonths: [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ]);

String Function(DateTime) Function(String) _timeFormat = _locale.format;
DateTime? Function(String) Function(String, {bool isUtc}) _timeParse =
    _locale.parse;

/// An alias for [TimeFormatLocale.format] on the default locale.
///
/// ```dart
/// timeFormat("%b %d");
/// ```
String Function(DateTime) timeFormat(String specifier) {
  return _timeFormat(specifier);
}

/// An alias for [TimeFormatLocale.parse] on the default locale.
///
/// ```dart
/// timeParse("%b %d");
/// ```
DateTime? Function(String) timeParse(String specifier, {bool isUtc = false}) {
  return _timeParse(specifier, isUtc: isUtc);
}

/// Equivalent to [TimeFormatLocale.new], except it also redefines [timeFormat]
/// and [timeParse] to the new locale’s [TimeFormatLocale.format] and
/// [TimeFormatLocale.parse].
///
/// If you do not set a default locale, it defaults to
/// [U.S. English](https://github.com/luizbarboza/d4_time_format/blob/main/test/locale/en-US.json).
TimeFormatLocale timeFormatDefaultLocale(
    {required String dateTime,
    required String date,
    required String time,
    required List<String> periods,
    required List<String> days,
    required List<String> shortDays,
    required List<String> months,
    required List<String> shortMonths}) {
  _locale = TimeFormatLocale(
      dateTime: dateTime,
      date: date,
      time: time,
      periods: periods,
      days: days,
      shortDays: shortDays,
      months: months,
      shortMonths: shortMonths);
  _timeFormat = _locale.format;
  _timeParse = _locale.parse;
  return _locale;
}

/// Equivalent to [timeFormatDefaultLocale], but it accepts a JSON [definition]
/// object instead of individual arguments
TimeFormatLocale timeFormatDefaultLocaleFromJson(
    Map<String, dynamic> definition) {
  _locale = TimeFormatLocale.fromJson(definition);
  _timeFormat = _locale.format;
  _timeParse = _locale.parse;
  return _locale;
}
