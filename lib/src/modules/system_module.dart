import '../core/locale_manager.dart';
import '../core/random_generator.dart';

/// Module for generating system-related data.
class SystemModule {
  /// Random generator instance for generating random values.
  final RandomGenerator random;
  
  /// Locale manager for handling localization.
  final LocaleManager localeManager;

  /// Creates a new instance of [SystemModule].
  /// 
  /// [random] is used for generating random values.
  /// [localeManager] handles localization of system data.
  SystemModule(this.random, this.localeManager);

  /// Gets the current locale code.
  String get currentLocale => localeManager.currentLocale;

  /// Generates a file name with extension.
  String fileName({String? extension}) {
    final name = random.element(_fileNames);
    final ext = extension ?? fileExtension();
    return '$name.$ext';
  }

  /// Generates a file extension.
  String fileExtension() {
    return random.element(_extensions);
  }

  /// Generates a file path.
  String filePath({int depth = 3}) {
    final dirs = List.generate(depth, (_) => random.element(_directoryNames));
    final file = fileName();
    return '/${dirs.join('/')}/$file';
  }

  /// Generates a directory path.
  String directoryPath({int depth = 3}) {
    final dirs = List.generate(depth, (_) => random.element(_directoryNames));
    return '/${dirs.join('/')}/';
  }

  /// Generates a MIME type.
  String mimeType() {
    return random.element(_mimeTypes);
  }

  /// Generates a semantic version.
  String semver() {
    final major = random.nextInt(10);
    final minor = random.nextInt(20);
    final patch = random.nextInt(100);
    return '$major.$minor.$patch';
  }

  /// Generates a semantic version with prerelease.
  String semverPrerelease() {
    final version = semver();
    final prerelease = random.element(['alpha', 'beta', 'rc']);
    final build = random.nextInt(10);
    return '$version-$prerelease.$build';
  }

  /// Generates a process name.
  String processName() {
    return random.element(_processNames);
  }

  /// Generates a cron expression.
  String cron() {
    final minute = random.nextBool() ? '*' : random.nextInt(60).toString();
    final hour = random.nextBool() ? '*' : random.nextInt(24).toString();
    final dayOfMonth = random.nextBool() ? '*' : random.nextInt(31).toString();
    final month = random.nextBool() ? '*' : random.nextInt(12).toString();
    final dayOfWeek = random.nextBool() ? '*' : random.nextInt(7).toString();
    
    return '$minute $hour $dayOfMonth $month $dayOfWeek';
  }

  /// Generates an environment variable name.
  String environmentVariable() {
    return random.element(_environmentVariables);
  }

  /// Generates an operating system name.
  String operatingSystem() {
    return random.element(_operatingSystems);
  }

  static final List<String> _fileNames = [
    'document', 'report', 'data', 'config', 'settings', 'backup',
    'export', 'import', 'log', 'temp', 'cache', 'index',
    'readme', 'license', 'manifest', 'package', 'module', 'component',
    'service', 'controller', 'model', 'view', 'template', 'style',
  ];

  static final List<String> _extensions = [
    'txt', 'pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx',
    'jpg', 'jpeg', 'png', 'gif', 'svg', 'bmp', 'ico',
    'mp3', 'mp4', 'avi', 'mov', 'wmv', 'flv',
    'zip', 'rar', '7z', 'tar', 'gz',
    'html', 'css', 'js', 'ts', 'jsx', 'tsx',
    'java', 'py', 'rb', 'php', 'go', 'rs', 'swift', 'kt',
    'json', 'xml', 'yaml', 'yml', 'toml', 'ini', 'conf',
    'sql', 'db', 'sqlite',
  ];

  static final List<String> _directoryNames = [
    'home', 'usr', 'var', 'etc', 'tmp', 'opt', 'bin', 'lib',
    'documents', 'downloads', 'pictures', 'videos', 'music',
    'desktop', 'public', 'private', 'shared', 'backup',
    'src', 'dist', 'build', 'assets', 'static', 'media',
    'config', 'logs', 'cache', 'data', 'db', 'storage',
  ];

  static final List<String> _mimeTypes = [
    'application/json', 'application/xml', 'application/pdf',
    'application/zip', 'application/x-rar-compressed',
    'text/plain', 'text/html', 'text/css', 'text/javascript',
    'text/csv', 'text/xml',
    'image/jpeg', 'image/png', 'image/gif', 'image/svg+xml',
    'image/webp', 'image/bmp',
    'audio/mpeg', 'audio/wav', 'audio/ogg', 'audio/webm',
    'video/mp4', 'video/mpeg', 'video/webm', 'video/ogg',
  ];

  static final List<String> _processNames = [
    'node', 'python', 'java', 'chrome', 'firefox', 'safari',
    'systemd', 'nginx', 'apache', 'mysql', 'postgres', 'redis',
    'docker', 'kubernetes', 'git', 'vscode', 'sublime', 'atom',
    'slack', 'zoom', 'teams', 'outlook', 'thunderbird',
    'spotify', 'vlc', 'steam', 'discord',
  ];

  static final List<String> _environmentVariables = [
    'PATH', 'HOME', 'USER', 'SHELL', 'TERM', 'LANG', 'LC_ALL',
    'NODE_ENV', 'JAVA_HOME', 'PYTHON_PATH', 'GOPATH',
    'DATABASE_URL', 'API_KEY', 'SECRET_KEY', 'AUTH_TOKEN',
    'DEBUG', 'VERBOSE', 'LOG_LEVEL', 'PORT', 'HOST',
    'TEMP', 'TMP', 'TMPDIR', 'CACHE_DIR',
  ];

  static final List<String> _operatingSystems = [
    'Windows', 'macOS', 'Linux', 'Ubuntu', 'Debian', 'Fedora',
    'CentOS', 'RedHat', 'openSUSE', 'Arch Linux',
    'Android', 'iOS', 'Windows Phone',
    'FreeBSD', 'OpenBSD', 'NetBSD',
  ];
}