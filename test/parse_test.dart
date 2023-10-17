import 'dart:convert';
import 'dart:io';

import 'package:d4_time_format/d4_time_format.dart';
import 'package:test/test.dart';

import 'date.dart';

void main() {
  final fiFi = jsonDecode(File("./test/locale/fi-FI.json").readAsStringSync());

  test("parse(string) parses localized dates and times", () {
    final p = timeParse("%c");
    expect(p("1/1/1990, 12:00:00 AM"), local(1990, 0, 1));
    expect(p("1/2/1990, 12:00:00 AM"), local(1990, 0, 2));
    expect(p("1/3/1990, 12:00:00 AM"), local(1990, 0, 3));
    expect(p("1/4/1990, 12:00:00 AM"), local(1990, 0, 4));
    expect(p("1/5/1990, 12:00:00 AM"), local(1990, 0, 5));
    expect(p("1/6/1990, 12:00:00 AM"), local(1990, 0, 6));
    expect(p("1/7/1990, 12:00:00 AM"), local(1990, 0, 7));
  });

  test("timeParse(\"%a %m/%d/%Y\")(date) parses abbreviated weekday and date",
      () {
    final p = timeParse("%a %m/%d/%Y");
    expect(p("Sun 01/01/1990"), local(1990, 0, 1));
    expect(p("Wed 02/03/1991"), local(1991, 1, 3));
    expect(p("XXX 03/10/2010"), null);
  });

  test("timeParse(\"%A %m/%d/%Y\")(date) parses weekday and date", () {
    final p = timeParse("%A %m/%d/%Y");
    expect(p("Sunday 01/01/1990"), local(1990, 0, 1));
    expect(p("Wednesday 02/03/1991"), local(1991, 1, 3));
    expect(p("Caturday 03/10/2010"), null);
  });

  test("timeParse(\"%U %Y\")(date) parses week number (Sunday) and year", () {
    final p = timeParse("%U %Y");
    expect(p("00 1990"), local(1989, 11, 31));
    expect(p("05 1991"), local(1991, 1, 3));
    expect(p("01 1995"), local(1995, 0, 1));
  });

  test(
      "timeParse(\"%a %U %Y\")(date) parses abbreviated weekday, week number (Sunday) and year",
      () {
    final p = timeParse("%a %U %Y");
    expect(p("Mon 00 1990"), local(1990, 0, 1));
    expect(p("Sun 05 1991"), local(1991, 1, 3));
    expect(p("Sun 01 1995"), local(1995, 0, 1));
    expect(p("XXX 03 2010"), null);
  });

  test(
      "timeParse(\"%A %U %Y\")(date) parses weekday, week number (Sunday) and year",
      () {
    final p = timeParse("%A %U %Y");
    expect(p("Monday 00 1990"), local(1990, 0, 1));
    expect(p("Sunday 05 1991"), local(1991, 1, 3));
    expect(p("Sunday 01 1995"), local(1995, 0, 1));
    expect(p("Caturday 03 2010"), null);
  });

  test(
      "timeParse(\"%w %U %Y\")(date) parses numeric weekday (Sunday), week number (Sunday) and year",
      () {
    final p = timeParse("%w %U %Y");
    expect(p("1 00 1990"), local(1990, 0, 1));
    expect(p("0 05 1991"), local(1991, 1, 3));
    expect(p("0 01 1995"), local(1995, 0, 1));
    expect(p("X 03 2010"), null);
  });

  test(
      "timeParse(\"%w %V %G\")(date) parses numeric weekday, week number (ISO) and corresponding year",
      () {
    final p = timeParse("%w %V %G");
    expect(p("1 01 1990"), local(1990, 0, 1));
    expect(p("0 05 1991"), local(1991, 1, 3));
    expect(p("4 53 1992"), local(1992, 11, 31));
    expect(p("0 52 1994"), local(1995, 0, 1));
    expect(p("0 01 1995"), local(1995, 0, 8));
    expect(p("1 01 2018"), local(2018, 0, 1));
    expect(p("1 01 2019"), local(2018, 11, 31));
  });

  test(
      "timeParse(\"%w %V %g\")(date) parses numeric weekday, week number (ISO) and corresponding two-digits year",
      () {
    final p = timeParse("%w %V %g");
    expect(p("1 01 90"), local(1990, 0, 1));
    expect(p("0 05 91"), local(1991, 1, 3));
    expect(p("4 53 92"), local(1992, 11, 31));
    expect(p("0 52 94"), local(1995, 0, 1));
    expect(p("0 01 95"), local(1995, 0, 8));
    expect(p("1 01 18"), local(2018, 0, 1));
    expect(p("1 01 19"), local(2018, 11, 31));
  });

  test(
      "timeParse(\"%V %g\")(date) parses week number (ISO) and corresponding two-digits year",
      () {
    final p = timeParse("%V %g");
    expect(p("01 90"), local(1990, 0, 1));
    expect(p("05 91"), local(1991, 0, 28));
    expect(p("53 92"), local(1992, 11, 28));
    expect(p("52 94"), local(1994, 11, 26));
    expect(p("01 95"), local(1995, 0, 2));
    expect(p("01 18"), local(2018, 0, 1));
    expect(p("01 19"), local(2018, 11, 31));
  });

  test(
      "timeParse(\"%u %U %Y\")(date) parses numeric weekday (Monday), week number (Monday) and year",
      () {
    final p = timeParse("%u %W %Y");
    expect(p("1 00 1990"), local(1989, 11, 25));
    expect(p("1 01 1990"), local(1990, 0, 1));
    expect(p("1 05 1991"), local(1991, 1, 4));
    expect(p("7 00 1995"), local(1995, 0, 1));
    expect(p("1 01 1995"), local(1995, 0, 2));
    expect(p("X 03 2010"), null);
  });

  test("timeParse(\"%W %Y\")(date) parses week number (Monday) and year", () {
    final p = timeParse("%W %Y");
    expect(p("01 1990"), local(1990, 0, 1));
    expect(p("04 1991"), local(1991, 0, 28));
    expect(p("00 1995"), local(1994, 11, 26));
  });

  test(
      "timeParse(\"%a %W %Y\")(date) parses abbreviated weekday, week number (Monday) and year",
      () {
    final p = timeParse("%a %W %Y");
    expect(p("Mon 01 1990"), local(1990, 0, 1));
    expect(p("Sun 04 1991"), local(1991, 1, 3));
    expect(p("Sun 00 1995"), local(1995, 0, 1));
    expect(p("XXX 03 2010"), null);
  });

  test(
      "timeParse(\"%A %W %Y\")(date) parses weekday, week number (Monday) and year",
      () {
    final p = timeParse("%A %W %Y");
    expect(p("Monday 01 1990"), local(1990, 0, 1));
    expect(p("Sunday 04 1991"), local(1991, 1, 3));
    expect(p("Sunday 00 1995"), local(1995, 0, 1));
    expect(p("Caturday 03 2010"), null);
  });

  test(
      "timeParse(\"%w %W %Y\")(date) parses numeric weekday (Sunday), week number (Monday) and year",
      () {
    final p = timeParse("%w %W %Y");
    expect(p("1 01 1990"), local(1990, 0, 1));
    expect(p("0 04 1991"), local(1991, 1, 3));
    expect(p("0 00 1995"), local(1995, 0, 1));
    expect(p("X 03 2010"), null);
  });

  test(
      "timeParse(\"%u %W %Y\")(date) parses numeric weekday (Monday), week number (Monday) and year",
      () {
    final p = timeParse("%u %W %Y");
    expect(p("1 01 1990"), local(1990, 0, 1));
    expect(p("7 04 1991"), local(1991, 1, 3));
    expect(p("7 00 1995"), local(1995, 0, 1));
    expect(p("X 03 2010"), null);
  });

  test("timeParse(\"%m/%d/%y\")(date) parses month, date and two-digit year",
      () {
    final p = timeParse("%m/%d/%y");
    expect(p("02/03/69"), local(1969, 1, 3));
    expect(p("01/01/90"), local(1990, 0, 1));
    expect(p("02/03/91"), local(1991, 1, 3));
    expect(p("02/03/68"), local(2068, 1, 3));
    expect(p("03/10/2010"), null);
  });

  test("timeParse(\"%x\")(date) parses locale date", () {
    final p = timeParse("%x");
    expect(p("1/1/1990"), local(1990, 0, 1));
    expect(p("2/3/1991"), local(1991, 1, 3));
    expect(p("3/10/2010"), local(2010, 2, 10));
  });

  test("timeParse(\"%b %d, %Y\")(date) parses abbreviated month, date and year",
      () {
    final p = timeParse("%b %d, %Y");
    expect(p("jan 01, 1990"), local(1990, 0, 1));
    expect(p("feb  2, 2010"), local(2010, 1, 2));
    expect(p("jan. 1, 1990"), null);
  });

  test("timeParse(\"%B %d, %Y\")(date) parses month, date and year", () {
    final p = timeParse("%B %d, %Y");
    expect(p("january 01, 1990"), local(1990, 0, 1));
    expect(p("February  2, 2010"), local(2010, 1, 2));
    expect(p("jan 1, 1990"), null);
  });

  test("timeParse(\"%j %m/%d/%Y\")(date) parses day of year and date", () {
    final p = timeParse("%j %m/%d/%Y");
    expect(p("001 01/01/1990"), local(1990, 0, 1));
    expect(p("034 02/03/1991"), local(1991, 1, 3));
    expect(p("2012 03/10/2010"), null);
  });

  test("timeParse(\"%c\")(date) parses locale date and time", () {
    final p = timeParse("%c");
    expect(p("1/1/1990, 12:00:00 AM"), local(1990, 0, 1));
  });

  test(
      "timeParse(\"%H:%M:%S\")(date) parses twenty-four hour, minute and second",
      () {
    final p = timeParse("%H:%M:%S");
    expect(p("00:00:00"), local(1900, 0, 1, 0, 0, 0));
    expect(p("11:59:59"), local(1900, 0, 1, 11, 59, 59));
    expect(p("12:00:00"), local(1900, 0, 1, 12, 0, 0));
    expect(p("12:00:01"), local(1900, 0, 1, 12, 0, 1));
    expect(p("23:59:59"), local(1900, 0, 1, 23, 59, 59));
  });

  test("timeParse(\"%X\")(date) parses locale time", () {
    final p = timeParse("%X");
    expect(p("12:00:00 AM"), local(1900, 0, 1, 0, 0, 0));
    expect(p("11:59:59 AM"), local(1900, 0, 1, 11, 59, 59));
    expect(p("12:00:00 PM"), local(1900, 0, 1, 12, 0, 0));
    expect(p("12:00:01 PM"), local(1900, 0, 1, 12, 0, 1));
    expect(p("11:59:59 PM"), local(1900, 0, 1, 23, 59, 59));
  });

  test("timeParse(\"%L\")(date) parses milliseconds", () {
    final p = timeParse("%L");
    expect(p("432"), local(1900, 0, 1, 0, 0, 0, 432));
  });

  test("timeParse(\"%f\")(date) parses microseconds", () {
    final p = timeParse("%f");
    expect(p("432000"), local(1900, 0, 1, 0, 0, 0, 432));
  });

  test("timeParse(\"%I:%M:%S %p\")(date) parses twelve hour, minute and second",
      () {
    final p = timeParse("%I:%M:%S %p");
    expect(p("12:00:00 am"), local(1900, 0, 1, 0, 0, 0));
    expect(p("11:59:59 AM"), local(1900, 0, 1, 11, 59, 59));
    expect(p("12:00:00 pm"), local(1900, 0, 1, 12, 0, 0));
    expect(p("12:00:01 pm"), local(1900, 0, 1, 12, 0, 1));
    expect(p("11:59:59 PM"), local(1900, 0, 1, 23, 59, 59));
  });

  test("timeParse(\"%I %p\")(date) parses period in non-English locales", () {
    final p = TimeFormatLocale.fromJson(fiFi).parse("%I:%M:%S %p");
    expect(p("12:00:00 a.m."), local(1900, 0, 1, 0, 0, 0));
    expect(p("11:59:59 A.M."), local(1900, 0, 1, 11, 59, 59));
    expect(p("12:00:00 p.m."), local(1900, 0, 1, 12, 0, 0));
    expect(p("12:00:01 p.m."), local(1900, 0, 1, 12, 0, 1));
    expect(p("11:59:59 P.M."), local(1900, 0, 1, 23, 59, 59));
  });

  test("timeParse(\"%Y %q\")(date) parses quarters", () {
    final p = timeParse("%Y %q");
    expect(p("1990 1"), local(1990, 0, 1));
    expect(p("1990 2"), local(1990, 3, 1));
    expect(p("1990 3"), local(1990, 6, 1));
    expect(p("1990 4"), local(1990, 9, 1));
  });

  test("timeParse(\"%Y %q %m\")(date) gives the month number priority", () {
    final p = timeParse("%Y %q %m");
    expect(p("1990 1 2"), local(1990, 1, 1));
    expect(p("1990 2 5"), local(1990, 4, 1));
    expect(p("1990 3 8"), local(1990, 7, 1));
    expect(p("1990 4 9"), local(1990, 8, 1));
  });

  test("timeParse(\"%% %m/%d/%Y\")(date) parses literal %", () {
    final p = timeParse("%% %m/%d/%Y");
    expect(p("% 01/01/1990"), local(1990, 0, 1));
    expect(p("% 02/03/1991"), local(1991, 1, 3));
    expect(p("%% 03/10/2010"), null);
  });

  test("timeParse(\"%m/%d/%Y %Z\")(date) parses timezone offset", () {
    final p = timeParse("%m/%d/%Y %Z");
    expect(p("01/02/1990 +0000")!.toLocal(), local(1990, 0, 1, 16));
    expect(p("01/02/1990 +0100")!.toLocal(), local(1990, 0, 1, 15));
    expect(p("01/02/1990 +0130")!.toLocal(), local(1990, 0, 1, 14, 30));
    expect(p("01/02/1990 -0100")!.toLocal(), local(1990, 0, 1, 17));
    expect(p("01/02/1990 -0130")!.toLocal(), local(1990, 0, 1, 17, 30));
    expect(p("01/02/1990 -0800")!.toLocal(), local(1990, 0, 2, 0));
  });

  test(
      "timeParse(\"%m/%d/%Y %Z\")(date) parses timezone offset in the form '+-hh:mm'",
      () {
    final p = timeParse("%m/%d/%Y %Z");
    expect(p("01/02/1990 +01:30")!.toLocal(), local(1990, 0, 1, 14, 30));
    expect(p("01/02/1990 -01:30")!.toLocal(), local(1990, 0, 1, 17, 30));
  });

  test(
      "timeParse(\"%m/%d/%Y %Z\")(date) parses timezone offset in the form '+-hh'",
      () {
    final p = timeParse("%m/%d/%Y %Z");
    expect(p("01/02/1990 +01")!.toLocal(), local(1990, 0, 1, 15));
    expect(p("01/02/1990 -01")!.toLocal(), local(1990, 0, 1, 17));
  });

  test(
      "timeParse(\"%m/%d/%Y %Z\")(date) parses timezone offset in the form 'Z'",
      () {
    final p = timeParse("%m/%d/%Y %Z");
    expect(p("01/02/1990 Z")!.toLocal(), local(1990, 0, 1, 16));
  });

  test(
      "timeParse(\"%-m/%0d/%_Y\")(date) ignores optional padding modifier, skipping zeroes and spaces",
      () {
    final p = timeParse("%-m/%0d/%_Y");
    expect(p("01/ 1/1990"), local(1990, 0, 1));
  });
}
