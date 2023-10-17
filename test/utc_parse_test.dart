import 'package:d4_time_format/d4_time_format.dart';
import 'package:test/test.dart';

import 'date.dart';

void main() {
  test(
      "timeParse(\"\", isUtc: true)(date) parses abbreviated weekday and numeric date",
      () {
    final p = timeParse("%a %m/%d/%Y", isUtc: true);
    expect(p("Sun 01/01/1990"), utc(1990, 0, 1));
    expect(p("Wed 02/03/1991"), utc(1991, 1, 3));
    expect(p("XXX 03/10/2010"), null);
  });

  test("timeParse(\"\", isUtc: true)(date) parses weekday and numeric date",
      () {
    final p = timeParse("%A %m/%d/%Y", isUtc: true);
    expect(p("Sunday 01/01/1990"), utc(1990, 0, 1));
    expect(p("Wednesday 02/03/1991"), utc(1991, 1, 3));
    expect(p("Caturday 03/10/2010"), null);
  });

  test("timeParse(\"\", isUtc: true)(date) parses numeric date", () {
    final p = timeParse("%m/%d/%y", isUtc: true);
    expect(p("01/01/90"), utc(1990, 0, 1));
    expect(p("02/03/91"), utc(1991, 1, 3));
    expect(p("03/10/2010"), null);
  });

  test("timeParse(\"\", isUtc: true)(date) parses locale date", () {
    final p = timeParse("%x", isUtc: true);
    expect(p("01/01/1990"), utc(1990, 0, 1));
    expect(p("02/03/1991"), utc(1991, 1, 3));
    expect(p("03/10/2010"), utc(2010, 2, 10));
  });

  test(
      "timeParse(\"\", isUtc: true)(date) parses abbreviated month, date and year",
      () {
    final p = timeParse("%b %d, %Y", isUtc: true);
    expect(p("jan 01, 1990"), utc(1990, 0, 1));
    expect(p("feb  2, 2010"), utc(2010, 1, 2));
    expect(p("jan. 1, 1990"), null);
  });

  test("timeParse(\"\", isUtc: true)(date) parses month, date and year", () {
    final p = timeParse("%B %d, %Y", isUtc: true);
    expect(p("january 01, 1990"), utc(1990, 0, 1));
    expect(p("February  2, 2010"), utc(2010, 1, 2));
    expect(p("jan 1, 1990"), null);
  });

  test("timeParse(\"\", isUtc: true)(date) parses locale date and time", () {
    final p = timeParse("%c", isUtc: true);
    expect(p("1/1/1990, 12:00:00 AM"), utc(1990, 0, 1));
  });

  test(
      "timeParse(\"\", isUtc: true)(date) parses twenty-four hour, minute and second",
      () {
    final p = timeParse("%H:%M:%S", isUtc: true);
    expect(p("00:00:00"), utc(1900, 0, 1, 0, 0, 0));
    expect(p("11:59:59"), utc(1900, 0, 1, 11, 59, 59));
    expect(p("12:00:00"), utc(1900, 0, 1, 12, 0, 0));
    expect(p("12:00:01"), utc(1900, 0, 1, 12, 0, 1));
    expect(p("23:59:59"), utc(1900, 0, 1, 23, 59, 59));
  });

  test("timeParse(\"\", isUtc: true)(date) parses locale time", () {
    final p = timeParse("%X", isUtc: true);
    expect(p("12:00:00 AM"), utc(1900, 0, 1, 0, 0, 0));
    expect(p("11:59:59 AM"), utc(1900, 0, 1, 11, 59, 59));
    expect(p("12:00:00 PM"), utc(1900, 0, 1, 12, 0, 0));
    expect(p("12:00:01 PM"), utc(1900, 0, 1, 12, 0, 1));
    expect(p("11:59:59 PM"), utc(1900, 0, 1, 23, 59, 59));
  });

  test("timeParse(\"%L\", isUtc: true)(date) parses milliseconds", () {
    final p = timeParse("%L", isUtc: true);
    expect(p("432"), utc(1900, 0, 1, 0, 0, 0, 432));
  });

  test("timeParse(\"%f\", isUtc: true)(date) parses microseconds", () {
    final p = timeParse("%f", isUtc: true);
    expect(p("432000"), utc(1900, 0, 1, 0, 0, 0, 432));
  });

  test(
      "timeParse(\"\", isUtc: true)(date) parses twelve hour, minute and second",
      () {
    final p = timeParse("%I:%M:%S %p", isUtc: true);
    expect(p("12:00:00 am"), utc(1900, 0, 1, 0, 0, 0));
    expect(p("11:59:59 AM"), utc(1900, 0, 1, 11, 59, 59));
    expect(p("12:00:00 pm"), utc(1900, 0, 1, 12, 0, 0));
    expect(p("12:00:01 pm"), utc(1900, 0, 1, 12, 0, 1));
    expect(p("11:59:59 PM"), utc(1900, 0, 1, 23, 59, 59));
  });

  test("timeParse(\"\", isUtc: true)(date) parses timezone offset", () {
    final p = timeParse("%m/%d/%Y %Z", isUtc: true);
    expect(p("01/02/1990 +0000"), utc(1990, 0, 2));
    expect(p("01/02/1990 +0100"), utc(1990, 0, 1, 23));
    expect(p("01/02/1990 -0100"), utc(1990, 0, 2, 1));
    expect(p("01/02/1990 -0800"), local(1990, 0, 2).toUtc());
  });

  test(
      "timeParse(\"\", isUtc: true)(date) parses timezone offset (in the form '+-hh:mm')",
      () {
    final p = timeParse("%m/%d/%Y %Z", isUtc: true);
    expect(p("01/02/1990 +01:30"), utc(1990, 0, 1, 22, 30));
    expect(p("01/02/1990 -01:30"), utc(1990, 0, 2, 1, 30));
  });

  test(
      "timeParse(\"\", isUtc: true)(date) parses timezone offset (in the form '+-hh')",
      () {
    final p = timeParse("%m/%d/%Y %Z", isUtc: true);
    expect(p("01/02/1990 +01"), utc(1990, 0, 1, 23));
    expect(p("01/02/1990 -01"), utc(1990, 0, 2, 1));
  });

  test(
      "timeParse(\"\", isUtc: true)(date) parses timezone offset (in the form 'Z')",
      () {
    final p = timeParse("%m/%d/%Y %Z", isUtc: true);
    expect(p("01/02/1990 Z"), utc(1990, 0, 2));
  });

  test(
      "timeParse(\"%Y %U %w\", isUtc: true)(date) handles a year that starts on Sunday",
      () {
    final p = timeParse("%Y %U %w", isUtc: true);
    expect(p("2012 01 0"), utc(2012, 0, 1));
  });

  test(
      "timeParse(\"%w %V %Y\", isUtc: true)(date) parses numeric weekday, week number (ISO) and year",
      () {
    final p = timeParse("%w %V %Y", isUtc: true);
    expect(p("1 01 1990"), utc(1990, 0, 1));
    expect(p("0 05 1991"), utc(1991, 1, 3));
    expect(p("4 53 1992"), utc(1992, 11, 31));
    expect(p("0 52 1994"), utc(1995, 0, 1));
    expect(p("0 01 1995"), utc(1995, 0, 8));
    expect(p("X 03 2010"), null);
  });

  test(
      "timeParse(\"%w %V %G\", isUtc: true)(date) parses numeric weekday, week number (ISO) and corresponding year",
      () {
    final p = timeParse("%w %V %G", isUtc: true);
    expect(p("1 01 1990"), utc(1990, 0, 1));
    expect(p("0 05 1991"), utc(1991, 1, 3));
    expect(p("4 53 1992"), utc(1992, 11, 31));
    expect(p("0 52 1994"), utc(1995, 0, 1));
    expect(p("0 01 1995"), utc(1995, 0, 8));
    expect(p("1 01 2018"), utc(2018, 0, 1));
    expect(p("1 01 2019"), utc(2018, 11, 31));
    expect(p("X 03 2010"), null);
  });

  test("timeParse(\"%V %Y\", isUtc: true)(date) week number (ISO) and year",
      () {
    final p = timeParse("%V %Y", isUtc: true);
    expect(p("01 1990"), utc(1990, 0, 1));
    expect(p("05 1991"), utc(1991, 0, 28));
    expect(p("53 1992"), utc(1992, 11, 28));
    expect(p("01 1993"), utc(1993, 0, 4));
    expect(p("01 1995"), utc(1995, 0, 2));
    expect(p("00 1995"), null);
    expect(p("54 1995"), null);
    expect(p("X 1995"), null);
  });

  test(
      "timeParse(\"%V %g\", isUtc: true)(date) week number (ISO) and corresponding two-digits year",
      () {
    final p = timeParse("%V %g", isUtc: true);
    expect(p("01 90"), utc(1990, 0, 1));
    expect(p("05 91"), utc(1991, 0, 28));
    expect(p("53 92"), utc(1992, 11, 28));
    expect(p("01 93"), utc(1993, 0, 4));
    expect(p("01 95"), utc(1995, 0, 2));
    expect(p("01 18"), utc(2018, 0, 1));
    expect(p("01 19"), utc(2018, 11, 31));
    expect(p("00 95"), null);
    expect(p("54 95"), null);
    expect(p("X 95"), null);
  });

  test(
      "timeParse(\"%V %G\", isUtc: true)(date) week number (ISO) and corresponding year",
      () {
    final p = timeParse("%V %G", isUtc: true);
    expect(p("01 1990"), utc(1990, 0, 1));
    expect(p("05 1991"), utc(1991, 0, 28));
    expect(p("53 1992"), utc(1992, 11, 28));
    expect(p("01 1993"), utc(1993, 0, 4));
    expect(p("01 1995"), utc(1995, 0, 2));
    expect(p("01 2018"), utc(2018, 0, 1));
    expect(p("01 2019"), utc(2018, 11, 31));
    expect(p("00 1995"), null);
    expect(p("54 1995"), null);
    expect(p("X 1995"), null);
  });

  test("timeParse(\"%Q\", isUtc: true)(date) parses UNIX timestamps", () {
    final p = timeParse("%Q", isUtc: true);
    expect(p("0"), utc(1970, 0, 1));
    expect(p("631152000000"), utc(1990, 0, 1));
  });

  test("timeParse(\"%s\", isUtc: true)(date) parses UNIX timestamps in seconds",
      () {
    final p = timeParse("%s", isUtc: true);
    expect(p("0"), utc(1970, 0, 1));
    expect(p("631152000"), utc(1990, 0, 1));
  });

  test(
      "timeParse(\"%s.%L\", isUtc: true)(date) parses UNIX timetamps in seconds and milliseconds",
      () {
    final p = timeParse("%s.%L", isUtc: true);
    expect(p("631152000.123"), utc(1990, 0, 1, 0, 0, 0, 123));
    expect(p("631197296.789"), utc(1990, 0, 1, 12, 34, 56, 789));
  });

  test(
      "timeParse(\"%s.%f\", isUtc: true)(date) parses UNIX timetamps in seconds and microseconds",
      () {
    final p = timeParse("%s.%f", isUtc: true);
    expect(p("631152000.123000"), utc(1990, 0, 1, 0, 0, 0, 123));
    expect(p("631197296.789000"), utc(1990, 0, 1, 12, 34, 56, 789));
  });
}
