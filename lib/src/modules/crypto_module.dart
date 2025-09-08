import '../core/locale_manager.dart';
import '../core/random_generator.dart';

/// Module for generating cryptocurrency and blockchain-related data.
class CryptoModule {
  final RandomGenerator random;
  final LocaleManager localeManager;

  CryptoModule(this.random, this.localeManager);

  String get currentLocale => localeManager.currentLocale;

  /// Generates a Bitcoin address.
  String bitcoinAddress() {
    final type = random.element(['legacy', 'segwit', 'native-segwit']);
    switch (type) {
      case 'legacy':
        return '1${_generateBase58(random.integer(min: 25, max: 34))}';
      case 'segwit':
        return '3${_generateBase58(random.integer(min: 25, max: 34))}';
      case 'native-segwit':
        return 'bc1${_generateBech32(random.integer(min: 39, max: 39))}';
      default:
        return '1${_generateBase58(33)}';
    }
  }

  /// Generates an Ethereum address.
  String ethereumAddress() {
    return '0x${random.hexString(length: 40)}';
  }

  /// Generates a blockchain hash.
  String blockchainHash() {
    return random.hexString(length: 64);
  }

  /// Generates a transaction ID.
  String transactionId() {
    return random.hexString(length: 64);
  }

  /// Generates a block number.
  int blockNumber() {
    return random.integer(min: 1, max: 20000000);
  }

  /// Generates a gas price.
  String gasPrice() {
    final price = random.integer(min: 5, max: 500);
    return '$price gwei';
  }

  /// Generates a nonce.
  int nonce() {
    return random.integer(min: 0, max: 999999);
  }

  /// Generates a cryptocurrency name.
  String currencyName() {
    return random.element(_cryptoCurrencies);
  }

  /// Generates a cryptocurrency symbol.
  String currencySymbol() {
    return random.element(_cryptoSymbols);
  }

  /// Generates a cryptocurrency trading pair.
  String currencyPair() {
    final base = random.element(_cryptoSymbols);
    final quote = random.element(['USDT', 'BUSD', 'USDC', 'BTC', 'ETH']);
    return '$base/$quote';
  }

  /// Generates a cryptocurrency price.
  String price() {
    if (random.boolean()) {
      // Small price (altcoins)
      final price = random.nextDouble() * 100;
      return '\$${price.toStringAsFixed(4)}';
    } else {
      // Large price (BTC, ETH)
      final price = random.integer(min: 100, max: 100000);
      return '\$${price.toStringAsFixed(2)}';
    }
  }

  /// Generates a market cap.
  String marketCap() {
    final tier = random.element(['B', 'M', 'K']);
    switch (tier) {
      case 'B':
        final value = random.integer(min: 1, max: 999);
        return '\$$value${tier}';
      case 'M':
        final value = random.integer(min: 1, max: 999);
        return '\$$value${tier}';
      case 'K':
        final value = random.integer(min: 100, max: 999);
        return '\$$value${tier}';
      default:
        return '\$1B';
    }
  }

  /// Generates trading volume.
  String volume() {
    final tier = random.element(['B', 'M']);
    final value = random.integer(min: 1, max: 999);
    return '\$$value$tier';
  }

  /// Generates price change percentage.
  String priceChange() {
    final change = (random.nextDouble() * 40) - 20; // -20% to +20%
    final sign = change >= 0 ? '+' : '';
    return '$sign${change.toStringAsFixed(2)}%';
  }

  /// Generates a wallet seed phrase.
  String seedPhrase({int wordCount = 12}) {
    final words = <String>[];
    for (int i = 0; i < wordCount; i++) {
      words.add(random.element(_bip39Words));
    }
    return words.join(' ');
  }

  /// Generates a private key.
  String privateKey() {
    return random.hexString(length: 64);
  }

  /// Generates a public key.
  String publicKey() {
    return random.hexString(length: 128);
  }

  /// Generates a wallet balance.
  String balance() {
    final amount = random.nextDouble() * 1000;
    final symbol = random.element(_cryptoSymbols);
    return '${amount.toStringAsFixed(8)} $symbol';
  }

  /// Generates a hash rate.
  String hashRate() {
    final units = ['H/s', 'KH/s', 'MH/s', 'GH/s', 'TH/s', 'PH/s', 'EH/s'];
    final unit = random.element(units);
    final value = random.integer(min: 1, max: 999);
    return '$value $unit';
  }

  /// Generates mining difficulty.
  String difficulty() {
    final tier = random.element(['K', 'M', 'B', 'T']);
    final value = random.integer(min: 1, max: 999);
    return '$value$tier';
  }

  /// Generates a mining pool name.
  String miningPool() {
    return random.element(_miningPools);
  }

  /// Generates mining reward.
  String miningReward() {
    final amount = random.nextDouble() * 10;
    final symbol = random.element(['BTC', 'ETH', 'LTC']);
    return '${amount.toStringAsFixed(8)} $symbol';
  }

  /// Generates a DeFi protocol name.
  String defiProtocol() {
    return random.element(_defiProtocols);
  }

  /// Generates APY (Annual Percentage Yield).
  String apy() {
    final yield = random.nextDouble() * 200;
    return '${yield.toStringAsFixed(2)}%';
  }

  /// Generates TVL (Total Value Locked).
  String tvl() {
    final tier = random.element(['B', 'M']);
    final value = random.integer(min: 1, max: 999);
    return '\$$value$tier';
  }

  /// Generates liquidity amount.
  String liquidity() {
    final tier = random.element(['M', 'K']);
    final value = random.integer(min: 1, max: 999);
    return '\$$value$tier';
  }

  /// Generates an NFT token ID.
  int nftTokenId() {
    return random.integer(min: 1, max: 10000);
  }

  /// Generates an NFT collection name.
  String nftCollection() {
    final prefix = random.element(['Crypto', 'Bored', 'Cool', 'Doodle', 'Pixel', 'Meta']);
    final suffix = random.element(['Punks', 'Apes', 'Cats', 'Dogs', 'Bears', 'Lions', 'Art', 'Club']);
    return '$prefix $suffix';
  }

  /// Generates NFT rarity.
  String nftRarity() {
    return random.element(['Common', 'Uncommon', 'Rare', 'Epic', 'Legendary', 'Mythic']);
  }

  /// Generates an IPFS hash.
  String ipfsHash() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final hash = StringBuffer('Qm');
    for (int i = 0; i < 44; i++) {
      hash.write(chars[random.nextInt(chars.length)]);
    }
    return hash.toString();
  }

  String _generateBase58(int length) {
    const base58 = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';
    final buffer = StringBuffer();
    for (int i = 0; i < length; i++) {
      buffer.write(base58[random.nextInt(base58.length)]);
    }
    return buffer.toString();
  }

  String _generateBech32(int length) {
    const bech32 = 'qpzry9x8gf2tvdw0s3jn54khce6mua7l';
    final buffer = StringBuffer();
    for (int i = 0; i < length; i++) {
      buffer.write(bech32[random.nextInt(bech32.length)]);
    }
    return buffer.toString();
  }

  static final List<String> _cryptoCurrencies = [
    'Bitcoin', 'Ethereum', 'Binance Coin', 'Cardano', 'Solana',
    'XRP', 'Polkadot', 'Dogecoin', 'Avalanche', 'Chainlink',
    'Polygon', 'Tron', 'Litecoin', 'Shiba Inu', 'Wrapped Bitcoin',
    'Uniswap', 'Cosmos', 'Ethereum Classic', 'Bitcoin Cash', 'Stellar',
  ];

  static final List<String> _cryptoSymbols = [
    'BTC', 'ETH', 'BNB', 'ADA', 'SOL', 'XRP', 'DOT', 'DOGE',
    'AVAX', 'LINK', 'MATIC', 'TRX', 'LTC', 'SHIB', 'WBTC',
    'UNI', 'ATOM', 'ETC', 'BCH', 'XLM',
  ];

  static final List<String> _miningPools = [
    'F2Pool', 'Poolin', 'Antpool', 'ViaBTC', 'Slush Pool',
    'BTC.com', 'Binance Pool', 'Huobi Pool', 'OKEx Pool', 'Luxor',
    'SparkPool', 'Ethermine', 'Nanopool', '2Miners', 'Mining Pool Hub',
  ];

  static final List<String> _defiProtocols = [
    'Uniswap', 'Aave', 'Compound', 'MakerDAO', 'Curve Finance',
    'SushiSwap', 'PancakeSwap', 'Yearn Finance', 'Synthetix', 'Balancer',
    '1inch', 'dYdX', 'Bancor', 'Kyber Network', '0x Protocol',
  ];

  static final List<String> _bip39Words = [
    'abandon', 'ability', 'able', 'about', 'above', 'absent', 'absorb', 'abstract',
    'absurd', 'abuse', 'access', 'accident', 'account', 'accuse', 'achieve', 'acid',
    'acoustic', 'acquire', 'across', 'act', 'action', 'actor', 'actress', 'actual',
    'adapt', 'add', 'addict', 'address', 'adjust', 'admit', 'adult', 'advance',
    'advice', 'aerobic', 'affair', 'afford', 'afraid', 'again', 'age', 'agent',
    'agree', 'ahead', 'aim', 'air', 'airport', 'aisle', 'alarm', 'album',
    'alcohol', 'alert', 'alien', 'all', 'alley', 'allow', 'almost', 'alone',
    'alpha', 'already', 'also', 'alter', 'always', 'amateur', 'amazing', 'among',
    'amount', 'amused', 'analyst', 'anchor', 'ancient', 'anger', 'angle', 'angry',
    'animal', 'ankle', 'announce', 'annual', 'another', 'answer', 'antenna', 'antique',
    'anxiety', 'any', 'apart', 'apology', 'appear', 'apple', 'approve', 'april',
    'arch', 'arctic', 'area', 'arena', 'argue', 'arm', 'armed', 'armor',
    'army', 'around', 'arrange', 'arrest', 'arrive', 'arrow', 'art', 'artefact',
    'artist', 'artwork', 'ask', 'aspect', 'assault', 'asset', 'assist', 'assume',
    'asthma', 'athlete', 'atom', 'attack', 'attend', 'attitude', 'attract', 'auction',
    'audit', 'august', 'aunt', 'author', 'auto', 'autumn', 'average', 'avocado',
    'avoid', 'awake', 'aware', 'away', 'awesome', 'awful', 'awkward', 'axis',
    'baby', 'bachelor', 'bacon', 'badge', 'bag', 'balance', 'balcony', 'ball',
    'bamboo', 'banana', 'banner', 'bar', 'barely', 'bargain', 'barrel', 'base',
    'basic', 'basket', 'battle', 'beach', 'bean', 'beauty', 'because', 'become',
    'beef', 'before', 'begin', 'behave', 'behind', 'believe', 'below', 'belt',
    'bench', 'benefit', 'best', 'betray', 'better', 'between', 'beyond', 'bicycle',
    'bid', 'bike', 'bind', 'biology', 'bird', 'birth', 'bitter', 'black',
    'blade', 'blame', 'blanket', 'blast', 'bleak', 'bless', 'blind', 'blood',
    'blossom', 'blouse', 'blue', 'blur', 'blush', 'board', 'boat', 'body',
    'boil', 'bomb', 'bone', 'bonus', 'book', 'boost', 'border', 'boring',
    'borrow', 'boss', 'bottom', 'bounce', 'box', 'boy', 'bracket', 'brain',
    'brand', 'brass', 'brave', 'bread', 'breeze', 'brick', 'bridge', 'brief',
    'bright', 'bring', 'brisk', 'broccoli', 'broken', 'bronze', 'broom', 'brother',
    'brown', 'brush', 'bubble', 'buddy', 'budget', 'buffalo', 'build', 'bulb',
    'bulk', 'bullet', 'bundle', 'bunker', 'burden', 'burger', 'burst', 'bus',
    'business', 'busy', 'butter', 'buyer', 'buzz', 'cabbage', 'cabin', 'cable',
    'cactus', 'cage', 'cake', 'call', 'calm', 'camera', 'camp', 'can',
    'canal', 'cancel', 'candy', 'cannon', 'canoe', 'canvas', 'canyon', 'capable',
    'capital', 'captain', 'car', 'carbon', 'card', 'cargo', 'carpet', 'carry',
    'cart', 'case', 'cash', 'casino', 'castle', 'casual', 'cat', 'catalog',
    'catch', 'category', 'cattle', 'caught', 'cause', 'caution', 'cave', 'ceiling',
    'celery', 'cement', 'census', 'century', 'cereal', 'certain', 'chair', 'chalk',
  ];
}