import 'package:flutter_test/flutter_test.dart';
import 'package:smart_faker/smart_faker.dart';

void main() {
  group('CryptoModule', () {
    late SmartFaker faker;

    setUp(() {
      faker = SmartFaker();
    });

    group('Blockchain', () {
      test('should generate Bitcoin address', () {
        final address = faker.crypto.bitcoinAddress();
        expect(address, isNotEmpty);
        // Bitcoin addresses start with 1, 3, or bc1
        expect(address, matches(RegExp(r'^(1|3|bc1)[a-zA-Z0-9]{25,39}$')));
      });

      test('should generate Ethereum address', () {
        final address = faker.crypto.ethereumAddress();
        expect(address, matches(RegExp(r'^0x[a-fA-F0-9]{40}$')));
      });

      test('should generate blockchain hash', () {
        final hash = faker.crypto.blockchainHash();
        expect(hash, matches(RegExp(r'^[a-fA-F0-9]{64}$')));
      });

      test('should generate transaction ID', () {
        final txId = faker.crypto.transactionId();
        expect(txId, matches(RegExp(r'^[a-fA-F0-9]{64}$')));
      });

      test('should generate block number', () {
        final block = faker.crypto.blockNumber();
        expect(block, greaterThan(0));
        expect(block, lessThanOrEqualTo(20000000));
      });

      test('should generate gas price', () {
        final gas = faker.crypto.gasPrice();
        expect(gas, isNotEmpty);
        expect(gas, contains('gwei'));
      });

      test('should generate nonce', () {
        final nonce = faker.crypto.nonce();
        expect(nonce, greaterThanOrEqualTo(0));
        expect(nonce, lessThanOrEqualTo(999999));
      });
    });

    group('Cryptocurrency', () {
      test('should generate crypto currency name', () {
        final name = faker.crypto.currencyName();
        expect([
          'Bitcoin',
          'Ethereum',
          'Binance Coin',
          'Cardano',
          'Solana',
          'XRP',
          'Polkadot',
          'Dogecoin',
          'Avalanche',
          'Chainlink',
          'Polygon',
          'Tron',
          'Litecoin',
          'Shiba Inu',
          'Wrapped Bitcoin',
          'Uniswap',
          'Cosmos',
          'Ethereum Classic',
          'Bitcoin Cash',
          'Stellar'
        ], contains(name));
      });

      test('should generate crypto currency symbol', () {
        final symbol = faker.crypto.currencySymbol();
        expect([
          'BTC',
          'ETH',
          'BNB',
          'ADA',
          'SOL',
          'XRP',
          'DOT',
          'DOGE',
          'AVAX',
          'LINK',
          'MATIC',
          'TRX',
          'LTC',
          'SHIB',
          'WBTC',
          'UNI',
          'ATOM',
          'ETC',
          'BCH',
          'XLM'
        ], contains(symbol));
      });

      test('should generate crypto currency pair', () {
        final pair = faker.crypto.currencyPair();
        expect(pair, matches(RegExp(r'^[A-Z]{2,5}/[A-Z]{2,5}$')));
      });

      test('should generate crypto price', () {
        final price = faker.crypto.price();
        expect(price, isNotEmpty);
        expect(price, startsWith(r'$'));
      });

      test('should generate market cap', () {
        final cap = faker.crypto.marketCap();
        expect(cap, isNotEmpty);
        expect(cap, startsWith(r'$'));
        expect(cap, contains(RegExp(r'[BMK]?$')));
      });

      test('should generate trading volume', () {
        final volume = faker.crypto.volume();
        expect(volume, isNotEmpty);
        expect(volume, startsWith(r'$'));
      });

      test('should generate price change percentage', () {
        final change = faker.crypto.priceChange();
        expect(change, isNotEmpty);
        expect(change, endsWith('%'));
      });
    });

    group('Wallet', () {
      test('should generate wallet seed phrase', () {
        final phrase = faker.crypto.seedPhrase();
        final words = phrase.split(' ');
        expect(words.length, equals(12));
      });

      test('should generate wallet seed phrase with custom length', () {
        final phrase = faker.crypto.seedPhrase(wordCount: 24);
        final words = phrase.split(' ');
        expect(words.length, equals(24));
      });

      test('should generate private key', () {
        final key = faker.crypto.privateKey();
        expect(key, matches(RegExp(r'^[a-fA-F0-9]{64}$')));
      });

      test('should generate public key', () {
        final key = faker.crypto.publicKey();
        expect(key, matches(RegExp(r'^[a-fA-F0-9]{128}$')));
      });

      test('should generate wallet balance', () {
        final balance = faker.crypto.balance();
        expect(balance, isNotEmpty);
      });
    });

    group('Mining', () {
      test('should generate hash rate', () {
        final rate = faker.crypto.hashRate();
        expect(rate, isNotEmpty);
        expect(rate, contains(RegExp(r'[KMGTPE]?H/s$')));
      });

      test('should generate difficulty', () {
        final difficulty = faker.crypto.difficulty();
        expect(difficulty, isNotEmpty);
      });

      test('should generate mining pool name', () {
        final pool = faker.crypto.miningPool();
        expect(pool, isNotEmpty);
      });

      test('should generate mining reward', () {
        final reward = faker.crypto.miningReward();
        expect(reward, isNotEmpty);
        expect(reward, contains(RegExp(r'\d+(\.\d+)?\s\w+')));
      });
    });

    group('DeFi', () {
      test('should generate DeFi protocol', () {
        final protocol = faker.crypto.defiProtocol();
        expect(protocol, isNotEmpty);
      });

      test('should generate APY', () {
        final apy = faker.crypto.apy();
        expect(apy, isNotEmpty);
        expect(apy, endsWith('%'));
      });

      test('should generate TVL', () {
        final tvl = faker.crypto.tvl();
        expect(tvl, isNotEmpty);
        expect(tvl, startsWith(r'$'));
      });

      test('should generate liquidity', () {
        final liquidity = faker.crypto.liquidity();
        expect(liquidity, isNotEmpty);
        expect(liquidity, startsWith(r'$'));
      });
    });

    group('NFT', () {
      test('should generate NFT token ID', () {
        final tokenId = faker.crypto.nftTokenId();
        expect(tokenId, greaterThanOrEqualTo(1));
      });

      test('should generate NFT collection name', () {
        final collection = faker.crypto.nftCollection();
        expect(collection, isNotEmpty);
      });

      test('should generate NFT rarity', () {
        final rarity = faker.crypto.nftRarity();
        expect(['Common', 'Uncommon', 'Rare', 'Epic', 'Legendary', 'Mythic'],
            contains(rarity));
      });

      test('should generate IPFS hash', () {
        final hash = faker.crypto.ipfsHash();
        expect(hash, startsWith('Qm'));
        expect(hash, matches(RegExp(r'^Qm[a-zA-Z0-9]{44}$')));
      });
    });

    group('Seeded Generation', () {
      test('should generate reproducible crypto data with seed', () {
        final faker1 = SmartFaker(seed: 42);
        final faker2 = SmartFaker(seed: 42);

        expect(faker1.crypto.bitcoinAddress(),
            equals(faker2.crypto.bitcoinAddress()));
        expect(faker1.crypto.ethereumAddress(),
            equals(faker2.crypto.ethereumAddress()));
        expect(faker1.crypto.seedPhrase(), equals(faker2.crypto.seedPhrase()));
      });
    });
  });
}
