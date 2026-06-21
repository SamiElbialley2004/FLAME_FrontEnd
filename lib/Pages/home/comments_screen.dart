import 'dart:ui';
import 'package:flutter/material.dart';

class CommentsScreen {
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _CommentsSheet(),
    );
  }
}

class _CommentsSheet extends StatefulWidget {
  const _CommentsSheet();

  @override
  State<_CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<_CommentsSheet> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final Set<int> _liked = {};

  final List<_Comment> _comments = [
    _Comment(id: 0, user: 'Dr. Amina', avatar: 'DA', text: 'This is absolutely gold. Saving this for my students!', time: '2m ago', likes: 48),
    _Comment(id: 1, user: 'Ibrahim N.', avatar: 'IN', text: 'The second prompt is a game changer. Used it for my product team today.', time: '5m ago', likes: 31),
    _Comment(id: 2, user: 'DesignWithSam', avatar: 'DS', text: 'Short and to the point. Exactly what Flame is for 🔥', time: '12m ago', likes: 19),
    _Comment(id: 3, user: 'Finance Lab', avatar: 'FL', text: 'Combined this with a Feynman technique session — incredible results.', time: '24m ago', likes: 27),
    _Comment(id: 4, user: 'Kareem T.', avatar: 'KT', text: 'How long did it take to figure these out?', time: '1h ago', likes: 8),
    _Comment(id: 5, user: 'Mona H.', avatar: 'MH', text: 'Would love a workshop version of this topic!', time: '2h ago', likes: 14),
    _Comment(id: 6, user: 'Jana A.', avatar: 'JA', text: 'Already shared this with my whole study group 😍', time: '3h ago', likes: 22),
  ];

  void _sendComment() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _comments.insert(0, _Comment(id: _comments.length, user: 'You', avatar: 'Y', text: text, time: 'Just now', likes: 0));
      _controller.clear();
    });
    _scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.85),
          decoration: BoxDecoration(
            color: const Color(0xFF0E1119).withValues(alpha: 0.97),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
            border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.12))),
          ),
          child: Column(
            children: [
              Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(999)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
                child: Row(
                  children: [
                    Text('${_comments.length} Comments', style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), shape: BoxShape.circle),
                        child: const Icon(Icons.close_rounded, color: Colors.white70, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.white.withValues(alpha: 0.08), height: 1),
              Expanded(
                child: ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  itemCount: _comments.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                  itemBuilder: (_, i) {
                    final c = _comments[i];
                    final isLiked = _liked.contains(c.id);
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: const Color(0xFFFF7A18).withValues(alpha: 0.2),
                          child: Text(c.avatar, style: const TextStyle(color: Color(0xFFFF7A18), fontWeight: FontWeight.w800, fontSize: 12)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(c.user, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                                  const SizedBox(width: 8),
                                  Text(c.time, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 11)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(c.text, style: const TextStyle(color: Color(0xFFD1D5DB), fontSize: 13.5, height: 1.4)),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => setState(() {
                                      if (isLiked) { _liked.remove(c.id); c.likes--; } else { _liked.add(c.id); c.likes++; }
                                    }),
                                    child: Row(
                                      children: [
                                        Icon(isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded, size: 14, color: isLiked ? const Color(0xFFEF4444) : const Color(0xFF6B7280)),
                                        const SizedBox(width: 4),
                                        Text('${c.likes}', style: TextStyle(color: isLiked ? const Color(0xFFEF4444) : const Color(0xFF6B7280), fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  const Text('Reply', style: TextStyle(color: Color(0xFF6B7280), fontSize: 12, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Divider(color: Colors.white.withValues(alpha: 0.08), height: 1),
              Padding(
                padding: EdgeInsets.fromLTRB(12, 10, 12, 12 + bottom),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 18,
                      backgroundColor: Color(0xFFFF7A18),
                      child: Text('Y', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Add a comment…',
                          hintStyle: const TextStyle(color: Color(0xFF6B7280), fontSize: 14),
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.07),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: const BorderSide(color: Color(0xFFFF7A18), width: 1.2)),
                        ),
                        onSubmitted: (_) => _sendComment(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _sendComment,
                      child: Container(
                        width: 38, height: 38,
                        decoration: const BoxDecoration(color: Color(0xFFFF7A18), shape: BoxShape.circle),
                        child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Comment {
  _Comment({required this.id, required this.user, required this.avatar, required this.text, required this.time, required this.likes});

  final int id;
  final String user, avatar, text, time;
  int likes;
}
