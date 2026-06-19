import 'dart:ui';
import 'package:flutter/material.dart';

class MessagingScreen extends StatefulWidget {
  const MessagingScreen({super.key});

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  final List<_Conversation> _convos = [
    _Conversation(id: 0, name: 'Dr. Amina', avatar: 'DA', lastMessage: 'Thanks for the feedback on the reel!', time: '2m', unread: 2, online: true),
    _Conversation(id: 1, name: 'DesignWithSam', avatar: 'DS', lastMessage: 'Can you share the Figma file?', time: '14m', unread: 0, online: true),
    _Conversation(id: 2, name: 'Ibrahim N.', avatar: 'IN', lastMessage: 'See you at the workshop tomorrow 👍', time: '1h', unread: 0, online: false),
    _Conversation(id: 3, name: 'Finance Lab', avatar: 'FL', lastMessage: 'New video dropping Friday!', time: '3h', unread: 1, online: false),
    _Conversation(id: 4, name: 'Kareem T.', avatar: 'KT', lastMessage: 'Would love to collaborate sometime', time: '1d', unread: 0, online: false),
    _Conversation(id: 5, name: 'Mona H.', avatar: 'MH', lastMessage: 'Booked your workshop!', time: '2d', unread: 0, online: true),
  ];

  List<_Conversation> get _filtered => _query.isEmpty ? _convos : _convos.where((c) => c.name.toLowerCase().contains(_query)).toList();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final convos = _filtered;
    return Scaffold(
      backgroundColor: const Color(0xFF09090B),
      body: Stack(
        children: [
          Positioned(top: -80, right: -60, child: _GlowOrb(color: const Color(0xFF3B82F6).withValues(alpha: 0.14), size: 200)),
          Positioned(bottom: -100, left: -60, child: _GlowOrb(color: const Color(0xFF6D28D9).withValues(alpha: 0.14), size: 240)),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  child: Row(
                    children: [
                      _BackButton(onTap: () => Navigator.of(context).pop()),
                      const SizedBox(width: 12),
                      const Text('Messages', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 38, height: 38,
                          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.07), shape: BoxShape.circle, border: Border.all(color: Colors.white.withValues(alpha: 0.1))),
                          child: const Icon(Icons.edit_outlined, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _query = v.toLowerCase()),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search messages',
                      hintStyle: const TextStyle(color: Color(0xFF6B7280)),
                      prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF6B7280)),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.06),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFFF7A18), width: 1.1)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: convos.isEmpty
                      ? const Center(child: Text('No conversations found', style: TextStyle(color: Color(0xFF6B7280))))
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: convos.length,
                          separatorBuilder: (_, _) => Divider(color: Colors.white.withValues(alpha: 0.06), height: 1),
                          itemBuilder: (_, i) => _ConvoTile(
                            convo: convos[i],
                            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChatScreen(convo: convos[i]))),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConvoTile extends StatelessWidget {
  const _ConvoTile({required this.convo, required this.onTap});

  final _Conversation convo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
      onTap: onTap,
      leading: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: const Color(0xFFFF7A18).withValues(alpha: 0.2),
            child: Text(convo.avatar, style: const TextStyle(color: Color(0xFFFF7A18), fontWeight: FontWeight.w800, fontSize: 16)),
          ),
          if (convo.online)
            Positioned(
              bottom: 1, right: 1,
              child: Container(
                width: 12, height: 12,
                decoration: BoxDecoration(color: const Color(0xFF10B981), shape: BoxShape.circle, border: Border.all(color: const Color(0xFF09090B), width: 2)),
              ),
            ),
        ],
      ),
      title: Text(convo.name, style: TextStyle(color: Colors.white, fontWeight: convo.unread > 0 ? FontWeight.w700 : FontWeight.w600)),
      subtitle: Text(convo.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: convo.unread > 0 ? const Color(0xFFD1D5DB) : const Color(0xFF6B7280), fontSize: 13)),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(convo.time, style: TextStyle(color: convo.unread > 0 ? const Color(0xFFFF7A18) : const Color(0xFF6B7280), fontSize: 12)),
          if (convo.unread > 0) ...[
            const SizedBox(height: 4),
            Container(
              width: 20, height: 20,
              decoration: const BoxDecoration(color: Color(0xFFFF7A18), shape: BoxShape.circle),
              child: Center(child: Text('${convo.unread}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800))),
            ),
          ],
        ],
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.convo});

  final _Conversation convo;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late final List<_Message> _messages;

  @override
  void initState() {
    super.initState();
    _messages = [
      _Message(text: 'Hey! Loved your latest video 🔥', isMine: false, time: '10:20 AM'),
      _Message(text: 'Thanks so much! Glad it was helpful.', isMine: true, time: '10:22 AM'),
      _Message(text: 'Would you ever do a longer workshop on this topic?', isMine: false, time: '10:24 AM'),
      _Message(text: 'Definitely! I\'m planning one for next month.', isMine: true, time: '10:25 AM'),
      _Message(text: widget.convo.lastMessage, isMine: false, time: '10:30 AM'),
    ];
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_Message(text: text, isMine: true, time: 'Now'));
      _controller.clear();
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
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
    return Scaffold(
      backgroundColor: const Color(0xFF09090B),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08)))),
              child: Row(
                children: [
                  _BackButton(onTap: () => Navigator.of(context).pop()),
                  const SizedBox(width: 10),
                  Stack(children: [
                    CircleAvatar(radius: 20, backgroundColor: const Color(0xFFFF7A18).withValues(alpha: 0.2), child: Text(widget.convo.avatar, style: const TextStyle(color: Color(0xFFFF7A18), fontWeight: FontWeight.w800))),
                    if (widget.convo.online) Positioned(bottom: 1, right: 1, child: Container(width: 10, height: 10, decoration: BoxDecoration(color: const Color(0xFF10B981), shape: BoxShape.circle, border: Border.all(color: const Color(0xFF09090B), width: 2)))),
                  ]),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.convo.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                      Text(widget.convo.online ? 'Online' : 'Offline', style: TextStyle(color: widget.convo.online ? const Color(0xFF10B981) : const Color(0xFF6B7280), fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (_, i) => _ChatBubble(msg: _messages[i]),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(12, 8, 12, 10 + bottom),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Message…',
                        hintStyle: const TextStyle(color: Color(0xFF6B7280), fontSize: 14),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.07),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: const BorderSide(color: Color(0xFFFF7A18), width: 1.2)),
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _send,
                    child: Container(
                      width: 42, height: 42,
                      decoration: const BoxDecoration(color: Color(0xFFFF7A18), shape: BoxShape.circle),
                      child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.msg});

  final _Message msg;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: msg.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!msg.isMine) ...[
            const CircleAvatar(radius: 14, backgroundColor: Color(0x33FF7A18), child: Text('?', style: TextStyle(color: Color(0xFFFF7A18), fontSize: 11, fontWeight: FontWeight.w800))),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: msg.isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: msg.isMine ? const Color(0xFFFF7A18) : Colors.white.withValues(alpha: 0.09),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(msg.isMine ? 18 : 4),
                      bottomRight: Radius.circular(msg.isMine ? 4 : 18),
                    ),
                  ),
                  child: Text(msg.text, style: TextStyle(color: msg.isMine ? Colors.white : const Color(0xFFD1D5DB), fontSize: 14, height: 1.4)),
                ),
                const SizedBox(height: 3),
                Text(msg.time, style: const TextStyle(color: Color(0xFF4B5563), fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Conversation {
  const _Conversation({required this.id, required this.name, required this.avatar, required this.lastMessage, required this.time, required this.unread, required this.online});

  final int id;
  final String name, avatar, lastMessage, time;
  final int unread;
  final bool online;
}

class _Message {
  const _Message({required this.text, required this.isMine, required this.time});

  final String text, time;
  final bool isMine;
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, color: color, boxShadow: [BoxShadow(color: color, blurRadius: 100, spreadRadius: 30)]));
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.07), shape: BoxShape.circle, border: Border.all(color: Colors.white.withValues(alpha: 0.12))),
        child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
      ),
    );
  }
}
