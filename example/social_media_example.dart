import 'package:smart_faker/smart_faker.dart';

void main() {
  final faker = SmartFaker(seed: 12345);

  print('📱 Social Media Data Generation Examples');
  print('=' * 60);

  // User Profile
  print('\n👤 User Profile:');
  print('Username: ${faker.social.username()}');
  print('Bio: ${faker.social.bio()}');
  print('Followers: ${faker.social.followers(tier: 'micro')}');
  print('Following: ${faker.social.following()}');
  print('Verified: ${faker.social.verified(probability: 0.3)}');
  print('Platform: ${faker.social.platform()}');

  // Post Content
  print('\n📝 Post Content:');
  print('Post: ${faker.social.post()}');
  print('Hashtags: ${faker.social.hashtags(5).join(' ')}');
  print('Posting time: ${faker.social.postingTime()}');

  // Engagement Metrics
  print('\n📊 Engagement Metrics:');
  final likes = faker.social.likes(tier: 'small');
  print('Likes: $likes');
  print('Comments: ${faker.social.comments(basedOnLikes: likes)}');
  print('Shares: ${faker.social.shares(basedOnLikes: likes)}');
  print('Story Views: ${faker.social.storyViews()}');
  print('Engagement Rate: ${faker.social.engagementRate()}');

  // Comments & Reactions
  print('\n💬 Comments & Reactions:');
  for (int i = 0; i < 3; i++) {
    print(
        '  ${faker.social.username(includeAt: false)}: ${faker.social.comment()}');
  }
  print(
      'Reactions: ${List.generate(5, (_) => faker.social.reaction()).join(' ')}');
  print('Emojis: ${List.generate(10, (_) => faker.social.emoji()).join(' ')}');

  // Generate Multiple Influencer Profiles
  print('\n🌟 Influencer Profiles:');
  print('-' * 40);

  final tiers = ['nano', 'micro', 'mid', 'macro'];
  for (final tier in tiers) {
    final followers = faker.social.followers(tier: tier);
    final following = faker.social.following(followerCount: followers);
    final engagement = faker.social.engagementRate();

    print('$tier Influencer:');
    print('  Username: ${faker.social.username()}');
    print('  Followers: ${_formatNumber(followers)}');
    print('  Following: ${_formatNumber(following)}');
    print('  Engagement: $engagement');
    print(
        '  Verified: ${faker.social.verified(probability: tier == 'macro' ? 0.9 : 0.3)}');
    print('');
  }

  // Social Media Campaign Data
  print('📈 Campaign Simulation:');
  print('-' * 40);

  final posts = List.generate(
      5,
      (index) => {
            'day': index + 1,
            'content': faker.social.post(),
            'hashtags': faker.social.hashtags(3),
            'likes': faker.social.likes(tier: 'small'),
            'comments': faker.random.integer(min: 10, max: 100),
            'shares': faker.random.integer(min: 5, max: 50),
            'platform': faker.social.platform(),
          });

  for (final post in posts) {
    print('Day ${post['day']} - ${post['platform']}:');
    print('  Content: ${post['content']}');
    print('  Tags: ${(post['hashtags'] as List).join(' ')}');
    print(
        '  Engagement: ${post['likes']} likes, ${post['comments']} comments, ${post['shares']} shares');
  }

  print('\n✨ Social Media module examples completed!');
}

String _formatNumber(int number) {
  if (number >= 1000000) {
    return '${(number / 1000000).toStringAsFixed(1)}M';
  } else if (number >= 1000) {
    return '${(number / 1000).toStringAsFixed(1)}K';
  }
  return number.toString();
}
