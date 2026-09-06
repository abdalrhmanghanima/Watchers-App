class Comment {
  const Comment({
    required this.id,
    required this.username,
    required this.avatar,
    required this.text,
    required this.time,
    required this.likes,
    required this.spoiler,
  });

  final String id;
  final String username;
  final String avatar;
  final String text;
  final String time;
  final int likes;
  final bool spoiler;
}
