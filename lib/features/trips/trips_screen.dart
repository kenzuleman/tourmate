import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/soft_card.dart';

class TripsScreen extends StatelessWidget {
  const TripsScreen({super.key});

  static const _trips = [
    _Trip('Hunza Adventure', 'May 12 – May 18', '5 stops', false),
    _Trip('Lahore Heritage Walk', 'June 02 – June 04', '8 stops', true),
    _Trip('Skardu Expedition', 'July 20 – July 28', '6 stops', false),
    _Trip('Neelum Valley Escape', 'Aug 10 – Aug 13', '4 stops', true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Trips'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Material(
              color: AppColors.green,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(14),
                child: const SizedBox(
                  width: 44,
                  height: 44,
                  child: Icon(Icons.add_rounded,
                      color: Colors.white, size: 24),
                ),
              ),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            sliver: SliverList.separated(
              itemCount: _trips.length,
              separatorBuilder: (_, _) => const SizedBox(height: 14),
              itemBuilder: (context, i) => _TripCard(trip: _trips[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _Trip {
  const _Trip(this.name, this.dates, this.stops, this.downloaded);
  final String name;
  final String dates;
  final String stops;
  final bool downloaded;
}

class _TripCard extends StatelessWidget {
  const _TripCard({required this.trip});
  final _Trip trip;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return SoftCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.greenSoft,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.map_outlined,
                    color: AppColors.green, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(trip.name, style: text.titleMedium),
                    const SizedBox(height: 4),
                    Text(trip.dates, style: text.bodyMedium),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 14, color: AppColors.textMuted),
                        const SizedBox(width: 4),
                        Text(trip.stops,
                            style: text.bodyMedium?.copyWith(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(
                trip.downloaded
                    ? Icons.check_circle_rounded
                    : Icons.download_rounded,
                size: 20,
              ),
              label: Text(trip.downloaded
                  ? 'Available Offline'
                  : 'Download for Offline'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
