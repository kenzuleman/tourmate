import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/soft_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _destinations = [
    _Destination('Hunza Valley', 'Gilgit-Baltistan', '⛰️ Mountains',
        Icons.landscape_rounded, AppColors.greenSoft,
        imageUrl: 'https://i.postimg.cc/FzyvLkzr/hunza-valley.jpg'),
    _Destination('Lahore Old City', 'Punjab', '🏛️ Heritage',
        Icons.account_balance_rounded, AppColors.greenSoft,
        imageUrl: 'https://i.postimg.cc/J0LVM7qK/lahore-old-city.jpg'),
    _Destination('Fairy Meadows', 'Nanga Parbat', '🏕️ Camping',
        Icons.forest_rounded, AppColors.greenSoft),
    _Destination('Mohenjo-daro', 'Sindh', '🏛️ Heritage',
        Icons.temple_hindu_rounded, AppColors.greenSoft),
    _Destination('Skardu', 'Gilgit-Baltistan', '⛰️ Mountains',
        Icons.terrain_rounded, AppColors.greenSoft,
        imageUrl: 'https://i.postimg.cc/R06jtJpd/skardu.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('TourMate'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: _SosButton(onTap: () {}),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Where to today?', style: text.headlineLarge),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: SoftCard(
                color: AppColors.green,
                padding: const EdgeInsets.all(20),
                onTap: () {},
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.auto_awesome,
                          color: Colors.white, size: 26),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Build your perfect trip',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Let our AI plan a journey just for you',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.90),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_rounded,
                        color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('AI-Recommended', style: text.titleLarge),
                  Text(
                    'See all',
                    style: text.bodyMedium?.copyWith(
                      color: AppColors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            sliver: SliverList.separated(
              itemCount: _destinations.length,
              separatorBuilder: (_, _) => const SizedBox(height: 14),
              itemBuilder: (context, i) =>
                  _DestinationCard(d: _destinations[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _SosButton extends StatelessWidget {
  const _SosButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.danger,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: const SizedBox(
          width: 44,
          height: 44,
          child: Center(
            child: Text(
              'SOS',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 12,
                letterSpacing: 0.6,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DestinationCard extends StatelessWidget {
  const _DestinationCard({required this.d});
  final _Destination d;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return SoftCard(
      onTap: () {},
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: SizedBox(
              height: 160,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (d.imageUrl != null)
                    Image.network(
                      d.imageUrl!,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return _IconPlaceholder(
                          color: d.imageColor,
                          icon: d.imageIcon,
                        );
                      },
                      errorBuilder: (context, error, stack) =>
                          _IconPlaceholder(
                        color: d.imageColor,
                        icon: d.imageIcon,
                      ),
                    )
                  else
                    _IconPlaceholder(
                      color: d.imageColor,
                      icon: d.imageIcon,
                    ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        d.tag,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(d.name, style: text.titleMedium),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.place_outlined,
                              size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 4),
                          Text(d.region, style: text.bodyMedium),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textMuted),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Destination {
  const _Destination(
    this.name,
    this.region,
    this.tag,
    this.imageIcon,
    this.imageColor, {
    this.imageUrl,
  });
  final String name;
  final String region;
  final String tag;
  final IconData imageIcon;
  final Color imageColor;
  final String? imageUrl;
}

class _IconPlaceholder extends StatelessWidget {
  const _IconPlaceholder({required this.color, required this.icon});

  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      alignment: Alignment.center,
      child: Icon(
        icon,
        size: 64,
        color: AppColors.green.withValues(alpha: 0.65),
      ),
    );
  }
}
