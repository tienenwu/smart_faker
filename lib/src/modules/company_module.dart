import '../core/locale_manager.dart';
import '../core/random_generator.dart';

/// Module for generating company-related data.
class CompanyModule {
  final RandomGenerator random;
  final LocaleManager localeManager;

  CompanyModule(this.random, this.localeManager);

  String get currentLocale => localeManager.currentLocale;

  /// Generates a company name.
  String name() {
    final names = _getLocaleData('names');
    return random.element(names);
  }

  /// Generates a company suffix (e.g., Inc., LLC).
  String suffix() {
    final suffixes = _getLocaleData('suffixes');
    return random.element(suffixes);
  }

  /// Generates a company name with suffix.
  String nameWithSuffix() {
    return '${name()} ${suffix()}';
  }

  /// Generates a company catchphrase.
  String catchphrase() {
    final templates = _getLocaleData('catchphraseTemplates');
    final adjectives = _getLocaleData('catchphraseAdjectives');
    final descriptors = _getLocaleData('catchphraseDescriptors');
    final nouns = _getLocaleData('catchphraseNouns');
    
    final template = random.element(templates);
    return template
        .replaceAll('{adjective}', random.element(adjectives))
        .replaceAll('{descriptor}', random.element(descriptors))
        .replaceAll('{noun}', random.element(nouns));
  }

  /// Generates a business buzzword.
  String buzzword() {
    final buzzwords = _getLocaleData('buzzwords');
    return random.element(buzzwords);
  }

  /// Generates business speak (BS).
  String bs() {
    final verbs = _getLocaleData('bsVerbs');
    final adjectives = _getLocaleData('bsAdjectives');
    final nouns = _getLocaleData('bsNouns');
    
    return '${random.element(verbs)} ${random.element(adjectives)} ${random.element(nouns)}';
  }

  /// Generates an industry type.
  String industry() {
    final industries = _getLocaleData('industries');
    return random.element(industries);
  }

  /// Generates a department name.
  String department() {
    final departments = _getLocaleData('departments');
    return random.element(departments);
  }

  /// Generates an EIN (Employer Identification Number).
  String ein() {
    final area = random.nextInt(99);
    final group = random.nextInt(9999999);
    return '${area.toString().padLeft(2, '0')}-${group.toString().padLeft(7, '0')}';
  }

  /// Generates a DUNS number.
  String dunsNumber() {
    final part1 = random.nextInt(99);
    final part2 = random.nextInt(999);
    final part3 = random.nextInt(9999);
    return '${part1.toString().padLeft(2, '0')}-${part2.toString().padLeft(3, '0')}-${part3.toString().padLeft(4, '0')}';
  }

  /// Generates a SIC (Standard Industrial Classification) code.
  String sicCode() {
    return random.nextInt(9999).toString().padLeft(4, '0');
  }

  /// Generates a NAICS (North American Industry Classification System) code.
  String naicsCode() {
    return random.nextInt(999999).toString().padLeft(6, '0');
  }

  /// Generates a company size category.
  String companySize() {
    final sizes = ['Startup', 'Small', 'Medium', 'Large', 'Enterprise'];
    return random.element(sizes);
  }

  /// Generates an employee count.
  int employeeCount() {
    final size = companySize();
    switch (size) {
      case 'Startup':
        return random.nextInt(50) + 1;
      case 'Small':
        return random.nextInt(200) + 50;
      case 'Medium':
        return random.nextInt(800) + 250;
      case 'Large':
        return random.nextInt(4000) + 1000;
      case 'Enterprise':
        return random.nextInt(95000) + 5000;
      default:
        return random.nextInt(1000) + 1;
    }
  }

  /// Generates an employee count range.
  String employeeCountRange() {
    final ranges = [
      '1-10',
      '11-50',
      '51-200',
      '201-500',
      '501-1000',
      '1001-5000',
      '5000+',
    ];
    return random.element(ranges);
  }

  /// Generates a revenue range.
  String revenueRange() {
    final ranges = [
      'Under \$1M',
      '\$1M - \$10M',
      '\$10M - \$50M',
      '\$50M - \$100M',
      '\$100M - \$500M',
      '\$500M - \$1B',
      'Over \$1B',
    ];
    return random.element(ranges);
  }

  /// Generates a mission statement.
  String missionStatement() {
    final templates = _getLocaleData('missionTemplates');
    final verbs = _getLocaleData('missionVerbs');
    final goals = _getLocaleData('missionGoals');
    final values = _getLocaleData('missionValues');
    
    final template = random.element(templates);
    return template
        .replaceAll('{verb}', random.element(verbs))
        .replaceAll('{goal}', random.element(goals))
        .replaceAll('{value}', random.element(values));
  }

  /// Generates a list of company values.
  List<String> values() {
    final allValues = _getLocaleData('companyValues');
    final count = random.nextInt(3) + 3; // 3-5 values
    final shuffled = List<String>.from(allValues)..shuffle(random.random);
    return shuffled.take(count).toList();
  }

  List<String> _getLocaleData(String key) {
    switch (currentLocale) {
      case 'zh_TW':
        return _zhTWData[key] ?? _enUSData[key] ?? [];
      case 'ja_JP':
        return _jaJPData[key] ?? _enUSData[key] ?? [];
      default:
        return _enUSData[key] ?? [];
    }
  }

  static final Map<String, List<String>> _enUSData = {
    'names': [
      'Innovative Solutions', 'Tech Dynamics', 'Global Systems', 'Prime Industries',
      'NextGen Technologies', 'Digital Ventures', 'Smart Analytics', 'Cloud Nine',
      'Quantum Computing', 'AI Innovations', 'Data Dynamics', 'Cyber Security Plus',
      'Future Forward', 'Synergy Systems', 'Alpha Technologies', 'Beta Solutions',
      'Gamma Industries', 'Delta Dynamics', 'Epsilon Enterprises', 'Zeta Zone',
    ],
    'suffixes': [
      'Inc.', 'LLC', 'Corp.', 'Ltd.', 'Group', 'Holdings', 'Partners',
    ],
    'catchphraseTemplates': [
      '{adjective} {descriptor} {noun}',
      '{descriptor} {adjective} {noun}',
    ],
    'catchphraseAdjectives': [
      'Advanced', 'Innovative', 'Streamlined', 'Optimized', 'Integrated',
      'Scalable', 'Robust', 'Flexible', 'Dynamic', 'Cutting-edge',
    ],
    'catchphraseDescriptors': [
      'next-generation', 'cross-platform', 'distributed', 'cloud-based',
      'mobile-first', 'data-driven', 'AI-powered', 'blockchain-enabled',
    ],
    'catchphraseNouns': [
      'solutions', 'systems', 'platforms', 'applications', 'frameworks',
      'technologies', 'infrastructures', 'architectures', 'networks',
    ],
    'buzzwords': [
      'synergy', 'leverage', 'paradigm', 'transform', 'disrupt',
      'innovate', 'optimize', 'streamline', 'scale', 'pivot',
      'agile', 'blockchain', 'AI', 'machine learning', 'cloud',
    ],
    'bsVerbs': [
      'leverage', 'optimize', 'streamline', 'implement', 'transform',
      'enable', 'orchestrate', 'aggregate', 'integrate', 'syndicate',
    ],
    'bsAdjectives': [
      'strategic', 'scalable', 'distributed', 'seamless', 'robust',
      'revolutionary', 'innovative', 'disruptive', 'magnetic', 'dynamic',
    ],
    'bsNouns': [
      'synergies', 'platforms', 'initiatives', 'channels', 'solutions',
      'technologies', 'paradigms', 'models', 'networks', 'metrics',
    ],
    'industries': [
      'Technology', 'Healthcare', 'Finance', 'Retail', 'Manufacturing',
      'Education', 'Entertainment', 'Transportation', 'Energy', 'Agriculture',
      'Real Estate', 'Telecommunications', 'Hospitality', 'Automotive',
    ],
    'departments': [
      'Engineering', 'Sales', 'Marketing', 'Human Resources', 'Finance',
      'Operations', 'Customer Service', 'Research & Development', 'IT',
      'Legal', 'Product Management', 'Quality Assurance', 'Business Development',
    ],
    'missionTemplates': [
      'To {verb} {goal} through {value}',
      'Our mission is to {verb} {goal} while maintaining {value}',
      'We strive to {verb} {goal} by embracing {value}',
    ],
    'missionVerbs': [
      'deliver', 'provide', 'create', 'build', 'develop',
      'innovate', 'transform', 'revolutionize', 'empower', 'enable',
    ],
    'missionGoals': [
      'exceptional value', 'innovative solutions', 'world-class products',
      'outstanding service', 'sustainable growth', 'digital transformation',
      'customer success', 'market leadership', 'global impact',
    ],
    'missionValues': [
      'integrity', 'excellence', 'innovation', 'collaboration',
      'customer focus', 'sustainability', 'transparency', 'accountability',
    ],
    'companyValues': [
      'Innovation', 'Integrity', 'Excellence', 'Teamwork', 'Customer Focus',
      'Sustainability', 'Diversity', 'Quality', 'Transparency', 'Accountability',
      'Respect', 'Trust', 'Passion', 'Creativity', 'Leadership',
    ],
  };

  static final Map<String, List<String>> _zhTWData = {
    'names': [
      '創新科技', '全球系統', '智慧分析', '雲端九號', '量子計算',
      '人工智能創新', '數據動力', '網路安全加', '未來前進', '協同系統',
      '阿爾法科技', '貝塔解決方案', '伽瑪工業', '德爾塔動力', '艾普西隆企業',
    ],
    'suffixes': [
      '有限公司', '股份有限公司', '企業', '集團',
    ],
    'catchphraseTemplates': [
      '{adjective}{descriptor}{noun}',
    ],
    'catchphraseAdjectives': [
      '先進的', '創新的', '優化的', '整合的', '可擴展的',
      '強大的', '靈活的', '動態的', '尖端的',
    ],
    'catchphraseDescriptors': [
      '下一代', '跨平台', '分散式', '雲端',
      '行動優先', '數據驅動', 'AI驅動', '區塊鏈',
    ],
    'catchphraseNouns': [
      '解決方案', '系統', '平台', '應用程式', '框架',
      '技術', '基礎設施', '架構', '網路',
    ],
    'buzzwords': [
      '協同', '槓桿', '典範', '轉型', '顛覆',
      '創新', '優化', '精簡', '擴展', '轉向',
      '敏捷', '區塊鏈', 'AI', '機器學習', '雲端',
    ],
    'industries': [
      '科技', '醫療', '金融', '零售', '製造',
      '教育', '娛樂', '運輸', '能源', '農業',
      '房地產', '電信', '餐旅', '汽車',
    ],
    'departments': [
      '工程', '業務', '行銷', '人力資源', '財務',
      '營運', '客戶服務', '研發', '資訊',
      '法務', '產品管理', '品質保證', '業務開發',
    ],
    'missionTemplates': [
      '透過{value}來{verb}{goal}',
      '我們的使命是在維持{value}的同時{verb}{goal}',
      '我們努力通過擁抱{value}來{verb}{goal}',
    ],
    'missionVerbs': [
      '提供', '創造', '建立', '開發',
      '創新', '轉型', '革新', '賦能', '啟用',
    ],
    'missionGoals': [
      '卓越價值', '創新解決方案', '世界級產品',
      '優質服務', '永續成長', '數位轉型',
      '客戶成功', '市場領導', '全球影響',
    ],
    'missionValues': [
      '誠信', '卓越', '創新', '合作',
      '客戶導向', '永續', '透明', '責任',
    ],
    'companyValues': [
      '創新', '誠信', '卓越', '團隊合作', '客戶導向',
      '永續發展', '多元化', '品質', '透明度', '責任感',
      '尊重', '信任', '熱情', '創造力', '領導力',
    ],
  };

  static final Map<String, List<String>> _jaJPData = {
    'names': [
      'イノベーティブソリューションズ', 'テックダイナミクス', 'グローバルシステムズ',
      'プライムインダストリーズ', 'ネクストジェンテクノロジーズ', 'デジタルベンチャーズ',
      'スマートアナリティクス', 'クラウドナイン', 'クォンタムコンピューティング',
      'AIイノベーションズ', 'データダイナミクス', 'サイバーセキュリティプラス',
    ],
    'suffixes': [
      '株式会社', '有限会社', 'グループ', 'ホールディングス',
    ],
    'catchphraseTemplates': [
      '{adjective}{descriptor}{noun}',
    ],
    'catchphraseAdjectives': [
      '先進的な', '革新的な', '最適化された', '統合された', 'スケーラブルな',
      '堅牢な', '柔軟な', 'ダイナミックな', '最先端の',
    ],
    'catchphraseDescriptors': [
      '次世代', 'クロスプラットフォーム', '分散型', 'クラウドベース',
      'モバイルファースト', 'データドリブン', 'AI駆動', 'ブロックチェーン対応',
    ],
    'catchphraseNouns': [
      'ソリューション', 'システム', 'プラットフォーム', 'アプリケーション',
      'フレームワーク', 'テクノロジー', 'インフラ', 'アーキテクチャ', 'ネットワーク',
    ],
    'buzzwords': [
      'シナジー', 'レバレッジ', 'パラダイム', '変革', '破壊',
      'イノベーション', '最適化', '合理化', 'スケール', 'ピボット',
      'アジャイル', 'ブロックチェーン', 'AI', '機械学習', 'クラウド',
    ],
    'industries': [
      'テクノロジー', 'ヘルスケア', '金融', '小売', '製造',
      '教育', 'エンターテイメント', '運輸', 'エネルギー', '農業',
      '不動産', '通信', 'ホスピタリティ', '自動車',
    ],
    'departments': [
      'エンジニアリング', '営業', 'マーケティング', '人事', '財務',
      'オペレーション', 'カスタマーサービス', '研究開発', 'IT',
      '法務', 'プロダクトマネジメント', '品質保証', 'ビジネス開発',
    ],
    'missionTemplates': [
      '{value}を通じて{goal}を{verb}',
      '私たちの使命は{value}を維持しながら{goal}を{verb}ことです',
      '私たちは{value}を受け入れることで{goal}を{verb}ことに努めます',
    ],
    'missionVerbs': [
      '提供する', '創造する', '構築する', '開発する',
      '革新する', '変革する', '革命を起こす', '力を与える', '可能にする',
    ],
    'missionGoals': [
      '卓越した価値', '革新的なソリューション', '世界クラスの製品',
      '優れたサービス', '持続可能な成長', 'デジタル変革',
      '顧客の成功', '市場リーダーシップ', 'グローバルインパクト',
    ],
    'missionValues': [
      '誠実さ', '卓越性', 'イノベーション', 'コラボレーション',
      '顧客重視', '持続可能性', '透明性', '説明責任',
    ],
    'companyValues': [
      'イノベーション', '誠実', '卓越', 'チームワーク', '顧客重視',
      '持続可能性', '多様性', '品質', '透明性', '説明責任',
      '尊重', '信頼', '情熱', '創造性', 'リーダーシップ',
    ],
  };
}