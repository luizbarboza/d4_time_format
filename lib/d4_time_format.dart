/// Parse and format times, inspired by strptime and strftime.
///
/// This package provides an approximate Dart implementation of the
/// venerable
/// [strptime](http://pubs.opengroup.org/onlinepubs/009695399/functions/strptime.html)
/// and
/// [strftime](http://pubs.opengroup.org/onlinepubs/007908799/xsh/strftime.html)
/// functions from the C standard library, and can be used to parse or format
/// dates in a variety of locale-specific representations. To format a date,
/// create a formatter (see [TimeFormatLocale.format]) from a specifier (a
/// string with the desired format *directives*, indicated by `%`); then pass a
/// date to the formatter, which returns a string. For example, to convert the
/// current date to a human-readable string:
///
/// ```dart
/// final formatTime = timeFormat("%B %d, %Y");
/// formatTime(DateTime.timestamp()); // "May 31, 2023"
/// ```
///
/// Likewise, to convert a string back to a date, create a parser:
///
/// ```dart
/// final parseTime = timeParse("%B %d, %Y", isUtc: true);
/// parseTime("June 30, 2015"); // 2023-05-31
/// ```
///
/// You can implement more elaborate conditional time formats, too. For example,
/// here’s a multi-scale time format using
/// [time intervals](https://pub.dev/documentation/d4_time/latest/d4_time/d4_time-library.html):
///
/// ```dart
/// final formatMillisecond = timeFormat(".%L"),
///     formatSecond = timeFormat(":%S"),
///     formatMinute = timeFormat("%I:%M"),
///     formatHour = timeFormat("%I %p"),
///     formatDay = timeFormat("%a %d"),
///     formatWeek = timeFormat("%b %d"),
///     formatMonth = timeFormat("%B"),
///     formatYear = timeFormat("%Y");
///
/// multiFormat(DateTime date) {
///   return (timeSecond(date).isBefore(date)
///       ? formatMillisecond
///       : timeMinute(date).isBefore(date)
///           ? formatSecond
///           : timeHour(date).isBefore(date)
///               ? formatMinute
///               : timeDay(date).isBefore(date)
///                   ? formatHour
///                   : timeMonth(date).isBefore(date)
///                       ? (timeWeek(date).isBefore(date)
///                           ? formatDay
///                           : formatWeek)
///                       : timeYear(date).isBefore(date)
///                           ? formatMonth
///                           : formatYear)(date);
/// }
/// ```
///
/// This package is used by D4
/// [time scales](https://pub.dev/documentation/d4_scale/latest/topics/Time%20scales-topic.html)
/// to generate human-readable ticks.
export 'src/d4_time_format.dart';
import 'src/d4_time_format.dart';
