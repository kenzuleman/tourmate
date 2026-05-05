import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/soft_card.dart';
import 'models/destination.dart';
import 'providers/discovery_providers.dart';
import 'seeder/discovery_seeder.dart';

class DiscoveryScreen extends ConsumerStatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  ConsumerState<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends ConsumerState<DiscoveryScreen> {
  static const _chipLabels = ['All', 'Mountains', 'Heritage', 'Adventure', 'Nature', 'Cultural', 'Beach', 'Cities'];

  late TextEditingController _searchController;
  int _selectedChip = 0;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final allDestAsync = ref.watch(destinationsStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Discover'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Find your next destination', style: text.bodyMedium),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Search regions, cities, valleys...',
                      prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                      suffixIcon: Container(
                        margin: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.tune_rounded, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 44,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: _chipLabels.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, i) {
                  final selected = i == _selectedChip;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedChip = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.green : Colors.white.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Center(
                        child: Text(
                          _chipLabels[i],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: selected ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          allDestAsync.when(
            loading: () => SliverToBoxAdapter(child: _buildShimmerGrid()),
            error: (error, stack) => SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(Icons.error_outline_rounded, size: 48, color: AppColors.textMuted),
                      const SizedBox(height: 16),
                      const Text('Failed to load destinations'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.refresh(destinationsStreamProvider),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            data: (allDest) {
              final (filtered, province) = _filterDestinations(allDest);
              if (filtered.isEmpty) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Icon(Icons.location_off_rounded, size: 48, color: AppColors.textMuted),
                          const SizedBox(height: 16),
                          const Text('No destinations found'),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return _buildGrid(context, filtered, province);
            },
          ),
        ],
      ),
      floatingActionButton: _SeedButton(),
    );
  }

  (List<Destination>, String?) _filterDestinations(List<Destination> all) {
    final search = _searchController.text.trim().toLowerCase();

    if (search.isEmpty && _selectedChip == 0) {
      return (all, null);
    }

    final result = filterDestinations(all, search);
    var filtered = result.destinations;

    if (_selectedChip > 0) {
      final chipTags = {
        1: 'mountain',
        2: 'heritage',
        3: 'adventure',
        4: 'nature',
        5: 'cultural',
        6: 'beach',
        7: 'cit',
      };
      final tag = chipTags[_selectedChip];
      if (tag != null) {
        filtered = filtered
            .where((d) => d.tags.any((t) => t.toLowerCase().contains(tag)))
            .toList();
      }
    }

    return (filtered, result.matchedProvince);
  }

  Widget _buildShimmerGrid() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 0.82,
        ),
        itemCount: 6,
        itemBuilder: (_, __) => SoftCard(
          padding: EdgeInsets.zero,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.greenSoft.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, List<Destination> filtered, String? province) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(20, province != null ? 20 : 20, 20, 24),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          [
            if (province != null) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  '${filtered.length} destination${filtered.length == 1 ? '' : 's'} in $province',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.82,
                ),
                itemCount: filtered.length,
                itemBuilder: (context, i) => _DestinationTile(destination: filtered[i]),
              ),
            ] else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.82,
                ),
                itemCount: filtered.length,
                itemBuilder: (context, i) => _DestinationTile(destination: filtered[i]),
              ),
          ],
        ),
      ),
    );
  }
}

class _DestinationTile extends StatelessWidget {
  const _DestinationTile({required this.destination});

  final Destination destination;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return SoftCard(
      onTap: () => context.push('/discovery/destination/${destination.id}'),
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
              height: 110,
              width: double.infinity,
              child: destination.imageUrl.isNotEmpty
                  ? Image.network(
                      destination.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          color: AppColors.greenSoft,
                          alignment: Alignment.center,
                          child: Icon(Icons.location_on_rounded,
                              size: 40,
                              color: AppColors.green.withValues(alpha: 0.75)),
                        );
                      },
                      errorBuilder: (context, error, stack) => Container(
                        color: AppColors.greenSoft,
                        alignment: Alignment.center,
                        child: Icon(Icons.location_on_rounded,
                            size: 40,
                            color: AppColors.green.withValues(alpha: 0.75)),
                      ),
                    )
                  : Container(
                      color: AppColors.greenSoft,
                      alignment: Alignment.center,
                      child: Icon(Icons.location_on_rounded,
                          size: 40,
                          color: AppColors.green.withValues(alpha: 0.75)),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(destination.name, style: text.titleMedium, maxLines: 1),
                const SizedBox(height: 2),
                Text(destination.province,
                    style: text.bodyMedium?.copyWith(fontSize: 12), maxLines: 1),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: AppColors.green, size: 14),
                    const SizedBox(width: 2),
                    Text('4.${6 + (destination.name.length % 4)}',
                        style: text.bodyMedium?.copyWith(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SeedButton extends ConsumerStatefulWidget {
  const _SeedButton();

  @override
  ConsumerState<_SeedButton> createState() => _SeedButtonState();
}

class _SeedButtonState extends ConsumerState<_SeedButton> {
  bool _seeded = false;
  bool _seeding = false;

  @override
  void initState() {
    super.initState();
    _checkSeeded();
  }

  Future<void> _checkSeeded() async {
    final seeder = ref.read(discoverySeederProvider);
    final done = await seeder.isSeeded();
    if (mounted) {
      setState(() => _seeded = done);
    }
  }

  Future<void> _seed() async {
    setState(() => _seeding = true);
    try {
      await ref.read(discoverySeederProvider).seed();
      if (mounted) {
        setState(() {
          _seeded = true;
          _seeding = false;
        });
        ref.refresh(destinationsStreamProvider);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _seeding = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error seeding data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_seeded) return const SizedBox.shrink();

    return FloatingActionButton.extended(
      onPressed: _seeding ? null : _seed,
      backgroundColor: AppColors.green,
      disabledElevation: 4,
      icon: _seeding
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : const Icon(Icons.upload_rounded, color: Colors.white),
      label: Text(
        _seeding ? 'Seeding...' : 'Seed Data',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
