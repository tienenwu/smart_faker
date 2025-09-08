import '../core/locale_manager.dart';
import '../core/random_generator.dart';

/// Module for generating image-related data.
class ImageModule {
  /// Random generator instance for generating random values.
  final RandomGenerator random;

  /// Locale manager for handling localization.
  final LocaleManager localeManager;

  /// Creates a new instance of [ImageModule].
  ///
  /// [random] is used for generating random values.
  /// [localeManager] handles localization of image data.
  ImageModule(this.random, this.localeManager);

  /// Gets the current locale code.
  String get currentLocale => localeManager.currentLocale;

  /// Generates an image URL.
  String url({int? width, int? height, String? category}) {
    final w = width ?? random.integer(min: 200, max: 1920);
    final h = height ?? random.integer(min: 200, max: 1080);
    final cat = category ?? random.element(_categories);
    return 'https://source.unsplash.com/${w}x$h/?$cat';
  }

  /// Generates a placeholder image URL.
  String placeholder(
      {int? width,
      int? height,
      String? text,
      String? bgColor,
      String? textColor}) {
    final w = width ?? random.integer(min: 200, max: 800);
    final h = height ?? random.integer(min: 200, max: 600);
    final t = text ?? '${w}x$h';
    final bg = bgColor ?? random.element(_placeholderColors);
    final tc = textColor ?? 'ffffff';
    return 'https://via.placeholder.com/${w}x$h/$bg/$tc?text=$t';
  }

  /// Generates an avatar URL.
  String avatar({int? size}) {
    final s = size ?? random.integer(min: 64, max: 512);
    final hash = random.hexString(length: 32);
    return 'https://www.gravatar.com/avatar/$hash?s=$s&d=identicon';
  }

  /// Generates a data URI for a small image.
  String dataUri({int? width, int? height}) {
    // Generate a simple 1x1 pixel PNG as base64
    const base64Png =
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==';
    return 'data:image/png;base64,$base64Png';
  }

  /// Generates a nature image URL.
  String nature({int? width, int? height}) {
    return url(width: width, height: height, category: 'nature');
  }

  /// Generates a people image URL.
  String people({int? width, int? height}) {
    return url(width: width, height: height, category: 'people');
  }

  /// Generates a technology image URL.
  String technology({int? width, int? height}) {
    return url(width: width, height: height, category: 'technology');
  }

  /// Generates a food image URL.
  String food({int? width, int? height}) {
    return url(width: width, height: height, category: 'food');
  }

  /// Generates a transport image URL.
  String transport({int? width, int? height}) {
    return url(width: width, height: height, category: 'transport');
  }

  /// Generates an animals image URL.
  String animals({int? width, int? height}) {
    return url(width: width, height: height, category: 'animals');
  }

  /// Generates a business image URL.
  String business({int? width, int? height}) {
    return url(width: width, height: height, category: 'business');
  }

  /// Generates a fashion image URL.
  String fashion({int? width, int? height}) {
    return url(width: width, height: height, category: 'fashion');
  }

  /// Generates a sports image URL.
  String sports({int? width, int? height}) {
    return url(width: width, height: height, category: 'sports');
  }

  /// Generates an abstract image URL.
  String abstract({int? width, int? height}) {
    return url(width: width, height: height, category: 'abstract');
  }

  /// Generates a hex color code.
  String hexColor() {
    return '#${random.hexString(length: 6).toUpperCase()}';
  }

  /// Generates an RGB color string.
  String rgbColor() {
    final r = random.nextInt(256);
    final g = random.nextInt(256);
    final b = random.nextInt(256);
    return 'rgb($r, $g, $b)';
  }

  /// Generates an HSL color string.
  String hslColor() {
    final h = random.nextInt(361);
    final s = random.integer(min: 0, max: 100);
    final l = random.integer(min: 0, max: 100);
    return 'hsl($h, $s%, $l%)';
  }

  /// Generates a local avatar as SVG data URI.
  ///
  /// Creates a customizable avatar with initials on a colored background.
  ///
  /// [name] - The name to display (uses first 2 letters if not provided)
  /// [size] - Avatar size (48, 64, 128, 256, 512)
  /// [shape] - 'circle' or 'square'
  /// [bgColor] - Background color (auto-generated if not provided)
  /// [textColor] - Text color (auto-generated if not provided)
  String localAvatar({
    String? name,
    int? size,
    String shape = 'circle',
    String? bgColor,
    String? textColor,
  }) {
    // Generate a random name if not provided
    final displayName = name ?? _generateRandomInitials();

    // Use standard avatar sizes
    final int avatarSize = size ?? random.element([48, 64, 128, 256, 512]);

    // Generate colors if not provided
    final bg = bgColor ?? _generateVibrantColor();
    final text = textColor ?? _getContrastingColor(bg);

    // Calculate font size based on avatar size
    final fontSize = (avatarSize * 0.4).round();

    // Create shape-specific attributes
    final shapeElement = shape == 'circle'
        ? '<circle cx="${avatarSize / 2}" cy="${avatarSize / 2}" r="${avatarSize / 2}" fill="$bg"/>'
        : '<rect width="$avatarSize" height="$avatarSize" fill="$bg" rx="${avatarSize * 0.1}"/>';

    // Generate SVG
    final svg =
        '''<svg xmlns="http://www.w3.org/2000/svg" width="$avatarSize" height="$avatarSize" viewBox="0 0 $avatarSize $avatarSize">
  $shapeElement
  <text x="50%" y="50%" font-family="Arial, sans-serif" font-size="$fontSize" font-weight="600" text-anchor="middle" dominant-baseline="middle" fill="$text">$displayName</text>
</svg>''';

    // Convert to base64 data URI
    final base64Svg = _encodeBase64(svg);
    return 'data:image/svg+xml;base64,$base64Svg';
  }

  /// Generates random initials for avatar.
  String _generateRandomInitials() {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    if (random.nextBool()) {
      // Single letter
      return letters[random.nextInt(letters.length)];
    } else {
      // Two letters
      return letters[random.nextInt(letters.length)] +
          letters[random.nextInt(letters.length)];
    }
  }

  /// Generates a vibrant background color.
  String _generateVibrantColor() {
    final colors = [
      '#FF6B6B',
      '#4ECDC4',
      '#45B7D1',
      '#96CEB4',
      '#FFEAA7',
      '#DFE6E9',
      '#74B9FF',
      '#A29BFE',
      '#FD79A8',
      '#6C5CE7',
      '#FDCB6E',
      '#E17055',
      '#00B894',
      '#00CEC9',
      '#0984E3',
      '#6C5CE7',
      '#A29BFE',
      '#FD79A8',
      '#FDCB6E',
      '#E17055',
      '#00B894',
      '#00CEC9',
      '#0984E3',
      '#6C5CE7',
      '#FF7675',
      '#55A3FF',
      '#FD79A8',
      '#BADC58',
      '#F8B739',
      '#FA8231',
      '#EB3B5A',
      '#FC5C65',
      '#45AAF2',
      '#4B7BEC',
      '#A55EEA',
      '#26DE81',
      '#20BF6B',
      '#FD9644',
      '#F07C15',
      '#FC5C65',
    ];
    return random.element(colors);
  }

  /// Gets a contrasting text color for the given background.
  String _getContrastingColor(String bgColor) {
    // Simple contrast calculation
    final hex = bgColor.replaceAll('#', '');
    final r = int.parse(hex.substring(0, 2), radix: 16);
    final g = int.parse(hex.substring(2, 4), radix: 16);
    final b = int.parse(hex.substring(4, 6), radix: 16);

    // Calculate luminance
    final luminance = (0.299 * r + 0.587 * g + 0.114 * b) / 255;

    // Return white for dark backgrounds, dark color for light backgrounds
    return luminance > 0.5 ? '#2C3E50' : '#FFFFFF';
  }

  /// Encodes string to base64.
  String _encodeBase64(String input) {
    final bytes = input.codeUnits;
    final base64 = _base64Encode(bytes);
    return base64;
  }

  /// Simple base64 encoding implementation.
  String _base64Encode(List<int> bytes) {
    const base64Chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
    final result = StringBuffer();

    for (int i = 0; i < bytes.length; i += 3) {
      final b1 = bytes[i];
      final b2 = i + 1 < bytes.length ? bytes[i + 1] : 0;
      final b3 = i + 2 < bytes.length ? bytes[i + 2] : 0;

      final bitmap = (b1 << 16) | (b2 << 8) | b3;

      result.write(base64Chars[(bitmap >> 18) & 63]);
      result.write(base64Chars[(bitmap >> 12) & 63]);
      result
          .write(i + 1 < bytes.length ? base64Chars[(bitmap >> 6) & 63] : '=');
      result.write(i + 2 < bytes.length ? base64Chars[bitmap & 63] : '=');
    }

    return result.toString();
  }

  static final List<String> _categories = [
    'nature',
    'people',
    'technology',
    'food',
    'transport',
    'animals',
    'business',
    'fashion',
    'sports',
    'abstract',
    'architecture',
    'travel',
    'city',
    'night',
    'art',
  ];

  static final List<String> _placeholderColors = [
    'cccccc',
    '333333',
    '666666',
    '999999',
    'ff6b6b',
    '4ecdc4',
    '45b7d1',
    '96ceb4',
    'ffeaa7',
    'dfe6e9',
    'b2bec3',
    'fab1a0',
    'ff7675',
    '74b9ff',
    'a29bfe',
    'fd79a8',
    '6c5ce7',
    'fdcb6e',
    'e17055',
    '00b894',
  ];
}
