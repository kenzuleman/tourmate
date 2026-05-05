import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/soft_card.dart';

class AiToolsScreen extends StatelessWidget {
  const AiToolsScreen({super.key});

  static const _tools = [
    _Tool('Travel Assistant', 'Ask anything about Pakistan',
        Icons.forum_rounded, AppColors.green, '/ai-tools/chatbot'),
    _Tool('Language Translator', 'Urdu, English & local',
        Icons.translate_rounded, AppColors.green, '/ai-tools/translator'),
    _Tool('Packing Assistant', 'Destination-based checklists',
        Icons.checklist_rounded, AppColors.green, '/ai-tools/packing'),
    _Tool('Expense Tracker', 'Track spending live',
        Icons.account_balance_wallet_rounded, AppColors.green, '/ai-tools/expenses'),
    _Tool('Currency Converter', 'PKR to any currency',
        Icons.currency_exchange_rounded, AppColors.green, '/ai-tools/currency'),
    _Tool('Trip Planner', 'Day-by-day itineraries',
        Icons.event_note_rounded, AppColors.green, '/ai-tools/planner'),
  ];

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Tools'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: Text(
                'Your travel companions',
                style: text.bodyMedium,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            sliver: SliverGrid(
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.95,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, i) => _ToolTile(tool: _tools[i]),
                childCount: _tools.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tool {
  const _Tool(this.title, this.subtitle, this.icon, this.accent, this.route);
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final String route;
}

class _ToolTile extends StatelessWidget {
  const _ToolTile({required this.tool});
  final _Tool tool;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      color: tool.accent,
      onTap: () => context.push(tool.route),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(tool.icon, color: Colors.white, size: 24),
          ),
          const Spacer(),
          Text(
            tool.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            tool.subtitle,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.90),
              fontSize: 12,
              height: 1.3,
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
