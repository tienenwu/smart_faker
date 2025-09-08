import '../core/random_generator.dart';
import '../core/locale_manager.dart';

/// Module for generating social media-related data.
class SocialMediaModule {
  /// Random generator instance for generating random values.
  final RandomGenerator random;

  /// Locale manager for handling localization.
  final LocaleManager localeManager;

  /// Creates a new instance of [SocialMediaModule].
  ///
  /// [random] is used for generating random values.
  /// [localeManager] handles localization of social media data.
  SocialMediaModule(this.random, this.localeManager);

  /// Generates a social media username.
  ///
  /// Returns a username with optional @ symbol.
  String username({bool includeAt = true}) {
    final adjectives = [
      'cool',
      'super',
      'mega',
      'ultra',
      'pro',
      'elite',
      'master',
      'epic',
      'legend',
      'hero',
      'ninja',
      'wizard',
      'dragon',
      'phoenix',
      'shadow',
      'cyber',
      'digital',
      'quantum',
      'cosmic',
      'stellar',
      'lunar',
      'solar'
    ];

    final nouns = [
      'gamer',
      'coder',
      'hacker',
      'player',
      'warrior',
      'knight',
      'samurai',
      'pilot',
      'racer',
      'hunter',
      'explorer',
      'artist',
      'creator',
      'builder',
      'dreamer',
      'thinker',
      'writer',
      'designer',
      'developer',
      'engineer'
    ];

    final formats = [
      () => '${random.element(adjectives)}_${random.element(nouns)}',
      () => '${random.element(nouns)}${random.integer(min: 1, max: 9999)}',
      () =>
          '${random.element(adjectives)}${random.element(nouns).substring(0, 3).toUpperCase()}${random.integer(min: 10, max: 99)}',
      () => '${random.element(nouns)}_${random.integer(min: 2000, max: 2025)}',
      () => 'the_${random.element(adjectives)}_${random.element(nouns)}',
    ];

    final username = random.element(formats)();
    return includeAt ? '@$username' : username;
  }

  /// Generates a social media post content.
  ///
  /// Returns realistic post text based on locale.
  String post() {
    switch (localeManager.currentLocale) {
      case 'zh_TW':
        return random.element([
          '今天天氣真好！☀️',
          '剛完成了一個新專案，感覺超棒的！',
          '週末要去哪裡玩呢？有推薦的嗎？',
          '分享一下今天的午餐 🍜',
          '最近在學Flutter，真的很有趣！',
          '誰說週一很憂鬱？保持正能量！💪',
          '咖啡時間到了 ☕',
          '生活就是要充滿驚喜！',
          '今天的夕陽好美 🌅',
          '推薦大家這家餐廳，真的很不錯！',
        ]);
      case 'ja_JP':
        return random.element([
          '今日もいい天気ですね！☀️',
          '新しいプロジェクトが完成しました！',
          '週末はどこに行きましょうか？',
          '今日のランチ 🍜',
          'Flutterの勉強が楽しいです！',
          '月曜日も頑張りましょう！💪',
          'コーヒータイム ☕',
          '人生は驚きに満ちている！',
          '今日の夕日が美しい 🌅',
          'このレストランおすすめです！',
        ]);
      default:
        return random.element([
          'What a beautiful day! ☀️',
          'Just finished an amazing project!',
          'Weekend plans anyone?',
          'Sharing my lunch today 🍜',
          'Learning Flutter and loving it!',
          'Monday motivation! 💪',
          'Coffee time ☕',
          'Life is full of surprises!',
          'Beautiful sunset today 🌅',
          'Highly recommend this restaurant!',
          'Working from my favorite cafe today',
          'Can\'t believe it\'s already Friday!',
          'New blog post is up! Check it out',
          'Grateful for all the support ❤️',
          'Time for some self-care this weekend',
        ]);
    }
  }

  /// Generates a hashtag.
  ///
  /// Returns a single hashtag with # symbol.
  String hashtag() {
    final tags = [
      'flutter',
      'dart',
      'coding',
      'programming',
      'developer',
      'tech',
      'startup',
      'entrepreneur',
      'innovation',
      'creative',
      'design',
      'motivation',
      'inspiration',
      'success',
      'goals',
      'lifestyle',
      'photography',
      'travel',
      'food',
      'fitness',
      'health',
      'wellness',
      'art',
      'music',
      'fashion',
      'beauty',
      'nature',
      'adventure',
      'love',
      'happy',
      'blessed',
      'grateful',
      'mindfulness',
      'positivity',
      'work',
      'career',
      'business',
      'marketing',
      'growth',
      'learning',
      'weekend',
      'monday',
      'friday',
      'summer',
      'winter',
      'spring',
    ];

    final tag = random.element(tags);

    // Sometimes make it compound or with year
    if (random.boolean(probability: 0.3)) {
      final suffixes = [
        '2024',
        '2025',
        'life',
        'lover',
        'vibes',
        'mood',
        'daily'
      ];
      return '#${tag}${random.element(suffixes)}';
    }

    return '#$tag';
  }

  /// Generates multiple hashtags.
  ///
  /// [count] specifies how many hashtags to generate.
  List<String> hashtags(int count) {
    final tags = <String>{};
    while (tags.length < count) {
      tags.add(hashtag());
    }
    return tags.toList();
  }

  /// Generates a number of likes.
  ///
  /// Returns a realistic like count based on tier.
  int likes({String tier = 'normal'}) {
    switch (tier) {
      case 'micro': // Micro influencer
        return random.integer(min: 10, max: 500);
      case 'small': // Small account
        return random.integer(min: 500, max: 5000);
      case 'medium': // Medium account
        return random.integer(min: 5000, max: 50000);
      case 'large': // Large account
        return random.integer(min: 50000, max: 500000);
      case 'viral': // Viral post
        return random.integer(min: 500000, max: 5000000);
      default: // Normal user
        return random.integer(min: 0, max: 500);
    }
  }

  /// Generates a number of comments.
  ///
  /// Usually 5-10% of likes.
  int comments({int? basedOnLikes}) {
    if (basedOnLikes != null) {
      final percentage = random.decimal(min: 0.05, max: 0.15);
      return (basedOnLikes * percentage).round();
    }
    return random.integer(min: 0, max: 100);
  }

  /// Generates a number of shares.
  ///
  /// Usually 1-5% of likes.
  int shares({int? basedOnLikes}) {
    if (basedOnLikes != null) {
      final percentage = random.decimal(min: 0.01, max: 0.05);
      return (basedOnLikes * percentage).round();
    }
    return random.integer(min: 0, max: 50);
  }

  /// Generates a follower count.
  int followers({String tier = 'normal'}) {
    switch (tier) {
      case 'nano': // Nano influencer
        return random.integer(min: 100, max: 1000);
      case 'micro': // Micro influencer
        return random.integer(min: 1000, max: 10000);
      case 'mid': // Mid-tier influencer
        return random.integer(min: 10000, max: 100000);
      case 'macro': // Macro influencer
        return random.integer(min: 100000, max: 1000000);
      case 'mega': // Mega influencer
        return random.integer(min: 1000000, max: 10000000);
      default: // Normal user
        return random.integer(min: 50, max: 1000);
    }
  }

  /// Generates a following count.
  ///
  /// Usually 50-150% of followers for normal users.
  int following({int? followerCount}) {
    if (followerCount != null) {
      if (followerCount > 10000) {
        // Influencers follow fewer people
        return random.integer(min: 100, max: 5000);
      }
      final ratio = random.decimal(min: 0.5, max: 1.5);
      return (followerCount * ratio).round();
    }
    return random.integer(min: 50, max: 1000);
  }

  /// Generates a user bio.
  String bio() {
    switch (localeManager.currentLocale) {
      case 'zh_TW':
        final professions = [
          '工程師',
          '設計師',
          '攝影師',
          '作家',
          '藝術家',
          '創業家',
          '學生',
          '教師',
          '行銷專員',
          '內容創作者',
          '部落客',
          'KOL',
          '自由工作者',
          '顧問',
          '產品經理'
        ];

        final interests = [
          '咖啡愛好者',
          '旅遊達人',
          '美食家',
          '健身狂',
          '書蟲',
          '音樂迷',
          '科技宅',
          '大自然愛好者',
          '貓奴',
          '狗奴',
          '植物系',
          '冒險家',
          '追夢人',
          '生活探索家'
        ];

        final locations = [
          '📍 台北',
          '📍 台中',
          '📍 高雄',
          '📍 新竹',
          '📍 台南',
          '📍 Tokyo',
          '📍 NYC',
          '📍 Singapore',
          '📍 香港',
          '📍 首爾'
        ];

        final emojis = [
          '✨',
          '🌟',
          '💫',
          '🔥',
          '💪',
          '❤️',
          '🌈',
          '🎯',
          '🚀',
          '💡'
        ];

        final components = <String>[];

        if (random.boolean(probability: 0.8)) {
          components.add(random.element(professions));
        }
        if (random.boolean(probability: 0.7)) {
          components.add(random.element(interests));
        }
        if (random.boolean(probability: 0.5)) {
          components.add(random.element(locations));
        }
        if (random.boolean(probability: 0.6)) {
          components.add(random.element(emojis));
        }

        return components.join(' | ');

      case 'ja_JP':
        final professions = [
          'エンジニア',
          'デザイナー',
          'フォトグラファー',
          'ライター',
          'アーティスト',
          '起業家',
          '学生',
          '教師',
          'マーケター',
          'コンテンツクリエイター',
          'ブロガー',
          'インフルエンサー',
          'フリーランス',
          'コンサルタント',
          'プロダクトマネージャー'
        ];

        final interests = [
          'コーヒー好き',
          '旅行好き',
          'グルメ',
          'フィットネス',
          '読書好き',
          '音楽好き',
          'テック好き',
          '自然愛好家',
          '猫好き',
          '犬好き',
          '植物好き',
          '冒険家',
          '夢追い人',
          '探索家'
        ];

        final locations = [
          '📍 東京',
          '📍 大阪',
          '📍 京都',
          '📍 福岡',
          '📍 名古屋',
          '📍 横浜',
          '📍 神戸',
          '📍 札幌',
          '📍 仙台',
          '📍 沖縄'
        ];

        final emojis = [
          '✨',
          '🌟',
          '💫',
          '🔥',
          '💪',
          '❤️',
          '🌈',
          '🎯',
          '🚀',
          '💡'
        ];

        final components = <String>[];

        if (random.boolean(probability: 0.8)) {
          components.add(random.element(professions));
        }
        if (random.boolean(probability: 0.7)) {
          components.add(random.element(interests));
        }
        if (random.boolean(probability: 0.5)) {
          components.add(random.element(locations));
        }
        if (random.boolean(probability: 0.6)) {
          components.add(random.element(emojis));
        }

        return components.join(' | ');

      default:
        final professions = [
          'Developer',
          'Designer',
          'Photographer',
          'Writer',
          'Artist',
          'Entrepreneur',
          'Student',
          'Teacher',
          'Engineer',
          'Marketer',
          'Content Creator',
          'Blogger',
          'Influencer',
          'Freelancer',
          'Consultant'
        ];

        final interests = [
          'Coffee lover',
          'Travel enthusiast',
          'Food lover',
          'Fitness addict',
          'Book worm',
          'Music lover',
          'Tech geek',
          'Nature lover',
          'Dog parent',
          'Cat parent',
          'Plant parent',
          'Adventure seeker',
          'Dream chaser',
          'Life explorer',
          'Creative soul'
        ];

        final locations = [
          '📍 NYC',
          '📍 LA',
          '📍 London',
          '📍 Tokyo',
          '📍 Paris',
          '📍 Berlin',
          '📍 Singapore',
          '📍 Hong Kong',
          '📍 Taipei',
          '📍 Seoul',
          '📍 Bangkok'
        ];

        final emojis = [
          '✨',
          '🌟',
          '💫',
          '🔥',
          '💪',
          '❤️',
          '🌈',
          '🎯',
          '🚀',
          '💡'
        ];

        final components = <String>[];

        if (random.boolean(probability: 0.8)) {
          components.add(random.element(professions));
        }
        if (random.boolean(probability: 0.7)) {
          components.add(random.element(interests));
        }
        if (random.boolean(probability: 0.5)) {
          components.add(random.element(locations));
        }
        if (random.boolean(probability: 0.6)) {
          components.add(random.element(emojis));
        }

        return components.join(' | ');
    }
  }

  /// Generates an emoji.
  String emoji() {
    return random.element([
      '😀',
      '😃',
      '😄',
      '😁',
      '😊',
      '😍',
      '🥰',
      '😘',
      '🤗',
      '🤩',
      '😎',
      '🤓',
      '🧐',
      '😏',
      '😌',
      '😴',
      '😪',
      '🤤',
      '😋',
      '🤪',
      '❤️',
      '🧡',
      '💛',
      '💚',
      '💙',
      '💜',
      '🖤',
      '🤍',
      '🤎',
      '💔',
      '✨',
      '💫',
      '⭐',
      '🌟',
      '💥',
      '🔥',
      '🌈',
      '☀️',
      '🌤️',
      '⛅',
      '👍',
      '👎',
      '👌',
      '✌️',
      '🤞',
      '🤟',
      '🤘',
      '🤙',
      '👏',
      '🙌',
      '🎉',
      '🎊',
      '🎈',
      '🎁',
      '🎂',
      '🍰',
      '🧁',
      '🍪',
      '🍩',
      '🍕',
      '☕',
      '🍵',
      '🧋',
      '🍺',
      '🍻',
      '🥂',
      '🍷',
      '🥃',
      '🍸',
      '🍹',
    ]);
  }

  /// Generates a reaction emoji.
  String reaction() {
    return random.element([
      '❤️',
      '👍',
      '😆',
      '😮',
      '😢',
      '😡',
      '👏',
      '🔥',
      '🎉',
      '💯',
      '❤️‍🔥',
      '💔',
      '❤️‍🩹',
      '💕',
      '💖',
      '💗',
      '💓',
      '💝',
      '🤍',
      '🖤'
    ]);
  }

  /// Generates story views count.
  int storyViews() {
    return random.integer(min: 10, max: 5000);
  }

  /// Generates a social media platform name.
  String platform() {
    return random.element([
      'Instagram',
      'Facebook',
      'Twitter',
      'LinkedIn',
      'TikTok',
      'YouTube',
      'Snapchat',
      'Pinterest',
      'Reddit',
      'Threads',
      'Discord',
      'Telegram',
      'WhatsApp',
      'WeChat',
      'Line'
    ]);
  }

  /// Generates verification status.
  bool verified({double probability = 0.1}) {
    return random.boolean(probability: probability);
  }

  /// Generates a comment text.
  String comment() {
    return random.element([
      'Great post! 👍',
      'Love this! ❤️',
      'Amazing! 🔥',
      'So true!',
      'Couldn\'t agree more!',
      'This is awesome!',
      'Thanks for sharing!',
      'Inspiring! ✨',
      'Beautiful! 😍',
      'Well said!',
      'First! 🎉',
      'This made my day!',
      'So relatable!',
      'Goals! 💯',
      'Wow! Just wow!',
      'Can\'t wait to try this!',
      'Bookmarking this!',
      'Needed to hear this today',
      'You\'re the best!',
      'Keep it up! 💪',
    ]);
  }

  /// Generates an engagement rate percentage.
  String engagementRate() {
    final rate = random.decimal(min: 0.5, max: 15.0);
    return '${rate.toStringAsFixed(2)}%';
  }

  /// Generates posting time.
  String postingTime() {
    final times = [
      'Just now',
      '1 minute ago',
      '5 minutes ago',
      '10 minutes ago',
      '30 minutes ago',
      '1 hour ago',
      '2 hours ago',
      '5 hours ago',
      '1 day ago',
      '2 days ago',
      '1 week ago',
    ];
    return random.element(times);
  }
}
