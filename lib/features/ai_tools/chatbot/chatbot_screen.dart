import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _inputCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _isTyping = false;

  final List<_ChatMessage> _messages = [
    _ChatMessage(
      'Salaam! I\'m your TourMate Travel Assistant. Ask me anything about Pakistani destinations, travel tips, or local culture. 🇵🇰',
      false,
      DateTime.now().subtract(const Duration(minutes: 1)),
    ),
  ];

  static const Map<String, String> _responses = {
    'hunza': 'Hunza Valley in Gilgit-Baltistan is best visited April–October. Don\'t miss Baltit Fort, Attabad Lake, and Eagle\'s Nest viewpoint. Carry warm layers — nights are chilly even in summer! 🏔️',
    'skardu': 'Skardu is the gateway to K2 and Deosai Plains. Best season is June–September. The Shangrila Resort lake view is stunning. Book accommodation early during peak season! ⛰️',
    'lahore': 'Lahore has Pakistan\'s richest heritage. Visit Badshahi Mosque, Lahore Fort, and enjoy food at Gawalmandi Food Street. Spring (Feb–Apr) is the best time to visit. 🏛️',
    'islamabad': 'Islamabad is a clean, modern capital with Margalla Hills right at its doorstep. Visit Faisal Mosque, hike the Margalla trails, and explore Saidpur Village for great food and culture. 🌿',
    'swat': 'Swat Valley — the Switzerland of Pakistan! Best in April–October. Visit Malam Jabba ski resort, Mahodand Lake, and Kalam. The Swat River scenery is breathtaking. 🌊',
    'food': 'Pakistani cuisine is incredible! Try Chapli Kebab in Peshawar, Halwa Puri for breakfast in Lahore, Sajji in Quetta, and fresh trout in the mountain valleys. 🍢',
    'visa': 'Pakistan is open to tourists from most countries. You can get an e-Visa online through the Pakistan Immigration portal. Processing usually takes 5–7 business days. ✈️',
    'weather': 'Pakistan\'s north (Hunza, Skardu) is best May–September. Punjab and Sindh are pleasant October–March. Avoid the July–August monsoon in the plains. ☀️',
    'season': 'Pakistan\'s north (Hunza, Skardu) is best May–September. Punjab and Sindh are pleasant October–March. Avoid the July–August monsoon in the plains. ☀️',
    'hotel': 'Pakistan has great accommodation options. Serena Hotels are top-tier in major cities. For mountains, look for local guesthouses — they\'re affordable and run by friendly locals! 🏨',
    'transport': 'Between cities, Daewoo and Faisal Movers buses are comfortable. For the north, hire a private jeep or 4WD. Domestic flights (PIA, AirBlue) connect major hubs. 🚌',
    'karachi': 'Karachi is Pakistan\'s largest city — vibrant, coastal, and full of food! Visit Clifton Beach, Mohatta Palace, and the amazing street food scene. Best season: November–February. 🌊',
  };

  String _getResponse(String input) {
    final lower = input.toLowerCase();
    for (final entry in _responses.entries) {
      if (lower.contains(entry.key)) return entry.value;
    }
    return 'That\'s a great question! Pakistan offers incredible diversity — from the K2 base camp to Mughal architecture in Lahore. Try asking me about Hunza, Skardu, Lahore, food, or visa requirements! 😊';
  }

  void _sendMessage() {
    final text = _inputCtrl.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(text, true, DateTime.now()));
      _isTyping = true;
      _inputCtrl.clear();
    });
    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        _isTyping = false;
        _messages.add(_ChatMessage(_getResponse(text), false, DateTime.now()));
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Travel Assistant', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                Text('Online', style: TextStyle(fontSize: 11, color: AppColors.green, fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, i) {
                if (_isTyping && i == _messages.length) {
                  return const _TypingBubble();
                }
                return _BubbleRow(message: _messages[i]);
              },
            ),
          ),
          _InputBar(
            controller: _inputCtrl,
            focusNode: _focusNode,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  const _ChatMessage(this.text, this.isUser, this.timestamp);
  final String text;
  final bool isUser;
  final DateTime timestamp;
}

class _BubbleRow extends StatelessWidget {
  const _BubbleRow({required this.message});
  final _ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.greenSoft,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.smart_toy_rounded, size: 16, color: AppColors.green),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.70,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isUser ? AppColors.green : AppColors.greenSoft,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isUser ? 18 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 18),
                ),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: isUser ? Colors.white : AppColors.textPrimary,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class _TypingBubble extends StatefulWidget {
  const _TypingBubble();

  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.greenSoft,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.smart_toy_rounded, size: 16, color: AppColors.green),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.greenSoft,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(18),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                return AnimatedBuilder(
                  animation: _ctrl,
                  builder: (context, _) {
                    final offset = ((_ctrl.value - i * 0.33) % 1.0);
                    final opacity = offset < 0.5
                        ? (offset / 0.5)
                        : (1.0 - (offset - 0.5) / 0.5);
                    return Container(
                      margin: EdgeInsets.only(right: i < 2 ? 5 : 0),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.green.withValues(alpha: 0.3 + opacity * 0.7),
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  const _InputBar({
    required this.controller,
    required this.focusNode,
    required this.onSend,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        10,
        16,
        10 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              decoration: InputDecoration(
                hintText: 'Ask about Pakistan travel...',
                hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
                filled: true,
                fillColor: AppColors.inputFill,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onSend,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.green,
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
