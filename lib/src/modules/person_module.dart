import '../core/locale_manager.dart';
import '../core/random_generator.dart';
import 'models/gender.dart';
import 'models/person.dart';
import '../locales/en_us/person_data.dart';
import '../locales/zh_tw/person_data.dart';
import '../locales/ja_jp/person_data.dart';

/// Module for generating person-related data.
class PersonModule {
  /// Creates a new instance of [PersonModule].
  ///
  /// [randomGenerator] is used for generating random values.
  /// [localeManager] handles localization of person data.
  PersonModule({
    required this.randomGenerator,
    required this.localeManager,
  });

  /// Random generator instance for generating random values.
  final RandomGenerator randomGenerator;

  /// Locale manager for handling localization.
  final LocaleManager localeManager;

  /// Generates a first name.
  ///
  /// [gender] - Optional gender for gender-specific names.
  String firstName({Gender? gender}) {
    final locale = localeManager.currentLocale;
    List<String> names;

    switch (locale) {
      case 'zh_TW':
        names = gender == Gender.male
            ? TraditionalChinesePersonData.maleFirstNames
            : gender == Gender.female
                ? TraditionalChinesePersonData.femaleFirstNames
                : [
                    ...TraditionalChinesePersonData.maleFirstNames,
                    ...TraditionalChinesePersonData.femaleFirstNames
                  ];
        break;
      case 'ja_JP':
        names = gender == Gender.male
            ? JapanesePersonData.maleGivenNames
            : gender == Gender.female
                ? JapanesePersonData.femaleGivenNames
                : [
                    ...JapanesePersonData.maleGivenNames,
                    ...JapanesePersonData.femaleGivenNames
                  ];
        break;
      case 'en_US':
      default:
        names = gender == Gender.male
            ? EnglishPersonData.maleFirstNames
            : gender == Gender.female
                ? EnglishPersonData.femaleFirstNames
                : [
                    ...EnglishPersonData.maleFirstNames,
                    ...EnglishPersonData.femaleFirstNames
                  ];
    }

    return randomGenerator.element(names);
  }

  /// Generates a last name.
  String lastName() {
    final locale = localeManager.currentLocale;

    switch (locale) {
      case 'zh_TW':
        return randomGenerator.element(TraditionalChinesePersonData.lastNames);
      case 'ja_JP':
        return randomGenerator.element(JapanesePersonData.lastNames);
      case 'en_US':
      default:
        return randomGenerator.element(EnglishPersonData.lastNames);
    }
  }

  /// Generates a full name.
  ///
  /// [gender] - Optional gender for gender-specific first names.
  String fullName({Gender? gender}) {
    final locale = localeManager.currentLocale;
    final first = firstName(gender: gender);
    final last = lastName();

    switch (locale) {
      case 'zh_TW':
        return '$last$first'; // Chinese: family name first, no space
      case 'ja_JP':
        return '$last$first'; // Japanese: family name first, no space
      case 'en_US':
      default:
        return '$first $last'; // English: given name first with space
    }
  }

  /// Generates an age.
  ///
  /// [min] - Minimum age (default: 18).
  /// [max] - Maximum age (default: 65).
  int age({int min = 18, int max = 65}) {
    return randomGenerator.integer(min: min, max: max);
  }

  /// Generates a gender.
  Gender gender() {
    return randomGenerator.boolean() ? Gender.male : Gender.female;
  }

  /// Generates a job title.
  String jobTitle() {
    final locale = localeManager.currentLocale;
    List<String> descriptors;
    List<String> areas;
    List<String> types;

    switch (locale) {
      case 'zh_TW':
        descriptors = TraditionalChinesePersonData.jobDescriptors;
        areas = TraditionalChinesePersonData.jobAreas;
        types = TraditionalChinesePersonData.jobTypes;
        break;
      case 'ja_JP':
        descriptors = JapanesePersonData.jobDescriptors;
        areas = JapanesePersonData.jobAreas;
        types = JapanesePersonData.jobTypes;
        break;
      case 'en_US':
      default:
        descriptors = EnglishPersonData.jobDescriptors;
        areas = EnglishPersonData.jobAreas;
        types = EnglishPersonData.jobTypes;
    }

    final descriptor = randomGenerator.element(descriptors);
    final area = randomGenerator.element(areas);
    final type = randomGenerator.element(types);

    // Sometimes just use descriptor + type
    if (randomGenerator.boolean(probability: 0.3)) {
      return locale == 'en_US' ? '$descriptor $type' : '$descriptor$type';
    }

    return locale == 'en_US'
        ? '$descriptor $area $type'
        : '$descriptor$area$type';
  }

  /// Generates a job department.
  String jobDepartment() {
    final locale = localeManager.currentLocale;

    switch (locale) {
      case 'zh_TW':
        return randomGenerator
            .element(TraditionalChinesePersonData.departments);
      case 'ja_JP':
        return randomGenerator.element(JapanesePersonData.departments);
      case 'en_US':
      default:
        return randomGenerator.element(EnglishPersonData.departments);
    }
  }

  /// Generates a job descriptor.
  String jobDescriptor() {
    final locale = localeManager.currentLocale;

    switch (locale) {
      case 'zh_TW':
        return randomGenerator
            .element(TraditionalChinesePersonData.jobDescriptors);
      case 'ja_JP':
        return randomGenerator.element(JapanesePersonData.jobDescriptors);
      case 'en_US':
      default:
        return randomGenerator.element(EnglishPersonData.jobDescriptors);
    }
  }

  /// Generates a complete person with all attributes.
  ///
  /// [age] - Optional specific age for the person.
  /// [gender] - Optional specific gender for the person.
  Person generatePerson({int? age, Gender? gender}) {
    final personGender = gender ?? this.gender();
    final personAge = age ?? this.age();
    final firstName = this.firstName(gender: personGender);
    final lastName = this.lastName();

    // Generate age-appropriate job title
    String jobTitle;
    final locale = localeManager.currentLocale;

    if (personAge < 25) {
      final juniorTitles = locale == 'zh_TW'
          ? ['初級', '實習', '助理']
          : locale == 'ja_JP'
              ? ['ジュニア', 'インターン', 'アシスタント']
              : ['Junior', 'Intern', 'Assistant'];
      final types = locale == 'zh_TW'
          ? TraditionalChinesePersonData.jobTypes
          : locale == 'ja_JP'
              ? JapanesePersonData.jobTypes
              : EnglishPersonData.jobTypes;
      final space = locale == 'en_US' ? ' ' : '';
      jobTitle = randomGenerator.element(juniorTitles) +
          space +
          randomGenerator.element(types);
    } else if (personAge < 35) {
      jobTitle = this.jobTitle();
    } else if (personAge < 50) {
      final seniorTitles = locale == 'zh_TW'
          ? ['資深', '首席', '主任']
          : locale == 'ja_JP'
              ? ['シニア', 'チーフ', '主任']
              : ['Senior', 'Lead', 'Principal'];
      final types = locale == 'zh_TW'
          ? TraditionalChinesePersonData.jobTypes
          : locale == 'ja_JP'
              ? JapanesePersonData.jobTypes
              : EnglishPersonData.jobTypes;
      final space = locale == 'en_US' ? ' ' : '';
      jobTitle = randomGenerator.element(seniorTitles) +
          space +
          randomGenerator.element(types);
    } else {
      final executiveTitles = locale == 'zh_TW'
          ? ['總監', '副總', '資深']
          : locale == 'ja_JP'
              ? ['ディレクター', '部長', 'シニア']
              : ['Director', 'VP', 'Senior'];
      final types = locale == 'zh_TW'
          ? TraditionalChinesePersonData.jobTypes
          : locale == 'ja_JP'
              ? JapanesePersonData.jobTypes
              : EnglishPersonData.jobTypes;
      final space = locale == 'en_US' ? ' ' : '';
      jobTitle = randomGenerator.element(executiveTitles) +
          space +
          randomGenerator.element(types);
    }

    // Simple email generation (will be replaced by Internet module later)
    final email =
        '${firstName.toLowerCase()}.${lastName.toLowerCase()}@example.com';

    // Simple phone generation (will be replaced by Phone module later)
    final phone = '+1-${randomGenerator.integer(min: 200, max: 999)}-'
        '${randomGenerator.integer(min: 200, max: 999)}-'
        '${randomGenerator.integer(min: 1000, max: 9999)}';

    // Generate full name based on locale
    final fullName = locale == 'zh_TW' || locale == 'ja_JP'
        ? '$lastName$firstName' // Asian name order, no space
        : '$firstName $lastName'; // Western name order with space

    return Person(
      firstName: firstName,
      lastName: lastName,
      fullName: fullName,
      age: personAge,
      gender: personGender,
      jobTitle: jobTitle,
      email: email,
      phone: phone,
    );
  }

  /// Generate a person's email address
  String email() {
    final firstName = this.firstName();
    final lastName = this.lastName();
    final domains = ['gmail.com', 'yahoo.com', 'outlook.com', 'example.com'];
    final domain = randomGenerator.element(domains);
    return '${firstName.toLowerCase()}.${lastName.toLowerCase()}@$domain';
  }

  /// Generate a person's phone number
  String phone() {
    switch (localeManager.currentLocale) {
      case 'zh_TW':
        // Taiwan mobile format
        final prefix = randomGenerator
            .element(['0912', '0918', '0920', '0921', '0932', '0933']);
        return '$prefix-${randomGenerator.integer(min: 100, max: 999)}-${randomGenerator.integer(min: 100, max: 999)}';
      case 'ja_JP':
        // Japan mobile format
        final prefix = randomGenerator.element(['090', '080', '070']);
        return '$prefix-${randomGenerator.integer(min: 1000, max: 9999)}-${randomGenerator.integer(min: 1000, max: 9999)}';
      default:
        // US format
        return '+1-${randomGenerator.integer(min: 200, max: 999)}-${randomGenerator.integer(min: 200, max: 999)}-${randomGenerator.integer(min: 1000, max: 9999)}';
    }
  }

  /// Generate a person's bio
  String bio() {
    final locale = localeManager.currentLocale;
    final jobTitle = this.jobTitle();
    final age = randomGenerator.integer(min: 22, max: 65);

    if (locale == 'zh_TW') {
      final interests = ['旅遊', '攝影', '閱讀', '音樂', '運動', '美食', '電影'];
      final interest = randomGenerator.element(interests);
      return '${age}歲的$jobTitle，熱愛$interest。致力於創造更好的明天。';
    } else if (locale == 'ja_JP') {
      final interests = ['旅行', '写真', '読書', '音楽', 'スポーツ', '料理', '映画'];
      final interest = randomGenerator.element(interests);
      return '${age}歳の$jobTitle。${interest}が好きです。より良い明日を創造することに情熱を注いでいます。';
    } else {
      final interests = [
        'traveling',
        'photography',
        'reading',
        'music',
        'sports',
        'cooking',
        'movies'
      ];
      final interest = randomGenerator.element(interests);
      return '${age}-year-old $jobTitle who loves $interest. Passionate about creating a better tomorrow.';
    }
  }
}
