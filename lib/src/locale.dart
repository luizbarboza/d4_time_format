import 'dart:math';

import 'package:d4_time/d4_time.dart';

DateTime _localDate(Map<String, int?> d) {
  return DateTime(d["y"]!, d["m"]! + 1, d["d"]!, d["H"]!, d["M"]!, d["S"]!,
      d["L"]!, d["f"]!);
}

DateTime _utcDate(Map<String, int?> d) {
  return DateTime.utc(d["y"]!, d["m"]! + 1, d["d"]!, d["H"]!, d["M"]!, d["S"]!,
      d["L"]!, d["f"]!);
}

Map<String, int?> _newDate(int? y, int? m, int? d) {
  return {"y": y, "m": m, "d": d, "H": 0, "M": 0, "S": 0, "L": 0, "f": 0};
}

/// Time locale formats define how a date should be parsed and formatted in a
/// locale-specific way.
class TimeFormatLocale {
  final String _localeDateTime, _localeDate, _localeTime;
  final List<String> _localePeriods,
      _localeWeekdays,
      _localeShortWeekdays,
      _localeMonths,
      _localeShortMonths;

  /// Returns a *locale* object for the specified *definition* with [format]
  /// and [parse] methods.
  ///
  /// ```dart
  /// final enUs = TimeFormatLocale(
  ///   dateTime: "%x, %X",
  ///   date: "%-m/%-d/%Y",
  ///   time: "%-I:%M:%S %p",
  ///   periods: ["AM", "PM"],
  ///   days: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
  ///   shortDays: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
  ///   months: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],
  ///   shortMonths: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
  /// );
  /// ```
  ///
  /// The *definition* must include the following properties:
  ///
  /// * `dateTime` - the date and time (`%c`) format specifier (*e.g.*, `"%a %b %e %X %Y"`).
  /// * `date` - the date (`%x`) format specifier (*e.g.*, `"%m/%d/%Y"`).
  /// * `time` - the time (`%X`) format specifier (*e.g.*, `"%H:%M:%S"`).
  /// * `periods` - the A.M. and P.M. equivalents (*e.g.*, `["AM", "PM"]`).
  /// * `days` - the full names of the weekdays, starting with Sunday.
  /// * `shortDays` - the abbreviated names of the weekdays, starting with Sunday.
  /// * `months` - the full names of the months (starting with January).
  /// * `shortMonths` - the abbreviated names of the months (starting with January).
  TimeFormatLocale(
      {required String dateTime,
      required String date,
      required String time,
      required List<String> periods,
      required List<String> days,
      required List<String> shortDays,
      required List<String> months,
      required List<String> shortMonths})
      : _localeDateTime = dateTime,
        _localeDate = date,
        _localeTime = time,
        _localePeriods = periods,
        _localeWeekdays = days,
        _localeShortWeekdays = shortDays,
        _localeMonths = months,
        _localeShortMonths = shortMonths {
    _formats["x"] = _newFormat(_localeDate, _formats);
    _formats["X"] = _newFormat(_localeTime, _formats);
    _formats["c"] = _newFormat(_localeDateTime, _formats);
  }

  /// Equivalent to [TimeFormatLocale.new], but it accepts a JSON [definition]
  /// object instead of individual arguments
  factory TimeFormatLocale.fromJson(Map<String, dynamic> definition) {
    return TimeFormatLocale(
        dateTime: definition["dateTime"],
        date: definition["date"],
        time: definition["time"],
        periods: definition["periods"].cast<String>(),
        days: definition["days"].cast<String>(),
        shortDays: definition["shortDays"].cast<String>(),
        months: definition["months"].cast<String>(),
        shortMonths: definition["shortMonths"].cast<String>());
  }

  late final _periodRe = _formatRe(_localePeriods),
      _periodLookup = _formatLookup(_localePeriods),
      _weekdayRe = _formatRe(_localeWeekdays),
      _weekdayLookup = _formatLookup(_localeWeekdays),
      _shortWeekdayRe = _formatRe(_localeShortWeekdays),
      _shortWeekdayLookup = _formatLookup(_localeShortWeekdays),
      _monthRe = _formatRe(_localeMonths),
      _monthLookup = _formatLookup(_localeMonths),
      _shortMonthRe = _formatRe(_localeShortMonths),
      _shortMonthLookup = _formatLookup(_localeShortMonths);

  late final _formats = <String, String Function(DateTime, String)?>{
    "a": _formatShortWeekday,
    "A": _formatWeekday,
    "b": _formatShortMonth,
    "B": _formatMonth,
    "c": null,
    "d": _formatDayOfMonth,
    "e": _formatDayOfMonth,
    "f": _formatMicroseconds,
    "g": _formatYearISO,
    "G": _formatFullYearISO,
    "H": _formatHour24,
    "I": _formatHour12,
    "j": _formatDayOfYear,
    "L": _formatMilliseconds,
    "m": _formatMonthNumber,
    "M": _formatMinutes,
    "p": _formatPeriod,
    "q": _formatQuarter,
    "Q": _formatUnixTimestamp,
    "s": _formatUnixTimestampSeconds,
    "S": _formatSeconds,
    "u": _formatWeekdayNumberMonday,
    "U": _formatWeekNumberSunday,
    "V": _formatWeekNumberISO,
    "w": _formatWeekdayNumberSunday,
    "W": _formatWeekNumberMonday,
    "x": null,
    "X": null,
    "y": _formatYear,
    "Y": _formatFullYear,
    "Z": _formatZone,
    "%": _formatLiteralPercent
  };

  late final _parses = {
    "a": _parseShortWeekday,
    "A": _parseWeekday,
    "b": _parseShortMonth,
    "B": _parseMonth,
    "c": _parseLocaleDateTime,
    "d": _parseDayOfMonth,
    "e": _parseDayOfMonth,
    "f": _parseMicroseconds,
    "g": _parseYear,
    "G": _parseFullYear,
    "H": _parseHour24,
    "I": _parseHour24,
    "j": _parseDayOfYear,
    "L": _parseMilliseconds,
    "m": _parseMonthNumber,
    "M": _parseMinutes,
    "p": _parsePeriod,
    "q": _parseQuarter,
    "Q": _parseUnixTimestamp,
    "s": _parseUnixTimestampSeconds,
    "S": _parseSeconds,
    "u": _parseWeekdayNumberMonday,
    "U": _parseWeekNumberSunday,
    "V": _parseWeekNumberISO,
    "w": _parseWeekdayNumberSunday,
    "W": _parseWeekNumberMonday,
    "x": _parseLocaleDate,
    "X": _parseLocaleTime,
    "y": _parseYear,
    "Y": _parseFullYear,
    "Z": _parseZone,
    "%": _parseLiteralPercent
  };

  String Function(DateTime, [String?]) _newFormat(String specifier,
      Map<String, String Function(DateTime, String)?> formats) {
    return (date, [_]) {
      var string = <String>[], i = -1, j = 0, n = specifier.length;
      String c;
      String Function(DateTime, String)? format;
      String? pad;

      while (++i < n) {
        if (specifier.codeUnitAt(i) == 37) {
          string.add(specifier.slice(j, i));
          if ((pad = _pads[c = specifier[++i]]) != null) {
            c = specifier[++i];
          } else {
            pad = c == "e" ? " " : "0";
          }
          if ((format = formats[c]) != null) c = format!(date, pad!);
          string.add(c);
          j = i + 1;
        }
      }

      string.add(specifier.slice(j, i));
      return string.join("");
    };
  }

  DateTime? Function(String) _newParse(String specifier, bool Z) {
    return (string) {
      var d = _newDate(1900, null, 1),
          i = _parseSpecifier(d, specifier, string, 0);
      DateTime week;
      int day;
      if (i != string.length) return null;

      // If a UNIX timestamp is specified, return it.
      if (d.containsKey("Q")) {
        return DateTime.fromMicrosecondsSinceEpoch(
            d["Q"]! * 1000 + (d["f"] ?? 0),
            isUtc: Z);
      }
      if (d.containsKey("s")) {
        return DateTime.fromMicrosecondsSinceEpoch(
            d["s"]! * 1000000 +
                (d["L"] != null ? d["L"]! * 1000 : 0) +
                (d["f"] ?? 0),
            isUtc: Z);
      }

      // If this is utcParse, never use the local timezone.
      if (Z) d["Z"] ??= 0;

      // The am-pm flag is 0 for AM, and 1 for PM.
      if (d.containsKey("p")) d["H"] = d["H"]!.remainder(12) + d["p"]! * 12;

      // If the month was not specified, inherit from the quarter.
      if (d["m"] == null) d["m"] = d["q"] ?? 0;

      // Convert day-of-week and week-of-year to day-of-year.
      if (d.containsKey("V")) {
        if (d["V"]! < 1 || d["V"]! > 53) return null;
        if (!(d.containsKey("w"))) d["w"] = 1;
        if (d.containsKey("Z")) {
          week = _utcDate(_newDate(d["y"], 0, 1));
          day = week.weekday;
          if (day == 7) day = 0;
          week = day > 4 || day == 0 ? timeMonday.ceil(week) : timeMonday(week);
          week = timeDay.offset(week, (d["V"]! - 1) * 7);
          d["y"] = week.year;
          d["m"] = week.month - 1;
          d["d"] = week.day + (d["w"]! + 6).remainder(7);
        } else {
          week = _localDate(_newDate(d["y"], 0, 1));
          day = week.weekday;
          if (day == 7) day = 0;
          week = day > 4 || day == 0 ? timeMonday.ceil(week) : timeMonday(week);
          week = timeDay.offset(week, (d["V"]! - 1) * 7);
          d["y"] = week.year;
          d["m"] = week.month - 1;
          d["d"] = week.day + (d["w"]! + 6).remainder(7);
        }
      } else if (d.containsKey("W") || d.containsKey("U")) {
        if (!(d.containsKey("w"))) {
          d["w"] = d.containsKey("u")
              ? d["u"]!.remainder(7)
              : d.containsKey("W")
                  ? 1
                  : 0;
        }
        day = d.containsKey("Z")
            ? _utcDate(_newDate(d["y"], 0, 1)).weekday
            : _localDate(_newDate(d["y"], 0, 1)).weekday;
        if (day == 7) day = 0;
        d["m"] = 0;
        d["d"] = d.containsKey("W")
            ? (d["w"]! + 6).remainder(7) + d["W"]! * 7 - (day + 5).remainder(7)
            : d["w"]! + d["U"]! * 7 - (day + 6).remainder(7);
      }

      // If a time zone is specified, all fields are interpreted as UTC and then
      // offset according to the specified time zone.
      if (d.containsKey("Z")) {
        d["H"] = (d["H"]! + d["Z"]! ~/ 100);
        d["M"] = d["M"]! + d["Z"]!.remainder(100);
        return _utcDate(d);
      }

      // Otherwise, all fields are in local time.
      return _localDate(d);
    };
  }

  int _parseSpecifier(
      Map<String, int?> d, String specifier, String string, int j) {
    int i = 0, n = specifier.length, m = string.length, co;
    String c;
    int Function(Map<String, int?>, String, int)? parse;

    while (i < n) {
      if (j >= m) return -1;
      co = specifier.codeUnitAt(i++);
      if (co == 37) {
        c = specifier[i++];
        parse = _parses[_pads.containsKey(c) ? specifier[i++] : c];
        if (parse == null || ((j = parse(d, string, j)) < 0)) return -1;
      } else if (co != string.codeUnitAt(j++)) {
        return -1;
      }
    }

    return j;
  }

  int _parsePeriod(Map<String, int?> d, String string, int i) {
    var n = _periodRe.stringMatch(string.slice(i));
    if (n != null) {
      d["p"] = _periodLookup[n.toLowerCase()];
      return i + n.length;
    }
    return -1;
  }

  int _parseShortWeekday(Map<String, int?> d, String string, int i) {
    var n = _shortWeekdayRe.stringMatch(string.slice(i));
    if (n == null) return -1;
    d["w"] = _shortWeekdayLookup[n.toLowerCase()];
    return i + n.length;
  }

  int _parseWeekday(Map<String, int?> d, String string, int i) {
    var n = _weekdayRe.stringMatch(string.slice(i));
    if (n == null) return -1;
    d["w"] = _weekdayLookup[n.toLowerCase()];
    return i + n.length;
  }

  int _parseShortMonth(Map<String, int?> d, String string, int i) {
    var n = _shortMonthRe.stringMatch(string.slice(i));
    if (n == null) return -1;
    d["m"] = _shortMonthLookup[n.toLowerCase()];
    return i + n.length;
  }

  int _parseMonth(Map<String, int?> d, String string, int i) {
    var n = _monthRe.stringMatch(string.slice(i));
    if (n == null) return -1;
    d["m"] = _monthLookup[n.toLowerCase()];
    return i + n.length;
  }

  int _parseLocaleDateTime(Map<String, int?> d, String string, int i) {
    return _parseSpecifier(d, _localeDateTime, string, i);
  }

  int _parseLocaleDate(Map<String, int?> d, String string, int i) {
    return _parseSpecifier(d, _localeDate, string, i);
  }

  int _parseLocaleTime(Map<String, int?> d, String string, int i) {
    return _parseSpecifier(d, _localeTime, string, i);
  }

  String _formatShortWeekday(DateTime d, [String? _]) {
    return _localeShortWeekdays[d.weekday == 7 ? 0 : d.weekday];
  }

  String _formatWeekday(DateTime d, [String? _]) {
    return _localeWeekdays[d.weekday == 7 ? 0 : d.weekday];
  }

  String _formatShortMonth(DateTime d, [String? _]) {
    return _localeShortMonths[d.month - 1];
  }

  String _formatMonth(DateTime d, [String? _]) {
    return _localeMonths[d.month - 1];
  }

  String _formatPeriod(DateTime d, [String? _]) {
    return _localePeriods[d.hour >= 12 ? 1 : 0];
  }

  String _formatQuarter(DateTime d, [String? _]) {
    return (1 + ((d.month - 1) ~/ 3)).toString();
  }

  /// Returns a new formatter for the given string [specifier].
  ///
  /// ```dart
  /// timeFormat("%b %d");
  /// ```
  ///
  /// The [specifier] string may contain the following directives:
  ///
  /// `%a` - abbreviated weekday name.*
  /// `%A` - full weekday name.*
  /// `%b` - abbreviated month name.*
  /// `%B` - full month name.*
  /// `%c` - the locale’s date and time, such as `%x, %X`.*
  /// `%d` - zero-padded day of the month as a decimal number \[01,31\].
  /// `%e` - space-padded day of the month as a decimal number \[ 1,31\]; equivalent to `%_d`.
  /// `%f` - microseconds as a decimal number \[000000, 999999\].
  /// `%g` - ISO 8601 week-based year without century as a decimal number \[00,99\].
  /// `%G` - ISO 8601 week-based year with century as a decimal number.
  /// `%H` - hour (24-hour clock) as a decimal number \[00,23\].
  /// `%I` - hour (12-hour clock) as a decimal number \[01,12\].
  /// `%j` - day of the year as a decimal number \[001,366\].
  /// `%m` - month as a decimal number \[01,12\].
  /// `%M` - minute as a decimal number \[00,59\].
  /// `%L` - milliseconds as a decimal number \[000, 999\].
  /// `%p` - either AM or PM.*
  /// `%q` - quarter of the year as a decimal number \[1,4\].
  /// `%Q` - milliseconds since UNIX epoch.
  /// `%s` - seconds since UNIX epoch.
  /// `%S` - second as a decimal number \[00,61\].
  /// `%u` - Monday-based (ISO 8601) weekday as a decimal number \[1,7\].
  /// `%U` - Sunday-based week of the year as a decimal number \[00,53\].
  /// `%V` - ISO 8601 week of the year as a decimal number \[01, 53\].
  /// `%w` - Sunday-based weekday as a decimal number \[0,6\].
  /// `%W` - Monday-based week of the year as a decimal number \[00,53\].
  /// `%x` - the locale’s date, such as `%-m/%-d/%Y`.*
  /// `%X` - the locale’s time, such as `%-I:%M:%S %p`.*
  /// `%y` - year without century as a decimal number \[00,99\].
  /// `%Y` - year with century as a decimal number, such as `1999`.
  /// `%Z` - time zone offset, such as `-0700`, `-07:00`, `-07`, or `Z`.
  /// `%%` - a literal percent sign (`%`).
  ///
  /// Directives marked with an asterisk (*) may be affected by the locale
  /// definition (see [TimeFormatLocale]).
  ///
  /// For `%U`, all days in a new year preceding the first Sunday are considered
  /// to be in week 0. For `%W`, all days in a new year preceding the first
  /// Monday are considered to be in week 0. Week numbers are computed using
  /// [TimeInterval.count]. For example, 2015-52 and 2016-00 represent Monday,
  /// December 28, 2015, while 2015-53 and 2016-01 represent Monday, January 4,
  /// 2016. This differs from the
  /// [ISO week date](https://en.wikipedia.org/wiki/ISO_week_date) specification
  /// (`%V`), which uses a more complicated definition!
  ///
  /// For `%V`, `%g` and `%G`, per
  /// [the strftime man page](http://man7.org/linux/man-pages/man3/strftime.3.html):
  ///
  /// > In this system, weeks start on a Monday, and are numbered from 01, for
  /// > the first week, up to 52 or 53, for the last week. Week 1 is the first
  /// > week where four or more days fall within the new year (or, synonymously,
  /// > week 01 is: the first week of the year that contains a Thursday; or, the
  /// > week that has 4 January in it). If the ISO week number belongs to the
  /// > previous or next year, that year is used instead.
  ///
  /// The `%` sign indicating a directive may be immediately followed by a
  /// padding modifier:
  ///
  /// * `0` - zero-padding
  /// * `_` - space-padding
  /// * `-` - disable padding
  ///
  /// If no padding modifier is specified, the default is `0` for all directives
  /// except `%e`, which defaults to `_`. (In some implementations of strftime
  /// and strptime, a directive may include an optional field width or
  /// precision; this feature is not yet implemented.)
  ///
  /// The returned function formats a specified *date*, returning the
  /// corresponding string.
  ///
  /// ```dart
  /// final formatMonth = timeFormat("%B"),
  ///     formatDay = d3.timeFormat("%A"),
  ///     date = new Date(2014, 5, 1); // Thu May 01 2014 00:00:00 GMT-0700 (PDT)
  ///
  /// formatMonth(date); // "May"
  /// formatDay(date); // "Thursday"
  /// ```
  String Function(DateTime) format(String specifier) {
    return _newFormat(specifier, _formats);
  }

  /// Returns a new parser for the given string [specifier].
  ///
  /// ```dart
  /// timeParse("%b %d");
  /// ```
  ///
  /// The [specifier] string may contain the same directives as
  /// [TimeFormatLocale.format]. The `%d` and `%e` directives are considered
  /// equivalent for parsing.
  ///
  /// The returned function parses a specified *string*, returning the
  /// corresponding date or null if the string could not be parsed according to
  /// this format’s specifier. Parsing is strict: if the specified *string* does
  /// not exactly match the associated specifier, this method returns null. For
  /// example, if the associated specifier is `%Y-%m-%dT%H:%M:%SZ`, then the
  /// string `"2011-07-01T19:15:28Z"` will be parsed as expected, but
  /// `"2011-07-01T19:15:28"`, `"2011-07-01 19:15:28"` and `"2011-07-01"` will
  /// return null. (Note that the literal `Z` here is different from the time
  /// zone offset directive %Z.) If a more flexible parser is desired, try
  /// multiple formats sequentially until one returns non-null.
  DateTime? Function(String) parse(String specifier, {bool isUtc = false}) {
    return _newParse(specifier, isUtc);
  }
}

var _pads = {"-": "", "_": " ", "0": "0"},
    _numberRe = RegExp(r'^\s*\d+'), // note: ignores next directive
    _percentRe = RegExp(r'^%'),
    _requoteRe = RegExp(r'[\\^$*+?|[\]().{}]');

String _pad(int value, String fill, int width) {
  var sign = value < 0 ? "-" : "",
      string = (sign.isNotEmpty ? -value : value).toString(),
      length = string.length;
  return sign + (length < width ? (fill * (width - length)) + string : string);
}

String _requote(String s) {
  return s.replaceAllMapped(_requoteRe, (match) => '\\${match[0]}');
}

RegExp _formatRe(List<String> names) {
  return RegExp("^(?:${names.map(_requote).join("|")})", caseSensitive: false);
}

Map<String, int> _formatLookup(List<String> names) {
  return Map.fromEntries([
    for (var i = 0; i < names.length; i++) MapEntry(names[i].toLowerCase(), i)
  ]);
}

int _parseWeekdayNumberSunday(Map<String, int?> d, String string, int i) {
  var n = _numberRe.stringMatch(string.slice(i, i + 1));
  if (n == null) return -1;
  d["w"] = int.parse(n);
  return i + n.length;
}

int _parseWeekdayNumberMonday(Map<String, int?> d, String string, int i) {
  var n = _numberRe.stringMatch(string.slice(i, i + 1));
  if (n == null) return -1;
  d["u"] = int.parse(n);
  return i + n.length;
}

int _parseWeekNumberSunday(Map<String, int?> d, String string, int i) {
  var n = _numberRe.stringMatch(string.slice(i, i + 2));
  if (n == null) return -1;
  d["U"] = int.parse(n);
  return i + n.length;
}

int _parseWeekNumberISO(Map<String, int?> d, String string, int i) {
  var n = _numberRe.stringMatch(string.slice(i, i + 2));
  if (n == null) return -1;
  d["V"] = int.parse(n);
  return i + n.length;
}

int _parseWeekNumberMonday(Map<String, int?> d, String string, int i) {
  var n = _numberRe.stringMatch(string.slice(i, i + 2));
  if (n == null) return -1;
  d["W"] = int.parse(n);
  return i + n.length;
}

int _parseFullYear(Map<String, int?> d, String string, int i) {
  var n = _numberRe.stringMatch(string.slice(i, i + 4));
  if (n == null) return -1;
  d["y"] = int.parse(n);
  return i + n.length;
}

int _parseYear(Map<String, int?> d, String string, int i) {
  var n = _numberRe.stringMatch(string.slice(i, i + 2));
  if (n == null) return -1;
  var n0 = int.parse(n);
  d["y"] = n0 + (n0 > 68 ? 1900 : 2000);
  return i + n.length;
}

int _parseZone(Map<String, int?> d, String string, int i) {
  var n = RegExp(r'^(Z)|([+-]\d\d)(?::?(\d\d))?')
      .firstMatch(string.slice(i, i + 6));
  if (n == null) return -1;
  d["Z"] = n[1] != null ? 0 : -int.parse(n[2]! + (n[3] ?? "00"));
  return i + n[0]!.length;
}

int _parseQuarter(Map<String, int?> d, String string, int i) {
  var n = _numberRe.stringMatch(string.slice(i, i + 1));
  if (n == null) return -1;
  d["q"] = int.parse(n) * 3 - 3;
  return i + n.length;
}

int _parseMonthNumber(Map<String, int?> d, String string, int i) {
  var n = _numberRe.stringMatch(string.slice(i, i + 2));
  if (n == null) return -1;
  d["m"] = int.parse(n) - 1;
  return i + n.length;
}

int _parseDayOfMonth(Map<String, int?> d, String string, int i) {
  var n = _numberRe.stringMatch(string.slice(i, i + 2));
  if (n == null) return -1;
  d["d"] = int.parse(n);
  return i + n.length;
}

int _parseDayOfYear(Map<String, int?> d, String string, int i) {
  var n = _numberRe.stringMatch(string.slice(i, i + 3));
  if (n == null) return -1;
  d["m"] = 0;
  d["d"] = int.parse(n);
  return i + n.length;
}

int _parseHour24(Map<String, int?> d, String string, int i) {
  var n = _numberRe.stringMatch(string.slice(i, i + 2));
  if (n == null) return -1;
  d["H"] = int.parse(n);
  return i + n.length;
}

int _parseMinutes(Map<String, int?> d, String string, int i) {
  var n = _numberRe.stringMatch(string.slice(i, i + 2));
  if (n == null) return -1;
  d["M"] = int.parse(n);
  return i + n.length;
}

int _parseSeconds(Map<String, int?> d, String string, int i) {
  var n = _numberRe.stringMatch(string.slice(i, i + 2));
  if (n == null) return -1;
  d["S"] = int.parse(n);
  return i + n.length;
}

int _parseMilliseconds(Map<String, int?> d, String string, int i) {
  var n = _numberRe.stringMatch(string.slice(i, i + 3));
  if (n == null) return -1;
  d["L"] = int.parse(n);
  return i + n.length;
}

int _parseMicroseconds(Map<String, int?> d, String string, int i) {
  var n = _numberRe.stringMatch(string.slice(i, i + 6));
  if (n == null) return -1;
  var n0 = int.parse(n);
  d["L"] = n0 ~/ 1000;
  d["f"] = n0.remainder(1000);
  return i + n.length;
}

int _parseLiteralPercent(Map<String, int?> d, String string, int i) {
  var n = _percentRe.stringMatch(string.slice(i, i + 1));
  return n != null ? i + n.length : -1;
}

int _parseUnixTimestamp(Map<String, int?> d, String string, int i) {
  var n = _numberRe.stringMatch(string.slice(i));
  if (n == null) return -1;
  d["Q"] = int.parse(n);
  return i + n.length;
}

int _parseUnixTimestampSeconds(Map<String, int?> d, String string, int i) {
  var n = _numberRe.stringMatch(string.slice(i));
  if (n == null) return -1;
  d["s"] = int.parse(n);
  return i + n.length;
}

String _formatDayOfMonth(DateTime d, String p) {
  return _pad(d.day, p, 2);
}

String _formatHour24(DateTime d, String p) {
  return _pad(d.hour, p, 2);
}

String _formatHour12(DateTime d, String p) {
  final hour12 = d.hour.remainder(12);
  return _pad(hour12 != 0 ? hour12 : 12, p, 2);
}

String _formatDayOfYear(DateTime d, String p) {
  return _pad(1 + timeDay.count(timeYear(d), d)!, p, 3);
}

String _formatMilliseconds(DateTime d, String p) {
  return _pad(d.millisecond, p, 3);
}

String _formatMicroseconds(DateTime d, String p) {
  return _pad(d.millisecond * 1000 + d.microsecond, p, 6);
}

String _formatMonthNumber(DateTime d, String p) {
  return _pad(d.month, p, 2);
}

String _formatMinutes(DateTime d, String p) {
  return _pad(d.minute, p, 2);
}

String _formatSeconds(DateTime d, String p) {
  return _pad(d.second, p, 2);
}

String _formatWeekdayNumberMonday(DateTime d, [String? _]) {
  var day = d.weekday;
  return (day == 0 ? 7 : day).toString();
}

String _formatWeekNumberSunday(DateTime d, String p) {
  return _pad(
      timeSunday.count(
          DateTime.fromMillisecondsSinceEpoch(
              timeYear(d).millisecondsSinceEpoch - 1),
          d)!,
      p,
      2);
}

DateTime _dISO(DateTime d) {
  var day = d.weekday;
  return (day >= 4 || day == 0) ? timeThursday(d) : timeThursday.ceil(d);
}

String _formatWeekNumberISO(DateTime d, String p) {
  d = _dISO(d);
  return _pad(
      timeThursday.count(timeYear(d), d)! + (timeYear(d).weekday == 4 ? 1 : 0),
      p,
      2);
}

String _formatWeekdayNumberSunday(DateTime d, [String? _]) {
  return d.weekday.toString();
}

String _formatWeekNumberMonday(DateTime d, String p) {
  return _pad(
      timeMonday.count(
          DateTime.fromMillisecondsSinceEpoch(
              timeYear(d).millisecondsSinceEpoch - 1),
          d)!,
      p,
      2);
}

String _formatYear(DateTime d, String p) {
  return _pad(d.year.remainder(100), p, 2);
}

String _formatYearISO(DateTime d, String p) {
  d = _dISO(d);
  return _pad(d.year.remainder(100), p, 2);
}

String _formatFullYear(DateTime d, String p) {
  return _pad(d.year.remainder(10000), p, 4);
}

String _formatFullYearISO(DateTime d, String p) {
  var day = d.weekday;
  d = (day >= 4 || day == 0) ? timeThursday(d) : timeThursday.ceil(d);
  return _pad(d.year.remainder(10000), p, 4);
}

String _formatZone(DateTime d, [String? _]) {
  var z = d.timeZoneOffset.inMinutes;
  return (z < 0 ? (z *= -1, "-").$2 : "+") +
      _pad(z ~/ 60, "0", 2) +
      _pad(z.remainder(60), "0", 2);
}

String _formatLiteralPercent([DateTime? _, String? __]) {
  return "%";
}

String _formatUnixTimestamp(DateTime d, [String? _]) {
  return (d.microsecondsSinceEpoch / 1000).floor().toString();
}

String _formatUnixTimestampSeconds(DateTime d, [String? _]) {
  return (d.microsecondsSinceEpoch / 1000000).floor().toString();
}

extension on String {
  String slice(int start, [int? end]) {
    return substring(start, min(end ?? length, length));
  }
}
