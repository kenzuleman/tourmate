import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/soft_card.dart';
import 'models/destination.dart';
import 'providers/discovery_providers.dart';

class DestinationDetailScreen extends ConsumerWidget {
  const DestinationDetailScreen({super.key, required this.destId});

  final String destId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final destAsync = ref.watch(destinationByIdProvider(destId));

    return destAsync.when(
      loading: () => Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline_rounded,
                  size: 48, color: AppColors.textMuted),
              const SizedBox(height: 16),
              const Text('Failed to load destination'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.refresh(destinationByIdProvider(destId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      data: (dest) {
        if (dest == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(title: const Text('Not Found')),
            body: const Center(child: Text('Destination not found')),
          );
        }
        return _buildDetail(context, dest);
      },
    );
  }

  Widget _buildDetail(BuildContext context, Destination dest) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dest.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dest.province,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  dest.imageUrl.isNotEmpty
                      ? Image.network(
                          dest.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.greenSoft,
                          ),
                        )
                      : Container(
                          color: AppColors.greenSoft,
                          alignment: Alignment.center,
                          child: Icon(Icons.location_on_rounded,
                              size: 64,
                              color: AppColors.green.withValues(alpha: 0.5)),
                        ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.6),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: dest.tags.map((tag) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.greenSoft,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Text(dest.description, style: text.bodyMedium),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Text(
                'What are you looking for in ${dest.name}?',
                style: text.titleLarge,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.9,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final cat = _categories[index];
                  return _CategoryTileWidget(
                    destId: destId,
                    label: cat.label,
                    categoryKey: cat.category,
                    icon: cat.icon,
                    bgColor: cat.bgColor,
                    iconColor: cat.iconColor,
                  );
                },
                childCount: _categories.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Six category tiles — POIs load only after opening a city/region (this screen).
const _categories = [
  (
    label: 'Attraction Points',
    category: 'attraction',
    icon: Icons.attractions_rounded,
    bgColor: Color(0xFFFFEBEE),
    iconColor: Color(0xFFD32F2F),
  ),
  (
    label: 'Restaurants',
    category: 'restaurant',
    icon: Icons.restaurant_rounded,
    bgColor: Color(0xFFFFF3E0),
    iconColor: Color(0xFFF57C00),
  ),
  (
    label: 'Hotels',
    category: 'hotel',
    icon: Icons.hotel_rounded,
    bgColor: Color(0xFFE3F2FD),
    iconColor: Color(0xFF1976D2),
  ),
  (
    label: 'ATMs / Banks',
    category: 'bank',
    icon: Icons.atm_rounded,
    bgColor: Color(0xFFE8F5E9),
    iconColor: Color(0xFF388E3C),
  ),
  (
    label: 'Hospitals',
    category: 'hospital',
    icon: Icons.local_hospital_rounded,
    bgColor: Color(0xFFF3E5F5),
    iconColor: Color(0xFF7B1FA2),
  ),
  (
    label: 'Shopping Marts',
    category: 'shopping',
    icon: Icons.shopping_cart_rounded,
    bgColor: Color(0xFFE0F7FA),
    iconColor: Color(0xFF00838F),
  ),
];

class _CategoryTileWidget extends StatelessWidget {
  const _CategoryTileWidget({
    required this.destId,
    required this.label,
    required this.categoryKey,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
  });

  final String destId;
  final String label;
  final String categoryKey;
  final IconData icon;
  final Color bgColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      color: bgColor,
      padding: const EdgeInsets.all(12),
      onTap: () => GoRouter.of(context).push(
        '/discovery/destination/$destId/places/$categoryKey',
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: iconColor,
              height: 1.2,
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
