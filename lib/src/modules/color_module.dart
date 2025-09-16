import '../core/locale_manager.dart';
import '../core/random_generator.dart';

/// Module for generating color-related data.
class ColorModule {
  /// Random generator instance for generating random values.
  final RandomGenerator random;

  /// Locale manager for handling localization.
  final LocaleManager localeManager;

  /// Creates a new instance of [ColorModule].
  ///
  /// [random] is used for generating random values.
  /// [localeManager] handles localization of color names.
  ColorModule(this.random, this.localeManager);

  /// Gets the current locale code.
  String get currentLocale => localeManager.currentLocale;

  /// Generates a hex color code.
  String hex({bool includeAlpha = false}) {
    if (includeAlpha) {
      return '#${random.hexString(length: 8).toUpperCase()}';
    }
    return '#${random.hexString(length: 6).toUpperCase()}';
  }

  /// Alias for hex() - generates a hex color code
  String hexColor({bool includeAlpha = false}) =>
      hex(includeAlpha: includeAlpha);

  /// Generates an RGB color string.
  String rgb() {
    final r = random.integer(min: 0, max: 255);
    final g = random.integer(min: 0, max: 255);
    final b = random.integer(min: 0, max: 255);
    return 'rgb($r, $g, $b)';
  }

  /// Generates an RGBA color string.
  String rgba() {
    final r = random.integer(min: 0, max: 255);
    final g = random.integer(min: 0, max: 255);
    final b = random.integer(min: 0, max: 255);
    final a = alpha();
    return 'rgba($r, $g, $b, $a)';
  }

  /// Generates an HSL color string.
  String hsl() {
    final h = hue();
    final s = saturation();
    final l = lightness();
    return 'hsl($h, $s%, $l%)';
  }

  /// Generates an HSLA color string.
  String hsla() {
    final h = hue();
    final s = saturation();
    final l = lightness();
    final a = alpha();
    return 'hsla($h, $s%, $l%, $a)';
  }

  /// Generates an HSV color string.
  String hsv() {
    final h = hue();
    final s = saturation();
    final v = random.integer(min: 0, max: 100);
    return 'hsv($h, $s%, $v%)';
  }

  /// Generates a CMYK color string.
  String cmyk() {
    final c = random.integer(min: 0, max: 100);
    final m = random.integer(min: 0, max: 100);
    final y = random.integer(min: 0, max: 100);
    final k = random.integer(min: 0, max: 100);
    return 'cmyk($c%, $m%, $y%, $k%)';
  }

  /// Generates a CSS color name.
  String cssName() {
    return random.element(_cssColors);
  }

  /// Generates a Material Design color.
  String material() {
    final palette = random.element(_materialPalettes);
    final shade = random.element(_materialShades);
    return '$palette[$shade]';
  }

  /// Generates a Tailwind CSS color.
  String tailwind() {
    final color = random.element(_tailwindColors);
    final shade = random.element(_tailwindShades);
    return '$color-$shade';
  }

  /// Generates a random color.
  String randomColor() {
    return hex();
  }

  /// Generates a warm color.
  String warm() {
    // Warm colors have hues in the red-yellow range (0-60, 300-360)
    final h = random.boolean()
        ? random.integer(min: 0, max: 60)
        : random.integer(min: 300, max: 360);
    final s = random.integer(min: 50, max: 100);
    final l = random.integer(min: 40, max: 70);
    return _hslToHex(h, s, l);
  }

  /// Generates a cool color.
  String cool() {
    // Cool colors have hues in the green-blue range (120-240)
    final h = random.integer(min: 120, max: 240);
    final s = random.integer(min: 50, max: 100);
    final l = random.integer(min: 40, max: 70);
    return _hslToHex(h, s, l);
  }

  /// Generates a pastel color.
  String pastel() {
    final h = hue();
    final s = random.integer(min: 20, max: 40);
    final l = random.integer(min: 70, max: 90);
    return _hslToHex(h, s, l);
  }

  /// Generates a vibrant color.
  String vibrant() {
    final h = hue();
    final s = random.integer(min: 80, max: 100);
    final l = random.integer(min: 40, max: 60);
    return _hslToHex(h, s, l);
  }

  /// Generates a dark color.
  String dark() {
    final h = hue();
    final s = random.integer(min: 20, max: 80);
    final l = random.integer(min: 10, max: 30);
    return _hslToHex(h, s, l);
  }

  /// Generates a light color.
  String light() {
    final h = hue();
    final s = random.integer(min: 20, max: 80);
    final l = random.integer(min: 70, max: 95);
    return _hslToHex(h, s, l);
  }

  /// Generates a monochromatic color scheme.
  List<String> monochromatic() {
    final baseHue = hue();
    final baseSat = random.integer(min: 40, max: 80);

    return List.generate(5, (i) {
      final lightness = 20 + (i * 15);
      return _hslToHex(baseHue, baseSat, lightness);
    });
  }

  /// Generates an analogous color scheme.
  List<String> analogous() {
    final baseHue = hue();
    final sat = random.integer(min: 50, max: 80);
    final light = random.integer(min: 40, max: 60);

    return [
      _hslToHex(baseHue, sat, light),
      _hslToHex((baseHue + 30) % 360, sat, light),
      _hslToHex((baseHue - 30 + 360) % 360, sat, light),
    ];
  }

  /// Generates a complementary color scheme.
  List<String> complementary() {
    final baseHue = hue();
    final sat = random.integer(min: 50, max: 80);
    final light = random.integer(min: 40, max: 60);

    return [
      _hslToHex(baseHue, sat, light),
      _hslToHex((baseHue + 180) % 360, sat, light),
    ];
  }

  /// Generates a triadic color scheme.
  List<String> triadic() {
    final baseHue = hue();
    final sat = random.integer(min: 50, max: 80);
    final light = random.integer(min: 40, max: 60);

    return [
      _hslToHex(baseHue, sat, light),
      _hslToHex((baseHue + 120) % 360, sat, light),
      _hslToHex((baseHue + 240) % 360, sat, light),
    ];
  }

  /// Generates a tetradic color scheme.
  List<String> tetradic() {
    final baseHue = hue();
    final sat = random.integer(min: 50, max: 80);
    final light = random.integer(min: 40, max: 60);

    return [
      _hslToHex(baseHue, sat, light),
      _hslToHex((baseHue + 90) % 360, sat, light),
      _hslToHex((baseHue + 180) % 360, sat, light),
      _hslToHex((baseHue + 270) % 360, sat, light),
    ];
  }

  /// Generates a split complementary color scheme.
  List<String> splitComplementary() {
    final baseHue = hue();
    final sat = random.integer(min: 50, max: 80);
    final light = random.integer(min: 40, max: 60);

    return [
      _hslToHex(baseHue, sat, light),
      _hslToHex((baseHue + 150) % 360, sat, light),
      _hslToHex((baseHue + 210) % 360, sat, light),
    ];
  }

  /// Generates a hue value (0-360).
  int hue() {
    return random.integer(min: 0, max: 360);
  }

  /// Generates a saturation value (0-100).
  int saturation() {
    return random.integer(min: 0, max: 100);
  }

  /// Generates a lightness value (0-100).
  int lightness() {
    return random.integer(min: 0, max: 100);
  }

  /// Generates an alpha value (0.0-1.0).
  double alpha() {
    return random.nextDouble();
  }

  /// Converts HSL to hex color.
  String _hslToHex(int h, int s, int l) {
    final hNorm = h / 360.0;
    final sNorm = s / 100.0;
    final lNorm = l / 100.0;

    double r, g, b;

    if (sNorm == 0) {
      r = g = b = lNorm;
    } else {
      double hue2rgb(double p, double q, double t) {
        if (t < 0) t += 1;
        if (t > 1) t -= 1;
        if (t < 1 / 6) return p + (q - p) * 6 * t;
        if (t < 1 / 2) return q;
        if (t < 2 / 3) return p + (q - p) * (2 / 3 - t) * 6;
        return p;
      }

      final q =
          lNorm < 0.5 ? lNorm * (1 + sNorm) : lNorm + sNorm - lNorm * sNorm;
      final p = 2 * lNorm - q;

      r = hue2rgb(p, q, hNorm + 1 / 3);
      g = hue2rgb(p, q, hNorm);
      b = hue2rgb(p, q, hNorm - 1 / 3);
    }

    final rInt = (r * 255).round();
    final gInt = (g * 255).round();
    final bInt = (b * 255).round();

    return '#${rInt.toRadixString(16).padLeft(2, '0').toUpperCase()}'
        '${gInt.toRadixString(16).padLeft(2, '0').toUpperCase()}'
        '${bInt.toRadixString(16).padLeft(2, '0').toUpperCase()}';
  }

  static final List<String> _cssColors = [
    'red',
    'green',
    'blue',
    'yellow',
    'orange',
    'purple',
    'pink',
    'brown',
    'black',
    'white',
    'gray',
    'cyan',
    'magenta',
    'lime',
    'indigo',
    'violet',
    'turquoise',
    'gold',
    'silver',
    'maroon',
    'navy',
    'teal',
    'olive',
    'aqua',
    'fuchsia',
    'crimson',
    'coral',
    'salmon',
    'khaki',
    'lavender',
    'plum',
    'mint',
    'ivory',
    'pearl',
  ];

  static final List<String> _materialPalettes = [
    'red',
    'pink',
    'purple',
    'deepPurple',
    'indigo',
    'blue',
    'lightBlue',
    'cyan',
    'teal',
    'green',
    'lightGreen',
    'lime',
    'yellow',
    'amber',
    'orange',
    'deepOrange',
    'brown',
    'grey',
    'blueGrey',
  ];

  static final List<String> _materialShades = [
    '50',
    '100',
    '200',
    '300',
    '400',
    '500',
    '600',
    '700',
    '800',
    '900',
  ];

  static final List<String> _tailwindColors = [
    'slate',
    'gray',
    'zinc',
    'neutral',
    'stone',
    'red',
    'orange',
    'amber',
    'yellow',
    'lime',
    'green',
    'emerald',
    'teal',
    'cyan',
    'sky',
    'blue',
    'indigo',
    'violet',
    'purple',
    'fuchsia',
    'pink',
    'rose',
  ];

  static final List<String> _tailwindShades = [
    '50',
    '100',
    '200',
    '300',
    '400',
    '500',
    '600',
    '700',
    '800',
    '900',
    '950',
  ];
}
