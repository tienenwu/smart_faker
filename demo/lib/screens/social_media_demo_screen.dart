import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_faker/smart_faker.dart';

class SocialMediaDemoScreen extends StatefulWidget {
  const SocialMediaDemoScreen({super.key});

  @override
  State<SocialMediaDemoScreen> createState() => _SocialMediaDemoScreenState();
}

class _SocialMediaDemoScreenState extends State<SocialMediaDemoScreen> {
  SmartFaker faker = SmartFaker(locale: 'en_US', seed: 12345);
  String _currentLocale = 'en_US';
  
  // Profile data
  String _username = '';
  String _bio = '';
  int _followers = 0;
  int _following = 0;
  bool _verified = false;
  
  // Post data
  String _postContent = '';
  List<String> _hashtags = [];
  int _likes = 0;
  int _comments = 0;
  int _shares = 0;
  int _storyViews = 0;
  
  // Engagement
  String _engagementRate = '';
  String _postingTime = '';
  String _platform = '';
  
  // Comments
  List<String> _sampleComments = [];

  @override
  void initState() {
    super.initState();
    _generateAll();
  }

  void _generateAll() {
    setState(() {
      // Profile
      _username = faker.social.username();
      _bio = faker.social.bio();
      _followers = faker.social.followers(tier: 'micro');
      _following = faker.social.following(followerCount: _followers);
      _verified = faker.social.verified(probability: 0.3);
      
      // Post
      _postContent = faker.social.post();
      _hashtags = faker.social.hashtags(5);
      _likes = faker.social.likes(tier: 'small');
      _comments = faker.social.comments(basedOnLikes: _likes);
      _shares = faker.social.shares(basedOnLikes: _likes);
      _storyViews = faker.social.storyViews();
      
      // Engagement
      _engagementRate = faker.social.engagementRate();
      _postingTime = faker.social.postingTime();
      _platform = faker.social.platform();
      
      // Generate sample comments
      _sampleComments = List.generate(5, (_) => faker.social.comment());
    });
  }


  Widget _buildProfileCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: Text(
                    _username.isNotEmpty ? _username[1].toUpperCase() : 'U',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            _username,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_verified) ...[
                            const SizedBox(width: 4),
                            Icon(
                              Icons.verified,
                              size: 20,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _bio,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatColumn('Followers', _formatNumber(_followers)),
                _buildStatColumn('Following', _formatNumber(_following)),
                _buildStatColumn('Engagement', _engagementRate),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildPostCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post header
          ListTile(
            leading: CircleAvatar(
              child: Text(_username.isNotEmpty ? _username[1].toUpperCase() : 'U'),
            ),
            title: Row(
              children: [
                Text(_username.replaceAll('@', '')),
                if (_verified) ...[
                  const SizedBox(width: 4),
                  Icon(Icons.verified, size: 16, color: Theme.of(context).colorScheme.primary),
                ],
              ],
            ),
            subtitle: Text('$_platform • $_postingTime'),
            trailing: const Icon(Icons.more_vert),
          ),
          // Post content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _postContent,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          // Hashtags
          if (_hashtags.isNotEmpty) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                children: _hashtags.map((tag) => Text(
                  tag,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                )).toList(),
              ),
            ),
          ],
          const SizedBox(height: 12),
          // Engagement stats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildEngagementStat(Icons.favorite, _formatNumber(_likes)),
                const SizedBox(width: 16),
                _buildEngagementStat(Icons.comment, _formatNumber(_comments)),
                const SizedBox(width: 16),
                _buildEngagementStat(Icons.share, _formatNumber(_shares)),
                const Spacer(),
                _buildEngagementStat(Icons.visibility, _formatNumber(_storyViews)),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildEngagementStat(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(value, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildCommentsSection() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sample Comments',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ..._sampleComments.map((comment) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 12,
                    child: Text(
                      faker.social.emoji(),
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          faker.social.username(includeAt: false),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        Text(comment, style: const TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickGenerateSection() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Generate',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildQuickButton('Username', () {
                  final value = faker.social.username();
                  _copyToClipboard(value, 'Username');
                }),
                _buildQuickButton('Hashtag', () {
                  final value = faker.social.hashtag();
                  _copyToClipboard(value, 'Hashtag');
                }),
                _buildQuickButton('Bio', () {
                  final value = faker.social.bio();
                  _copyToClipboard(value, 'Bio');
                }),
                _buildQuickButton('Emoji', () {
                  final value = faker.social.emoji();
                  _copyToClipboard(value, 'Emoji');
                }),
                _buildQuickButton('Reaction', () {
                  final value = faker.social.reaction();
                  _copyToClipboard(value, 'Reaction');
                }),
                _buildQuickButton('Platform', () {
                  final value = faker.social.platform();
                  _copyToClipboard(value, 'Platform');
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickButton(String label, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.copy, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied: $text'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  void _changeLocale(String locale) {
    setState(() {
      _currentLocale = locale;
      faker = SmartFaker(locale: locale, seed: 12345);
      _generateAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📱 Social Media Module'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: _changeLocale,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'en_US',
                child: Row(
                  children: [
                    Text('🇺🇸', style: TextStyle(fontSize: 20)),
                    SizedBox(width: 8),
                    Text('English'),
                    if (_currentLocale == 'en_US') ...[
                      Spacer(),
                      Icon(Icons.check, size: 16),
                    ],
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'zh_TW',
                child: Row(
                  children: [
                    Text('🇹🇼', style: TextStyle(fontSize: 20)),
                    SizedBox(width: 8),
                    Text('繁體中文'),
                    if (_currentLocale == 'zh_TW') ...[
                      Spacer(),
                      Icon(Icons.check, size: 16),
                    ],
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'ja_JP',
                child: Row(
                  children: [
                    Text('🇯🇵', style: TextStyle(fontSize: 20)),
                    SizedBox(width: 8),
                    Text('日本語'),
                    if (_currentLocale == 'ja_JP') ...[
                      Spacer(),
                      Icon(Icons.check, size: 16),
                    ],
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _generateAll,
            tooltip: 'Generate New Data',
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildProfileCard(),
          _buildPostCard(),
          _buildCommentsSection(),
          _buildQuickGenerateSection(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}