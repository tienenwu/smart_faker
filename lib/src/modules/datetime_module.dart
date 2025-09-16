import '../core/random_generator.dart';
import '../core/locale_manager.dart';
import '../locales/en_us/datetime_data.dart';
import '../locales/zh_tw/datetime_data.dart';
import '../locales/ja_jp/datetime_data.dart';

/// Module for generating date and time related fake data.
class DateTimeModule {
  /// Random generator instance for generating random values.
  final RandomGenerator _random;

  /// Locale manager for handling localization.
  final LocaleManager _localeManager;

  /// Creates a new instance of [DateTimeModule].
  ///
  /// [_random] is used for generating random values.
  /// [_localeManager] handles localization of date and time data.
  DateTimeModule(this._random, this._localeManager);

  /// Gets the current locale code.
  String get currentLocale => _localeManager.currentLocale;

  /// Generates a date in the past.
  DateTime past({int years = 1, DateTime? reference}) {
    reference ??= DateTime.now();
    final daysInPast = years * 365;
    final randomDays = _random.integer(min: 0, max: daysInPast);
    return reference.subtract(Duration(days: randomDays));
  }

  /// Generates a date in the future.
  DateTime future({int years = 1, DateTime? reference}) {
    reference ??= DateTime.now();
    final daysInFuture = years * 365;
    final randomDays = _random.integer(min: 0, max: daysInFuture);
    return reference.add(Duration(days: randomDays));
  }

  /// Generates a date between two dates.
  DateTime between({required DateTime from, required DateTime to}) {
    if (from.isAfter(to)) {
      final temp = from;
      from = to;
      to = temp;
    }

    if (from.isAtSameMomentAs(to)) {
      return from;
    }

    final diffMillis = to.millisecondsSinceEpoch - from.millisecondsSinceEpoch;
    final randomMillis = _random.nextDouble() * diffMillis;
    return from.add(Duration(milliseconds: randomMillis.toInt()));
  }

  /// Generates a recent date (within the last 7 days by default).
  DateTime recent({int days = 7}) {
    final now = DateTime.now();
    final randomDays = _random.nextDouble() * days;
    return now.subtract(Duration(days: randomDays.toInt()));
  }

  /// Generates a date in the near future (within the next 7 days by default).
  DateTime soon({int days = 7}) {
    final now = DateTime.now();
    final randomDays = _random.nextDouble() * days;
    return now.add(Duration(days: randomDays.toInt()));
  }

  /// Generates a weekday name.
  String weekday() {
    switch (currentLocale) {
      case 'zh_TW':
        return _random.element(TraditionalChineseDateTimeData.weekdays);
      case 'ja_JP':
        return _random.element(JapaneseDateTimeData.weekdays);
      default: // en_US
        return _random.element(EnglishDateTimeData.weekdays);
    }
  }

  /// Generates a weekday abbreviation.
  String weekdayAbbr() {
    switch (currentLocale) {
      case 'zh_TW':
        return _random.element(TraditionalChineseDateTimeData.weekdaysAbbr);
      case 'ja_JP':
        return _random.element(JapaneseDateTimeData.weekdaysAbbr);
      default: // en_US
        return _random.element(EnglishDateTimeData.weekdaysAbbr);
    }
  }

  /// Generates a month name.
  String month() {
    switch (currentLocale) {
      case 'zh_TW':
        return _random.element(TraditionalChineseDateTimeData.months);
      case 'ja_JP':
        return _random.element(JapaneseDateTimeData.months);
      default: // en_US
        return _random.element(EnglishDateTimeData.months);
    }
  }

  /// Generates a month abbreviation.
  String monthAbbr() {
    switch (currentLocale) {
      case 'zh_TW':
        return _random.element(TraditionalChineseDateTimeData.monthsAbbr);
      case 'ja_JP':
        return _random.element(JapaneseDateTimeData.monthsAbbr);
      default: // en_US
        return _random.element(EnglishDateTimeData.monthsAbbr);
    }
  }

  /// Generates an hour (0-23).
  int hour() {
    return _random.integer(min: 0, max: 23);
  }

  /// Generates a minute (0-59).
  int minute() {
    return _random.integer(min: 0, max: 59);
  }

  /// Generates a second (0-59).
  int second() {
    return _random.integer(min: 0, max: 59);
  }

  /// Generates a time string in HH:MM:SS format.
  String timeString() {
    final h = hour().toString().padLeft(2, '0');
    final m = minute().toString().padLeft(2, '0');
    final s = second().toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  /// Generates a Unix timestamp.
  int unixTimestamp() {
    final date = between(
      from: DateTime(1970, 1, 1),
      to: DateTime(2100, 1, 1),
    );
    return date.millisecondsSinceEpoch ~/ 1000;
  }

  /// Generates a birthdate for a person between 18 and 80 years old
  DateTime birthdate({int minAge = 18, int maxAge = 80}) {
    final now = DateTime.now();
    final maxBirthYear = now.year - minAge;
    final minBirthYear = now.year - maxAge;

    return between(
      from: DateTime(minBirthYear, 1, 1),
      to: DateTime(maxBirthYear, 12, 31),
    );
  }

  /// Generates an ISO 8601 date string.
  String iso8601() {
    final date = between(
      from: DateTime(1970, 1, 1),
      to: DateTime(2100, 1, 1),
    );
    return date.toUtc().toIso8601String();
  }

  /// Generates a date in the specified format.
  String format(DateTime date, {String format = 'yyyy-MM-dd'}) {
    // Simple format implementation
    String result = format;
    result = result.replaceAll('yyyy', date.year.toString().padLeft(4, '0'));
    result = result.replaceAll('MM', date.month.toString().padLeft(2, '0'));
    result = result.replaceAll('dd', date.day.toString().padLeft(2, '0'));
    result = result.replaceAll('HH', date.hour.toString().padLeft(2, '0'));
    result = result.replaceAll('mm', date.minute.toString().padLeft(2, '0'));
    result = result.replaceAll('ss', date.second.toString().padLeft(2, '0'));

    // Locale-specific month and weekday names
    if (format.contains('MMMM')) {
      final months = _getMonthsList();
      result = result.replaceAll('MMMM', months[date.month - 1]);
    }
    if (format.contains('MMM')) {
      final monthsAbbr = _getMonthsAbbrList();
      result = result.replaceAll('MMM', monthsAbbr[date.month - 1]);
    }
    if (format.contains('EEEE')) {
      final weekdays = _getWeekdaysList();
      result = result.replaceAll('EEEE', weekdays[date.weekday - 1]);
    }
    if (format.contains('EEE')) {
      final weekdaysAbbr = _getWeekdaysAbbrList();
      result = result.replaceAll('EEE', weekdaysAbbr[date.weekday - 1]);
    }

    return result;
  }

  List<String> _getMonthsList() {
    switch (currentLocale) {
      case 'zh_TW':
        return TraditionalChineseDateTimeData.months;
      case 'ja_JP':
        return JapaneseDateTimeData.months;
      default:
        return EnglishDateTimeData.months;
    }
  }

  List<String> _getMonthsAbbrList() {
    switch (currentLocale) {
      case 'zh_TW':
        return TraditionalChineseDateTimeData.monthsAbbr;
      case 'ja_JP':
        return JapaneseDateTimeData.monthsAbbr;
      default:
        return EnglishDateTimeData.monthsAbbr;
    }
  }

  List<String> _getWeekdaysList() {
    switch (currentLocale) {
      case 'zh_TW':
        return TraditionalChineseDateTimeData.weekdays;
      case 'ja_JP':
        return JapaneseDateTimeData.weekdays;
      default:
        return EnglishDateTimeData.weekdays;
    }
  }

  List<String> _getWeekdaysAbbrList() {
    switch (currentLocale) {
      case 'zh_TW':
        return TraditionalChineseDateTimeData.weekdaysAbbr;
      case 'ja_JP':
        return JapaneseDateTimeData.weekdaysAbbr;
      default:
        return EnglishDateTimeData.weekdaysAbbr;
    }
  }
}
