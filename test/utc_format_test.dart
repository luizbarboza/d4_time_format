import 'package:d4_time/d4_time.dart';
import 'package:d4_time_format/d4_time_format.dart';
import 'package:test/test.dart';

import 'date.dart';

void main() {
  final formatMillisecond = timeFormat(".%L"),
      formatSecond = timeFormat(":%S"),
      formatMinute = timeFormat("%I:%M"),
      formatHour = timeFormat("%I %p"),
      formatDay = timeFormat("%a %d"),
      formatWeek = timeFormat("%b %d"),
      formatMonth = timeFormat("%B"),
      formatYear = timeFormat("%Y");

  multi(d) {
    return (timeSecond(d).isBefore(d)
        ? formatMillisecond
        : timeMinute(d).isBefore(d)
            ? formatSecond
            : timeHour(d).isBefore(d)
                ? formatMinute
                : timeDay(d).isBefore(d)
                    ? formatHour
                    : timeMonth(d).isBefore(d)
                        ? (timeWeek(d).isBefore(d) ? formatDay : formatWeek)
                        : timeYear(d).isBefore(d)
                            ? formatMonth
                            : formatYear)(d);
  }

  test("timeFormat(\"%a\")(date) formats abbreviated weekdays", () {
    final f = timeFormat("%a");
    expect(f(utc(1990, 0, 1)), "Mon");
    expect(f(utc(1990, 0, 2)), "Tue");
    expect(f(utc(1990, 0, 3)), "Wed");
    expect(f(utc(1990, 0, 4)), "Thu");
    expect(f(utc(1990, 0, 5)), "Fri");
    expect(f(utc(1990, 0, 6)), "Sat");
    expect(f(utc(1990, 0, 7)), "Sun");
  });

  test("timeFormat(\"%A\")(date) formats weekdays", () {
    final f = timeFormat("%A");
    expect(f(utc(1990, 0, 1)), "Monday");
    expect(f(utc(1990, 0, 2)), "Tuesday");
    expect(f(utc(1990, 0, 3)), "Wednesday");
    expect(f(utc(1990, 0, 4)), "Thursday");
    expect(f(utc(1990, 0, 5)), "Friday");
    expect(f(utc(1990, 0, 6)), "Saturday");
    expect(f(utc(1990, 0, 7)), "Sunday");
  });

  test("timeFormat(\"%b\")(date) formats abbreviated months", () {
    final f = timeFormat("%b");
    expect(f(utc(1990, 0, 1)), "Jan");
    expect(f(utc(1990, 1, 1)), "Feb");
    expect(f(utc(1990, 2, 1)), "Mar");
    expect(f(utc(1990, 3, 1)), "Apr");
    expect(f(utc(1990, 4, 1)), "May");
    expect(f(utc(1990, 5, 1)), "Jun");
    expect(f(utc(1990, 6, 1)), "Jul");
    expect(f(utc(1990, 7, 1)), "Aug");
    expect(f(utc(1990, 8, 1)), "Sep");
    expect(f(utc(1990, 9, 1)), "Oct");
    expect(f(utc(1990, 10, 1)), "Nov");
    expect(f(utc(1990, 11, 1)), "Dec");
  });

  test("timeFormat(\"%B\")(date) formats months", () {
    final f = timeFormat("%B");
    expect(f(utc(1990, 0, 1)), "January");
    expect(f(utc(1990, 1, 1)), "February");
    expect(f(utc(1990, 2, 1)), "March");
    expect(f(utc(1990, 3, 1)), "April");
    expect(f(utc(1990, 4, 1)), "May");
    expect(f(utc(1990, 5, 1)), "June");
    expect(f(utc(1990, 6, 1)), "July");
    expect(f(utc(1990, 7, 1)), "August");
    expect(f(utc(1990, 8, 1)), "September");
    expect(f(utc(1990, 9, 1)), "October");
    expect(f(utc(1990, 10, 1)), "November");
    expect(f(utc(1990, 11, 1)), "December");
  });

  test("timeFormat(\"%c\")(date) formats localized dates and times", () {
    final f = timeFormat("%c");
    expect(f(utc(1990, 0, 1)), "1/1/1990, 12:00:00 AM");
  });

  test("timeFormat(\"%d\")(date) formats zero-padded dates", () {
    final f = timeFormat("%d");
    expect(f(utc(1990, 0, 1)), "01");
  });

  test("timeFormat(\"%e\")(date) formats space-padded dates", () {
    final f = timeFormat("%e");
    expect(f(utc(1990, 0, 1)), " 1");
  });

  test("timeFormat(\"%g\")(date) formats zero-padded two-digit ISO 8601 years",
      () {
    final f = timeFormat("%g");
    expect(f(utc(2018, 11, 30, 0)), "18"); // Sunday
    expect(f(utc(2018, 11, 31, 0)), "19"); // Monday
    expect(f(utc(2019, 0, 1, 0)), "19");
  });

  test("timeFormat(\"%G\")(date) formats zero-padded four-digit ISO 8601 years",
      () {
    final f = timeFormat("%G");
    expect(f(utc(2018, 11, 30, 0)), "2018"); // Sunday
    expect(f(utc(2018, 11, 31, 0)), "2019"); // Monday
    expect(f(utc(2019, 0, 1, 0)), "2019");
  });

  test("timeFormat(\"%H\")(date) formats zero-padded hours (24)", () {
    final f = timeFormat("%H");
    expect(f(utc(1990, 0, 1, 0)), "00");
    expect(f(utc(1990, 0, 1, 13)), "13");
  });

  test("timeFormat(\"%I\")(date) formats zero-padded hours (12)", () {
    final f = timeFormat("%I");
    expect(f(utc(1990, 0, 1, 0)), "12");
    expect(f(utc(1990, 0, 1, 13)), "01");
  });

  test("timeFormat(\"%j\")(date) formats zero-padded day of year numbers", () {
    final f = timeFormat("%j");
    expect(f(utc(1990, 0, 1)), "001");
    expect(f(utc(1990, 5, 1)), "152");
    expect(f(utc(2010, 2, 13)), "072");
    expect(f(utc(2010, 2, 14)), "073"); // DST begins
    expect(f(utc(2010, 2, 15)), "074");
    expect(f(utc(2010, 10, 6)), "310");
    expect(f(utc(2010, 10, 7)), "311"); // DST ends
    expect(f(utc(2010, 10, 8)), "312");
  });

  test("timeFormat(\"%m\")(date) formats zero-padded months", () {
    final f = timeFormat("%m");
    expect(f(utc(1990, 0, 1)), "01");
    expect(f(utc(1990, 9, 1)), "10");
  });

  test("timeFormat(\"%M\")(date) formats zero-padded minutes", () {
    final f = timeFormat("%M");
    expect(f(utc(1990, 0, 1, 0, 0)), "00");
    expect(f(utc(1990, 0, 1, 0, 32)), "32");
  });

  test("timeFormat(\"%p\")(date) formats AM or PM", () {
    final f = timeFormat("%p");
    expect(f(utc(1990, 0, 1, 0)), "AM");
    expect(f(utc(1990, 0, 1, 13)), "PM");
  });

  test("timeFormat(\"%q\")(date) formats quarters", () {
    final f = timeFormat("%q");
    expect(f(utc(1990, 0, 1)), "1");
    expect(f(utc(1990, 3, 1)), "2");
    expect(f(utc(1990, 6, 1)), "3");
    expect(f(utc(1990, 9, 1)), "4");
  });

  test("timeFormat(\"%Q\")(date) formats UNIX timestamps", () {
    final f = timeFormat("%Q");
    expect(f(utc(1970, 0, 1, 0, 0, 0)), "0");
    expect(f(utc(1990, 0, 1, 0, 0, 0)), "631152000000");
    expect(f(utc(1990, 0, 1, 12, 34, 56)), "631197296000");
  });

  test("timeFormat(\"%s\")(date) formats UNIX timetamps in seconds", () {
    final f = timeFormat("%s");
    expect(f(utc(1970, 0, 1, 0, 0, 0)), "0");
    expect(f(utc(1990, 0, 1, 0, 0, 0)), "631152000");
    expect(f(utc(1990, 0, 1, 12, 34, 56)), "631197296");
  });

  test(
      "timeFormat(\"%s.%L\")(date) formats UNIX timetamps in seconds and milliseconds",
      () {
    final f = timeFormat("%s.%L");
    expect(f(utc(1990, 0, 1, 0, 0, 0, 123)), "631152000.123");
    expect(f(utc(1990, 0, 1, 12, 34, 56, 789)), "631197296.789");
  });

  test(
      "timeFormat(\"%s.%f\")(date) formats UNIX timetamps in seconds and microseconds",
      () {
    final f = timeFormat("%s.%f");
    expect(f(utc(1990, 0, 1, 0, 0, 0, 123)), "631152000.123000");
    expect(f(utc(1990, 0, 1, 12, 34, 56, 789)), "631197296.789000");
  });

  test("timeFormat(\"%S\")(date) formats zero-padded seconds", () {
    final f = timeFormat("%S");
    expect(f(utc(1990, 0, 1, 0, 0, 0)), "00");
    expect(f(utc(1990, 0, 1, 0, 0, 32)), "32");
    final f2 = timeFormat("%0S");
    expect(f2(utc(1990, 0, 1, 0, 0, 0)), "00");
    expect(f2(utc(1990, 0, 1, 0, 0, 32)), "32");
  });

  test("timeFormat(\"%_S\")(date) formats space-padded seconds", () {
    final f = timeFormat("%_S");
    expect(f(utc(1990, 0, 1, 0, 0, 0)), " 0");
    expect(f(utc(1990, 0, 1, 0, 0, 3)), " 3");
    expect(f(utc(1990, 0, 1, 0, 0, 32)), "32");
  });

  test("timeFormat(\"-S\")(date) formats no-padded seconds", () {
    final f = timeFormat("%-S");
    expect(f(utc(1990, 0, 1, 0, 0, 0)), "0");
    expect(f(utc(1990, 0, 1, 0, 0, 3)), "3");
    expect(f(utc(1990, 0, 1, 0, 0, 32)), "32");
  });

  test("timeFormat(\"%L\")(date) formats zero-padded milliseconds", () {
    final f = timeFormat("%L");
    expect(f(utc(1990, 0, 1, 0, 0, 0, 0)), "000");
    expect(f(utc(1990, 0, 1, 0, 0, 0, 432)), "432");
  });

  test("timeFormat(\"%u\")(date) formats week day numbers", () {
    final f = timeFormat("%u");
    expect(f(utc(1990, 0, 1, 0)), "1");
    expect(f(utc(1990, 0, 7, 0)), "7");
    expect(f(utc(2010, 2, 13, 23)), "6");
  });

  test("timeFormat(\"%f\")(date) formats zero-padded microseconds", () {
    final f = timeFormat("%f");
    expect(f(utc(1990, 0, 1, 0, 0, 0, 0)), "000000");
    expect(f(utc(1990, 0, 1, 0, 0, 0, 432)), "432000");
  });

  test("timeFormat(\"%U\")(date) formats zero-padded week numbers", () {
    final f = timeFormat("%U");
    expect(f(utc(1990, 0, 1, 0)), "00");
    expect(f(utc(1990, 5, 1, 0)), "21");
    expect(f(utc(2010, 2, 13, 23)), "10");
    expect(f(utc(2010, 2, 14, 0)), "11"); // DST begins
    expect(f(utc(2010, 2, 15, 0)), "11");
    expect(f(utc(2010, 10, 6, 23)), "44");
    expect(f(utc(2010, 10, 7, 0)), "45"); // DST ends
    expect(f(utc(2010, 10, 8, 0)), "45");
    expect(f(utc(2012, 0, 1, 0)), "01"); // Sunday!
  });

  test("timeFormat(\"%W\")(date) formats zero-padded week numbers", () {
    final f = timeFormat("%W");
    expect(f(utc(1990, 0, 1, 0)), "01"); // Monday!
    expect(f(utc(1990, 5, 1, 0)), "22");
    expect(f(utc(2010, 2, 15, 0)), "11");
    expect(f(utc(2010, 10, 8, 0)), "45");
  });

  test("timeFormat(\"%V\")(date) formats zero-padded ISO 8601 week numbers",
      () {
    final f = timeFormat("%V");
    expect(f(utc(1990, 0, 1, 0)), "01");
    expect(f(utc(1990, 5, 1, 0)), "22");
    expect(f(utc(2010, 2, 13, 23)), "10");
    expect(f(utc(2010, 2, 14, 0)), "10"); // DST begins
    expect(f(utc(2010, 2, 15, 0)), "11");
    expect(f(utc(2010, 10, 6, 23)), "44");
    expect(f(utc(2010, 10, 7, 0)), "44"); // DST ends
    expect(f(utc(2010, 10, 8, 0)), "45");
    expect(f(utc(2015, 11, 31, 0)), "53");
    expect(f(utc(2016, 0, 1, 0)), "53");
  });

  test("timeFormat(\"%x\")(date) formats localized dates", () {
    final f = timeFormat("%x");
    expect(f(utc(1990, 0, 1)), "1/1/1990");
    expect(f(utc(2010, 5, 1)), "6/1/2010");
  });

  test("timeFormat(\"%X\")(date) formats localized times", () {
    final f = timeFormat("%X");
    expect(f(utc(1990, 0, 1, 0, 0, 0)), "12:00:00 AM");
    expect(f(utc(1990, 0, 1, 13, 34, 59)), "1:34:59 PM");
  });

  test("timeFormat(\"%y\")(date) formats zero-padded two-digit years", () {
    final f = timeFormat("%y");
    expect(f(utc(1990, 0, 1)), "90");
    expect(f(utc(2002, 0, 1)), "02");
    expect(f(utc(-2, 0, 1)), "-02");
  });

  test("timeFormat(\"%Y\")(date) formats zero-padded four-digit years", () {
    final f = timeFormat("%Y");
    expect(f(utc(123, 0, 1)), "0123");
    expect(f(utc(1990, 0, 1)), "1990");
    expect(f(utc(2002, 0, 1)), "2002");
    expect(f(utc(10002, 0, 1)), "0002");
    expect(f(utc(-2, 0, 1)), "-0002");
  });

  test("timeFormat(\"%Z\")(date) formats time zones", () {
    final f = timeFormat("%Z");
    expect(f(utc(1990, 0, 1)), "+0000");
  });

  test("timeFormat(\"%%\")(date) formats literal percent signs", () {
    final f = timeFormat("%%");
    expect(f(utc(1990, 0, 1)), "%");
  });

  test("timeFormat(…) can be used to create a conditional multi-format", () {
    expect(multi(utc(1990, 0, 1, 0, 0, 0, 12)), ".012");
    expect(multi(utc(1990, 0, 1, 0, 0, 1, 0)), ":01");
    expect(multi(utc(1990, 0, 1, 0, 1, 0, 0)), "12:01");
    expect(multi(utc(1990, 0, 1, 1, 0, 0, 0)), "01 AM");
    expect(multi(utc(1990, 0, 2, 0, 0, 0, 0)), "Tue 02");
    expect(multi(utc(1990, 1, 1, 0, 0, 0, 0)), "February");
    expect(multi(utc(1990, 0, 1, 0, 0, 0, 0)), "1990");
  });
}
