import '../core/random_generator.dart';
import '../core/locale_manager.dart';

/// Generates healthcare and medical-related fake data.
class HealthcareModule {
  final RandomGenerator random;
  final LocaleManager localeManager;

  const HealthcareModule(this.random, this.localeManager);

  /// Generates a patient ID.
  String patientId() {
    final prefix = 'PAT';
    final year = DateTime.now().year % 100;
    final sequence = random.integer(min: 100000, max: 999999);
    return '$prefix$year$sequence';
  }

  /// Generates a medical record number (MRN).
  String medicalRecordNumber() {
    return 'MRN-${random.integer(min: 1000000, max: 9999999)}';
  }

  /// Generates a doctor name with title.
  String doctorName() {
    final titles = ['Dr.', 'Prof. Dr.'];
    final title = random.element(titles);

    switch (localeManager.currentLocale) {
      case 'zh_TW':
        final surnames = ['陳', '林', '黃', '張', '李', '王', '吳', '劉', '蔡', '楊'];
        final givenNames = ['志明', '淑芬', '俊傑', '雅婷', '建華', '美玲', '文彬', '秀英'];
        return '${random.element(surnames)}${random.element(givenNames)}醫師';

      case 'ja_JP':
        final surnames = ['田中', '佐藤', '鈴木', '高橋', '渡辺', '伊藤', '山本', '中村'];
        final givenNames = ['太郎', '花子', '健一', '美咲', '大輔', '由美', '誠', '愛'];
        return '${random.element(surnames)}${random.element(givenNames)}医師';

      default:
        final firstNames = [
          'James',
          'Sarah',
          'Michael',
          'Emily',
          'David',
          'Jennifer',
          'Robert',
          'Lisa'
        ];
        final lastNames = [
          'Smith',
          'Johnson',
          'Williams',
          'Brown',
          'Jones',
          'Garcia',
          'Miller',
          'Davis'
        ];
        return '$title ${random.element(firstNames)} ${random.element(lastNames)}';
    }
  }

  /// Generates a medical specialty.
  String specialty() {
    switch (localeManager.currentLocale) {
      case 'zh_TW':
        final specialties = [
          '內科',
          '外科',
          '婦產科',
          '小兒科',
          '眼科',
          '耳鼻喉科',
          '皮膚科',
          '精神科',
          '骨科',
          '泌尿科',
          '神經內科',
          '心臟內科',
          '胸腔內科',
          '腸胃科',
          '腎臟科',
          '血液腫瘤科',
          '復健科',
          '家醫科'
        ];
        return random.element(specialties);

      case 'ja_JP':
        final specialties = [
          '内科',
          '外科',
          '産婦人科',
          '小児科',
          '眼科',
          '耳鼻咽喉科',
          '皮膚科',
          '精神科',
          '整形外科',
          '泌尿器科',
          '神経内科',
          '循環器内科',
          '呼吸器内科',
          '消化器内科',
          '腎臓内科',
          '血液内科',
          'リハビリテーション科',
          '総合診療科'
        ];
        return random.element(specialties);

      default:
        final specialties = [
          'Cardiology',
          'Neurology',
          'Orthopedics',
          'Pediatrics',
          'Psychiatry',
          'Radiology',
          'Surgery',
          'Internal Medicine',
          'Emergency Medicine',
          'Anesthesiology',
          'Dermatology',
          'Endocrinology',
          'Gastroenterology',
          'Hematology',
          'Infectious Disease',
          'Nephrology',
          'Oncology',
          'Ophthalmology',
          'Otolaryngology',
          'Pathology',
          'Pulmonology',
          'Rheumatology',
          'Urology'
        ];
        return random.element(specialties);
    }
  }

  /// Generates a hospital or clinic name.
  String hospitalName() {
    switch (localeManager.currentLocale) {
      case 'zh_TW':
        final types = ['醫院', '診所', '醫療中心', '健康中心'];
        final names = ['仁愛', '慈濟', '長庚', '榮總', '馬偕', '新光', '國泰', '和信'];
        final locations = ['台北', '台中', '高雄', '新竹', '台南'];
        if (random.boolean(probability: 0.7)) {
          return '${random.element(locations)}${random.element(names)}${random.element(types)}';
        }
        return '${random.element(names)}${random.element(types)}';

      case 'ja_JP':
        final types = ['病院', 'クリニック', '医療センター', '診療所'];
        final names = ['東京', '大阪', '京都', '神戸', '横浜', '名古屋', '福岡', '札幌'];
        final prefixes = ['中央', '総合', '大学', '市立', '国立', '赤十字'];
        return '${random.element(names)}${random.element(prefixes)}${random.element(types)}';

      default:
        final types = ['Hospital', 'Medical Center', 'Clinic', 'Health Center'];
        final names = [
          'St. Mary\'s',
          'Memorial',
          'General',
          'Community',
          'Regional',
          'University'
        ];
        final cities = [
          'New York',
          'Los Angeles',
          'Chicago',
          'Houston',
          'Phoenix'
        ];
        if (random.boolean(probability: 0.6)) {
          return '${random.element(cities)} ${random.element(names)} ${random.element(types)}';
        }
        return '${random.element(names)} ${random.element(types)}';
    }
  }

  /// Generates a diagnosis or condition.
  String diagnosis() {
    switch (localeManager.currentLocale) {
      case 'zh_TW':
        final conditions = [
          '高血壓',
          '糖尿病',
          '感冒',
          '過敏',
          '氣喘',
          '頭痛',
          '失眠',
          '焦慮症',
          '憂鬱症',
          '胃炎',
          '關節炎',
          '貧血',
          '甲狀腺功能低下',
          '高血脂',
          '心律不整',
          '鼻竇炎',
          '支氣管炎',
          '腎結石',
          '痛風'
        ];
        return random.element(conditions);

      case 'ja_JP':
        final conditions = [
          '高血圧',
          '糖尿病',
          '風邪',
          'アレルギー',
          '喘息',
          '頭痛',
          '不眠症',
          '不安障害',
          'うつ病',
          '胃炎',
          '関節炎',
          '貧血',
          '甲状腺機能低下症',
          '高脂血症',
          '不整脈',
          '副鼻腔炎',
          '気管支炎',
          '腎結石',
          '痛風'
        ];
        return random.element(conditions);

      default:
        final conditions = [
          'Hypertension',
          'Type 2 Diabetes',
          'Common Cold',
          'Allergic Rhinitis',
          'Asthma',
          'Migraine',
          'Insomnia',
          'Anxiety Disorder',
          'Depression',
          'Gastritis',
          'Arthritis',
          'Anemia',
          'Hypothyroidism',
          'Hyperlipidemia',
          'Arrhythmia',
          'Sinusitis',
          'Bronchitis',
          'Kidney Stones',
          'Gout',
          'Pneumonia',
          'UTI',
          'GERD',
          'Chronic Fatigue Syndrome'
        ];
        return random.element(conditions);
    }
  }

  /// Generates a medication name.
  String medication() {
    switch (localeManager.currentLocale) {
      case 'zh_TW':
        final medications = [
          '普拿疼',
          '阿斯匹靈',
          '胃藥',
          '感冒藥',
          '止痛藥',
          '抗生素',
          '降血壓藥',
          '降血糖藥',
          '安眠藥',
          '維他命C',
          '鈣片',
          '鐵劑',
          '葉酸',
          '益生菌',
          '魚油',
          '葡萄糖胺',
          '薑黃素'
        ];
        return random.element(medications);

      case 'ja_JP':
        final medications = [
          'パラセタモール',
          'アスピリン',
          '胃薬',
          '風邪薬',
          '鎮痛剤',
          '抗生物質',
          '降圧薬',
          '血糖降下薬',
          '睡眠薬',
          'ビタミンC',
          'カルシウム',
          '鉄剤',
          '葉酸',
          'プロバイオティクス',
          '魚油',
          'グルコサミン',
          'ウコン'
        ];
        return random.element(medications);

      default:
        final medications = [
          'Acetaminophen',
          'Ibuprofen',
          'Amoxicillin',
          'Lisinopril',
          'Metformin',
          'Omeprazole',
          'Simvastatin',
          'Levothyroxine',
          'Azithromycin',
          'Amlodipine',
          'Metoprolol',
          'Albuterol',
          'Losartan',
          'Gabapentin',
          'Sertraline',
          'Atorvastatin',
          'Prednisone',
          'Vitamin D3',
          'Multivitamin',
          'Omega-3'
        ];
        return random.element(medications);
    }
  }

  /// Generates a dosage instruction.
  String dosage() {
    final amount =
        random.element(['1', '2', '0.5', '5', '10', '20', '50', '100']);
    final unit = random.element(['mg', 'ml', 'tablet', 'capsule']);
    final frequency = random.element(['once', 'twice', 'three times']);
    final timing = random.element(['daily', 'per day']);

    switch (localeManager.currentLocale) {
      case 'zh_TW':
        final unitZh = unit == 'tablet'
            ? '錠'
            : unit == 'capsule'
                ? '膠囊'
                : unit;
        final freqZh = frequency == 'once'
            ? '一次'
            : frequency == 'twice'
                ? '兩次'
                : '三次';
        return '$amount $unitZh，每日$freqZh';

      case 'ja_JP':
        final unitJa = unit == 'tablet'
            ? '錠'
            : unit == 'capsule'
                ? 'カプセル'
                : unit;
        final freqJa = frequency == 'once'
            ? '1回'
            : frequency == 'twice'
                ? '2回'
                : '3回';
        return '$amount $unitJa、1日$freqJa';

      default:
        return '$amount $unit $frequency $timing';
    }
  }

  /// Generates a blood type.
  String bloodType() {
    final types = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
    return random.element(types);
  }

  /// Generates blood pressure reading.
  String bloodPressure() {
    final systolic = random.integer(min: 90, max: 180);
    final diastolic = random.integer(min: 60, max: 110);
    return '$systolic/$diastolic mmHg';
  }

  /// Generates heart rate.
  int heartRate() {
    return random.integer(min: 60, max: 100);
  }

  /// Generates body temperature.
  String temperature({bool fahrenheit = false}) {
    if (fahrenheit) {
      final temp = random.decimal(min: 97.0, max: 100.4);
      return '${temp.toStringAsFixed(1)}°F';
    }
    final temp = random.decimal(min: 36.0, max: 38.0);
    return '${temp.toStringAsFixed(1)}°C';
  }

  /// Generates BMI value.
  double bmi() {
    return random.decimal(min: 16.0, max: 35.0);
  }

  /// Generates an allergy.
  String allergy() {
    switch (localeManager.currentLocale) {
      case 'zh_TW':
        final allergies = [
          '花生',
          '海鮮',
          '牛奶',
          '雞蛋',
          '塵螨',
          '花粉',
          '黴菌',
          '青黴素',
          '阿斯匹靈',
          '貓毛',
          '狗毛',
          '乳膠',
          '堅果'
        ];
        return random.element(allergies);

      case 'ja_JP':
        final allergies = [
          'ピーナッツ',
          '海鮮',
          '牛乳',
          '卵',
          'ダニ',
          '花粉',
          'カビ',
          'ペニシリン',
          'アスピリン',
          '猫',
          '犬',
          'ラテックス',
          'ナッツ'
        ];
        return random.element(allergies);

      default:
        final allergies = [
          'Peanuts',
          'Shellfish',
          'Milk',
          'Eggs',
          'Tree Nuts',
          'Wheat',
          'Soy',
          'Fish',
          'Pollen',
          'Dust Mites',
          'Pet Dander',
          'Mold',
          'Penicillin',
          'Aspirin',
          'Latex',
          'Bee Stings'
        ];
        return random.element(allergies);
    }
  }

  /// Generates an appointment time.
  DateTime appointmentTime() {
    final daysAhead = random.integer(min: 1, max: 30);
    final hour = random.element([9, 10, 11, 14, 15, 16]);
    final minute = random.element([0, 15, 30, 45]);

    final appointment = DateTime.now().add(Duration(days: daysAhead));
    return DateTime(
        appointment.year, appointment.month, appointment.day, hour, minute);
  }

  /// Generates appointment status.
  String appointmentStatus() {
    switch (localeManager.currentLocale) {
      case 'zh_TW':
        final statuses = ['已預約', '已確認', '已完成', '已取消', '改期', '未到診'];
        return random.element(statuses);

      case 'ja_JP':
        final statuses = ['予約済み', '確認済み', '完了', 'キャンセル', '日程変更', '未受診'];
        return random.element(statuses);

      default:
        final statuses = [
          'Scheduled',
          'Confirmed',
          'Completed',
          'Cancelled',
          'Rescheduled',
          'No-show'
        ];
        return random.element(statuses);
    }
  }

  /// Generates insurance provider.
  String insuranceProvider() {
    switch (localeManager.currentLocale) {
      case 'zh_TW':
        final providers = [
          '全民健保',
          '國泰人壽',
          '富邦人壽',
          '南山人壽',
          '新光人壽',
          '台灣人壽',
          '中國人壽',
          '三商美邦',
          '安聯人壽'
        ];
        return random.element(providers);

      case 'ja_JP':
        final providers = [
          '国民健康保険',
          '日本生命',
          '第一生命',
          '明治安田生命',
          '住友生命',
          'アフラック',
          'メットライフ',
          'ソニー生命',
          'オリックス生命'
        ];
        return random.element(providers);

      default:
        final providers = [
          'Blue Cross Blue Shield',
          'Aetna',
          'Cigna',
          'Humana',
          'Kaiser Permanente',
          'UnitedHealth',
          'Anthem',
          'Centene',
          'Molina Healthcare',
          'WellCare'
        ];
        return random.element(providers);
    }
  }

  /// Generates insurance policy number.
  String insurancePolicyNumber() {
    final prefix = random.element(['POL', 'INS', 'HC']);
    final number = random.integer(min: 100000000, max: 999999999);
    return '$prefix$number';
  }

  /// Generates a medical test or procedure.
  String medicalTest() {
    switch (localeManager.currentLocale) {
      case 'zh_TW':
        final tests = [
          '血液檢查',
          'X光檢查',
          '超音波檢查',
          '心電圖',
          'CT掃描',
          'MRI檢查',
          '尿液檢查',
          '血糖檢查',
          '膽固醇檢查',
          '肝功能檢查',
          '腎功能檢查',
          '甲狀腺功能檢查',
          '骨密度檢查',
          '視力檢查',
          '聽力檢查'
        ];
        return random.element(tests);

      case 'ja_JP':
        final tests = [
          '血液検査',
          'X線検査',
          '超音波検査',
          '心電図',
          'CTスキャン',
          'MRI検査',
          '尿検査',
          '血糖値検査',
          'コレステロール検査',
          '肝機能検査',
          '腎機能検査',
          '甲状腺機能検査',
          '骨密度検査',
          '視力検査',
          '聴力検査'
        ];
        return random.element(tests);

      default:
        final tests = [
          'Blood Test',
          'X-Ray',
          'Ultrasound',
          'ECG',
          'CT Scan',
          'MRI',
          'Urinalysis',
          'Glucose Test',
          'Cholesterol Test',
          'Liver Function Test',
          'Kidney Function Test',
          'Thyroid Function Test',
          'Bone Density Test',
          'Eye Exam',
          'Hearing Test',
          'Colonoscopy',
          'Mammogram',
          'EEG'
        ];
        return random.element(tests);
    }
  }

  /// Generates vaccination name.
  String vaccination() {
    switch (localeManager.currentLocale) {
      case 'zh_TW':
        final vaccines = [
          'COVID-19疫苗',
          '流感疫苗',
          'B型肝炎疫苗',
          '麻疹疫苗',
          '破傷風疫苗',
          '日本腦炎疫苗',
          '肺炎鏈球菌疫苗',
          '水痘疫苗',
          'HPV疫苗',
          '卡介苗'
        ];
        return random.element(vaccines);

      case 'ja_JP':
        final vaccines = [
          'COVID-19ワクチン',
          'インフルエンザワクチン',
          'B型肝炎ワクチン',
          '麻疹ワクチン',
          '破傷風ワクチン',
          '日本脳炎ワクチン',
          '肺炎球菌ワクチン',
          '水痘ワクチン',
          'HPVワクチン',
          'BCGワクチン'
        ];
        return random.element(vaccines);

      default:
        final vaccines = [
          'COVID-19',
          'Influenza',
          'Hepatitis B',
          'MMR',
          'Tetanus',
          'Pneumococcal',
          'Varicella',
          'HPV',
          'Hepatitis A',
          'Meningococcal',
          'Rotavirus',
          'DTaP',
          'Polio',
          'Hib',
          'Shingles'
        ];
        return random.element(vaccines);
    }
  }

  /// Generates a complete medical record.
  Map<String, dynamic> medicalRecord() {
    return {
      'patientId': patientId(),
      'mrn': medicalRecordNumber(),
      'bloodType': bloodType(),
      'allergies':
          List.generate(random.integer(min: 0, max: 3), (_) => allergy()),
      'currentMedications': List.generate(
          random.integer(min: 1, max: 4),
          (_) => {
                'name': medication(),
                'dosage': dosage(),
              }),
      'diagnoses':
          List.generate(random.integer(min: 1, max: 3), (_) => diagnosis()),
      'vitalSigns': {
        'bloodPressure': bloodPressure(),
        'heartRate': heartRate(),
        'temperature': temperature(),
        'bmi': bmi().toStringAsFixed(1),
      },
      'insurance': {
        'provider': insuranceProvider(),
        'policyNumber': insurancePolicyNumber(),
      },
      'primaryDoctor': doctorName(),
      'lastVisit': DateTime.now()
          .subtract(Duration(days: random.integer(min: 1, max: 90)))
          .toIso8601String(),
    };
  }
}
