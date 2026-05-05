import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/soft_card.dart';
import 'models/place.dart';
import 'place_detail_sheet.dart';
import 'providers/discovery_providers.dart';

String _categoryLabel(String category) => const {
  'attraction': 'Attraction Points',
  'hotel': 'Hotels',
  'restaurant': 'Restaurants',
  'bank': 'ATMs / Banks',
  'mobile_wallet': 'Mobile Wallets',
  'shopping': 'Shopping Marts',
  'rental': 'Rental Services',
  'workshop': 'Workshops',
  'gas_station': 'Gas Stations',
  'hospital': 'Hospitals',
}[category] ?? category;

class PlacesListScreen extends ConsumerWidget {
  const PlacesListScreen({
    super.key,
    required this.destId,
    required this.category,
  });

  final String destId;
  final String category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final placesAsync = ref.watch(placesProvider((destId: destId, category: category)));
    final destAsync = ref.watch(destinationByIdProvider(destId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: destAsync.when(
          loading: () => Text(_categoryLabel(category)),
          error: (_, __) => Text(_categoryLabel(category)),
          data: (dest) => Text('${_categoryLabel(category)} in ${dest?.name ?? ''}'),
        ),
      ),
      body: placesAsync.when(
        loading: () => _buildShimmerList(),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline_rounded,
                  size: 48, color: AppColors.textMuted),
              const SizedBox(height: 16),
              const Text('Failed to load places'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(placesProvider((destId: destId, category: category))),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (places) {
          if (places.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_off_rounded,
                      size: 48, color: AppColors.textMuted),
                  const SizedBox(height: 16),
                  const Text('No places found in this category'),
                ],
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                sliver: SliverList.separated(
                  itemCount: places.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) =>
                      _PlaceListCard(place: places[index]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildShimmerList() {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          sliver: SliverList.separated(
            itemCount: 4,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, __) => SoftCard(
              padding: EdgeInsets.zero,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.greenSoft.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PlaceListCard extends StatelessWidget {
  const _PlaceListCard({required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return SoftCard(
      padding: EdgeInsets.zero,
      onTap: () => showPlaceDetailSheet(context, place),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
            child: SizedBox(
              width: 100,
              height: 100,
              child: place.imageUrl.isNotEmpty
                  ? Image.network(
                      place.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.greenSoft,
                      ),
                    )
                  : Container(
                      color: AppColors.greenSoft,
                      alignment: Alignment.center,
                      child: Icon(Icons.location_on_rounded,
                          size: 32,
                          color: AppColors.green.withValues(alpha: 0.5)),
                    ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(place.name, style: text.titleMedium, maxLines: 1),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    runSpacing: 2,
                    children: place.tags.take(3).map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.greenSoft,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    place.description,
                    style: text.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
