import 'package:flutter/material.dart';

import 'package:watchers/core/theme/app_colors.dart';
import 'package:watchers/data/models/comment.dart';
import 'package:watchers/data/models/search_result.dart';
import 'package:watchers/data/repositories/content_repository.dart';
import 'package:watchers/data/sources/mock_content_repository.dart';
import 'package:watchers/shared/widgets/watcher_status_bar.dart';

import 'widgets/comment_card.dart';
import 'widgets/comment_status.dart';
import 'widgets/comments_header.dart';
import 'widgets/comments_input.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({
    super.key,
    required this.itemId,
    required this.itemType,
    this.repository,
  });

  final String itemId;
  final ContentType itemType;
  final ContentRepository? repository;

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  static const String _ownAvatarUrl =
      'https://images.unsplash.com/photo-1525547843489-d0aab95e5ce1?w=64&h=64&fit=crop&auto=format';

  late final ContentRepository _repository =
      widget.repository ?? MockContentRepository();
  late Future<(String?, List<Comment>)> _future;
  final TextEditingController _controller = TextEditingController();
  final List<Comment> _extra = [];
  final Set<String> _revealedSpoilers = <String>{};
  final Set<String> _liked = <String>{};
  bool _hideSpoilers = false;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<(String?, List<Comment>)> _load() async {
    final comments = await _repository.getComments();
    String? title;
    switch (widget.itemType) {
      case ContentType.show:
        title = (await _repository.getShow(widget.itemId))?.title;
      case ContentType.movie:
        title = (await _repository.getMovie(widget.itemId))?.title;
      case ContentType.episode:
        final parts = widget.itemId.split(':');
        final show = parts.isNotEmpty
            ? await _repository.getShow(parts.first)
            : null;
        final seasonNumber = parts.length > 1 ? int.tryParse(parts[1]) ?? 1 : 1;
        final episodeNumber = parts.length > 2
            ? int.tryParse(parts[2]) ?? 1
            : 1;
        final episode = show?.episodeData
            .where((s) => s.number == seasonNumber)
            .expand((s) => s.episodes)
            .where((e) => e.number == episodeNumber)
            .firstOrNull;
        title = episode?.title;
    }
    return (title, comments);
  }

  void _reload() {
    setState(() {
      _future = _load();
    });
  }

  void _postComment() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _extra.insert(
        0,
        Comment(
          id: 'local-${DateTime.now().microsecondsSinceEpoch}',
          username: 'you',
          avatar: _ownAvatarUrl,
          text: text,
          time: 'now',
          likes: 0,
          spoiler: false,
        ),
      );
      _controller.clear();
    });
  }

  void _toggleLike(String id) {
    setState(() {
      if (_liked.contains(id)) {
        _liked.remove(id);
      } else {
        _liked.add(id);
      }
    });
  }

  void _revealSpoiler(String id) {
    setState(() {
      _revealedSpoilers.add(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    return Scaffold(
      backgroundColor: palette.bg,
      body: FutureBuilder<(String?, List<Comment>)>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return CommentStatus(
              icon: Icons.cloud_off_outlined,
              title: 'Something went wrong',
              message:
                  "We couldn't load these comments. Check your connection and try again.",
              actionLabel: 'Try again',
              onAction: _reload,
            );
          }
          final title = snapshot.data?.$1 ?? 'Comments';
          final baseComments = snapshot.data?.$2 ?? const <Comment>[];
          return _buildContent(title, baseComments);
        },
      ),
    );
  }

  Widget _buildContent(String title, List<Comment> baseComments) {
    final allComments = [..._extra, ...baseComments];
    final comments = _hideSpoilers
        ? allComments.where((c) => !c.spoiler).toList()
        : allComments;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const WatcherStatusBar(),
        CommentsHeader(
          title: title,
          commentCount: comments.length,
          hideSpoilers: _hideSpoilers,
          onToggleSpoilers: () =>
              setState(() => _hideSpoilers = !_hideSpoilers),
        ),
        CommentsInput(
          avatarUrl: _ownAvatarUrl,
          controller: _controller,
          canSend: _controller.text.trim().isNotEmpty,
          onChanged: (_) => setState(() {}),
          onSend: _postComment,
        ),
        Expanded(
          child: comments.isEmpty
              ? const CommentStatus(
                  icon: Icons.chat_bubble_outline,
                  title: 'No comments yet',
                  message: 'Be the first to share your thoughts.',
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return CommentCard(
                      key: ValueKey('comment-${comment.id}'),
                      comment: comment,
                      liked: _liked.contains(comment.id),
                      revealed: _revealedSpoilers.contains(comment.id),
                      onToggleLike: () => _toggleLike(comment.id),
                      onRevealSpoiler: () => _revealSpoiler(comment.id),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
