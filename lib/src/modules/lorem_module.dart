import '../core/locale_manager.dart';
import '../core/random_generator.dart';

/// Module for generating lorem ipsum and random text.
class LoremModule {
  /// Random generator instance for generating random values.
  final RandomGenerator random;

  /// Locale manager for handling localization.
  final LocaleManager localeManager;

  /// Creates a new instance of [LoremModule].
  ///
  /// [random] is used for generating random values.
  /// [localeManager] handles localization of lorem text.
  LoremModule(this.random, this.localeManager);

  /// Gets the current locale code.
  String get currentLocale => localeManager.currentLocale;

  /// Generates a random word.
  String word() {
    final words = _getLocaleData('words');
    return random.element(words);
  }

  /// Generates multiple words.
  String words({int count = 3}) {
    return List.generate(count, (_) => word()).join(' ');
  }

  /// Generates a sentence.
  String sentence({int? wordCount}) {
    final actualWordCount = wordCount ?? random.integer(min: 4, max: 16);
    final variance = random.integer(min: -2, max: 2);
    final finalCount = (actualWordCount + variance).clamp(1, 20);

    final sentenceWords = List.generate(finalCount, (_) => word());

    // Capitalize first word
    if (sentenceWords.isNotEmpty) {
      sentenceWords[0] =
          sentenceWords[0][0].toUpperCase() + sentenceWords[0].substring(1);
    }

    return '${sentenceWords.join(' ')}.';
  }

  /// Generates multiple sentences.
  String sentences({int count = 3}) {
    return List.generate(count, (_) => sentence()).join(' ');
  }

  /// Generates a paragraph.
  String paragraph({int? sentenceCount}) {
    final actualCount = sentenceCount ?? random.integer(min: 3, max: 7);
    final variance = random.integer(min: -1, max: 1);
    final finalCount = (actualCount + variance).clamp(1, 10);

    return List.generate(finalCount, (_) => sentence()).join(' ');
  }

  /// Generates multiple paragraphs.
  String paragraphs({int count = 3, String separator = '\n\n'}) {
    return List.generate(count, (_) => paragraph()).join(separator);
  }

  /// Generates text up to a maximum length.
  String text({int maxLength = 200}) {
    final result = StringBuffer();

    while (result.length < maxLength) {
      if (result.isNotEmpty) {
        result.write(' ');
      }

      if (result.length + 100 < maxLength) {
        result.write(sentence());
      } else {
        result.write(word());
      }

      if (result.length >= maxLength) {
        break;
      }
    }

    String text = result.toString();
    if (text.length > maxLength) {
      text = text.substring(0, maxLength);
      // Find last complete word
      final lastSpace = text.lastIndexOf(' ');
      if (lastSpace > 0) {
        text = text.substring(0, lastSpace);
      }
      text += '.';
    }

    return text;
  }

  /// Generates lines of text.
  String lines({int count = 3}) {
    return List.generate(count, (_) => sentence()).join('\n');
  }

  /// Generates a slug (URL-friendly string).
  String slug({int wordCount = 3}) {
    return List.generate(wordCount, (_) => word()).join('-');
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
    'words': [
      'lorem',
      'ipsum',
      'dolor',
      'sit',
      'amet',
      'consectetur',
      'adipiscing',
      'elit',
      'sed',
      'do',
      'eiusmod',
      'tempor',
      'incididunt',
      'ut',
      'labore',
      'et',
      'dolore',
      'magna',
      'aliqua',
      'enim',
      'ad',
      'minim',
      'veniam',
      'quis',
      'nostrud',
      'exercitation',
      'ullamco',
      'laboris',
      'nisi',
      'aliquip',
      'ex',
      'ea',
      'commodo',
      'consequat',
      'duis',
      'aute',
      'irure',
      'in',
      'reprehenderit',
      'voluptate',
      'velit',
      'esse',
      'cillum',
      'fugiat',
      'nulla',
      'pariatur',
      'excepteur',
      'sint',
      'occaecat',
      'cupidatat',
      'non',
      'proident',
      'sunt',
      'culpa',
      'qui',
      'officia',
      'deserunt',
      'mollit',
      'anim',
      'id',
      'est',
      'laborum',
      'perspiciatis',
      'unde',
      'omnis',
      'iste',
      'natus',
      'error',
      'voluptatem',
      'accusantium',
      'doloremque',
      'laudantium',
      'totam',
      'rem',
      'aperiam',
      'eaque',
      'ipsa',
      'quae',
      'ab',
      'illo',
      'inventore',
      'veritatis',
      'quasi',
      'architecto',
      'beatae',
      'vitae',
      'dicta',
      'explicabo',
      'nemo',
      'enim',
      'ipsam',
      'quia',
      'voluptas',
      'aspernatur',
      'aut',
      'odit',
      'fugit',
      'consequuntur',
      'magni',
      'dolores',
      'eos',
      'ratione',
      'sequi',
      'nesciunt',
      'neque',
      'porro',
      'quisquam',
      'dolorem',
      'adipisci',
      'numquam',
      'eius',
      'modi',
      'tempora',
      'incidunt',
      'magnam',
      'quaerat',
      'minima',
      'nostrum',
      'exercitationem',
      'ullam',
      'corporis',
      'suscipit',
      'laboriosam',
      'aliquid',
      'commodi',
      'consequatur',
      'autem',
      'vel',
      'eum',
      'iure',
      'reprehenderit',
      'voluptate',
      'velit',
      'quam',
      'nihil',
      'molestiae',
      'illum',
      'quo',
      'fugiat',
      'pariatur',
    ],
  };

  static final Map<String, List<String>> _zhTWData = {
    'words': [
      '隨機',
      '文字',
      '生成',
      '測試',
      '資料',
      '範例',
      '內容',
      '段落',
      '文章',
      '標題',
      '描述',
      '說明',
      '介紹',
      '概要',
      '摘要',
      '評論',
      '分析',
      '報告',
      '研究',
      '調查',
      '統計',
      '數據',
      '圖表',
      '結果',
      '方法',
      '過程',
      '步驟',
      '流程',
      '系統',
      '功能',
      '特性',
      '優點',
      '缺點',
      '比較',
      '對比',
      '差異',
      '相同',
      '類似',
      '關聯',
      '連結',
      '參考',
      '來源',
      '引用',
      '註解',
      '備註',
      '提示',
      '警告',
      '錯誤',
      '成功',
      '失敗',
      '完成',
      '開始',
      '結束',
      '繼續',
      '暫停',
      '停止',
      '更新',
      '修改',
      '刪除',
      '新增',
      '建立',
      '設定',
      '配置',
      '調整',
      '優化',
      '改善',
      '提升',
      '降低',
      '增加',
      '減少',
      '擴展',
      '縮小',
      '開啟',
      '關閉',
      '啟用',
      '停用',
      '顯示',
      '隱藏',
      '載入',
      '儲存',
      '匯出',
      '匯入',
      '備份',
      '還原',
      '復原',
      '重置',
      '清除',
      '確認',
      '取消',
      '提交',
      '送出',
      '接收',
      '發送',
      '傳輸',
      '下載',
      '上傳',
      '安裝',
      '解除',
      '執行',
      '運行',
      '處理',
      '計算',
      '驗證',
      '檢查',
    ],
  };

  static final Map<String, List<String>> _jaJPData = {
    'words': [
      'これ',
      'それ',
      'あれ',
      'この',
      'その',
      'あの',
      'ここ',
      'そこ',
      'あそこ',
      'こちら',
      'そちら',
      'あちら',
      'どこ',
      'だれ',
      'なに',
      'いつ',
      'どう',
      'なぜ',
      'どちら',
      'いくつ',
      'いくら',
      'ありがとう',
      'すみません',
      'ごめんなさい',
      'はい',
      'いいえ',
      'おはよう',
      'こんにちは',
      'こんばんは',
      'さようなら',
      'またね',
      'おやすみ',
      'いただきます',
      'ごちそうさま',
      'お願いします',
      '失礼します',
      'お疲れ様',
      'がんばって',
      'おめでとう',
      'ようこそ',
      'いらっしゃい',
      'ただいま',
      'おかえり',
      'わかりました',
      'わかりません',
      'できます',
      'できません',
      'あります',
      'ありません',
      'います',
      'いません',
      '大丈夫',
      '問題',
      '質問',
      '答え',
      '説明',
      '理解',
      '勉強',
      '仕事',
      '会社',
      '学校',
      '家',
      '部屋',
      '机',
      '椅子',
      '本',
      '新聞',
      '雑誌',
      'テレビ',
      'ラジオ',
      'パソコン',
      '電話',
      '携帯',
      'メール',
      'インターネット',
      'ウェブサイト',
      'アプリ',
      'ソフトウェア',
      'ハードウェア',
      'システム',
      'プログラム',
      'データ',
      'ファイル',
      'フォルダ',
      'ドキュメント',
      'ダウンロード',
      'アップロード',
      'インストール',
      'アンインストール',
      '更新',
      '削除',
      '作成',
      '編集',
      '保存',
      '開く',
      '閉じる',
      '実行',
      '停止',
      '開始',
      '終了',
      '続ける',
    ],
  };
}
