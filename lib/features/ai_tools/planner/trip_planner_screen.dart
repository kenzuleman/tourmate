import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/soft_card.dart';

class TripPlannerScreen extends StatefulWidget {
  const TripPlannerScreen({super.key});

  @override
  State<TripPlannerScreen> createState() => _TripPlannerScreenState();
}

class _TripPlannerScreenState extends State<TripPlannerScreen> {
  int _tabIndex = 0;
  late List<_TripPlan> _myPlans;
  late List<_TripPlan> _aiPlans;

  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _formatDate(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';
  String _formatDateShort(DateTime d) => '${d.day} ${_months[d.month - 1]}';

  @override
  void initState() {
    super.initState();
    _myPlans = [];
    _aiPlans = [
      _TripPlan(
        destination: 'Hunza Valley',
        startDate: DateTime(2025, 7, 1),
        endDate: DateTime(2025, 7, 5),
        style: 'Adventure',
        isAiGenerated: true,
        days: [
          _TripDay(1, 'Arrival in Gilgit', [
            _DayActivity('02:00 PM', 'Fly / drive to Gilgit', 'Gateway to Hunza — scenic Karakoram views'),
            _DayActivity('06:00 PM', 'Check in to hotel', 'Rest and freshen up'),
            _DayActivity('08:00 PM', 'Welcome dinner', 'Karahi and fresh mountain trout'),
          ]),
          _TripDay(2, 'Karimabad & Baltit Fort', [
            _DayActivity('09:00 AM', 'Baltit Fort', '900-year-old Hunza palace — panoramic valley views'),
            _DayActivity('12:00 PM', 'Lunch at a local café', 'Valley views with traditional food'),
            _DayActivity('03:00 PM', 'Altit Fort & Old Hunza Town', 'Walk through ancient lanes'),
            _DayActivity('06:00 PM', 'Sunset at Eagle\'s Nest', 'Best viewpoint in Hunza'),
          ]),
          _TripDay(3, 'Attabad Lake', [
            _DayActivity('08:00 AM', 'Boat trip on Attabad Lake', 'Stunning turquoise water'),
            _DayActivity('11:00 AM', 'Passu Cones photo stop', 'Iconic jagged peaks'),
            _DayActivity('01:00 PM', 'Packed lunch by the lake', ''),
            _DayActivity('04:00 PM', 'Return drive with scenic stops', ''),
          ]),
          _TripDay(4, 'Rakaposhi Base Camp Trek', [
            _DayActivity('07:00 AM', 'Drive to Minapin', ''),
            _DayActivity('08:30 AM', 'Trek to Rakaposhi Base Camp', 'Moderate, 4–5 hrs round trip'),
            _DayActivity('02:00 PM', 'Return and rest', ''),
            _DayActivity('07:00 PM', 'Celebration dinner', ''),
          ]),
          _TripDay(5, 'Departure', [
            _DayActivity('09:00 AM', 'Morning market for souvenirs', 'Dried apricots, local crafts, gems'),
            _DayActivity('11:00 AM', 'Drive back to Gilgit airport', 'Safe travels!'),
          ]),
        ],
      ),
      _TripPlan(
        destination: 'Lahore Heritage',
        startDate: DateTime(2025, 3, 10),
        endDate: DateTime(2025, 3, 12),
        style: 'Cultural',
        isAiGenerated: true,
        days: [
          _TripDay(1, 'Walled City', [
            _DayActivity('10:00 AM', 'Lahore Fort & Sheesh Mahal', 'Mughal architecture at its finest'),
            _DayActivity('12:30 PM', 'Lunch at Andaaz Restaurant', 'Traditional Punjabi cuisine'),
            _DayActivity('02:30 PM', 'Badshahi Mosque & Hazuri Bagh', 'One of the world\'s largest mosques'),
            _DayActivity('05:00 PM', 'Delhi Gate area stroll', ''),
            _DayActivity('08:00 PM', 'Gawalmandi Food Street', 'Legendary street food experience'),
          ]),
          _TripDay(2, 'Museums & Mughal Gardens', [
            _DayActivity('09:00 AM', 'Shalimar Gardens', 'UNESCO-listed Mughal gardens'),
            _DayActivity('11:30 AM', 'Lahore Museum', 'Famous Fasting Buddha statue'),
            _DayActivity('01:30 PM', 'Anarkali Bazaar', 'Traditional clothes and lunch'),
            _DayActivity('03:30 PM', 'Wazir Khan Mosque', 'Exquisite tile art and calligraphy'),
            _DayActivity('07:00 PM', 'Food walk — Bhati Gate', ''),
          ]),
          _TripDay(3, 'Modern Lahore', [
            _DayActivity('10:00 AM', 'Packages Mall / Liberty Market', 'Shopping'),
            _DayActivity('01:00 PM', 'Monal Restaurant for lunch', 'Scenic hilltop dining'),
            _DayActivity('03:00 PM', 'Minar-e-Pakistan', 'Historic monument'),
            _DayActivity('05:00 PM', 'Coffee at a Liberty café', ''),
            _DayActivity('07:00 PM', 'Departure', ''),
          ]),
        ],
      ),
      _TripPlan(
        destination: 'Neelum Valley',
        startDate: DateTime(2025, 6, 15),
        endDate: DateTime(2025, 6, 17),
        style: 'Family',
        isAiGenerated: true,
        days: [
          _TripDay(1, 'Arrival in Muzaffarabad', [
            _DayActivity('10:00 AM', 'Drive from Islamabad to Muzaffarabad', 'Scenic 3-hour road trip through mountains'),
            _DayActivity('01:30 PM', 'Lunch in Muzaffarabad', 'Try local AJK cuisine'),
            _DayActivity('03:00 PM', 'Continue to Neelum Valley', 'Enjoy the riverside drive'),
            _DayActivity('06:00 PM', 'Check in at guesthouse', 'Family-friendly accommodation by the river'),
          ]),
          _TripDay(2, 'Arang Kel & Kel Village', [
            _DayActivity('07:00 AM', 'Boat ride across Neelum River', 'Short but thrilling ride'),
            _DayActivity('08:00 AM', 'Trek to Arang Kel', '2-hour moderate hike through pine forest'),
            _DayActivity('10:30 AM', 'Explore Arang Kel village', 'Remote hillside village with stunning views'),
            _DayActivity('12:30 PM', 'Picnic lunch with valley views', ''),
            _DayActivity('02:30 PM', 'Return trek to Kel', ''),
            _DayActivity('05:00 PM', 'Relax by Neelum River', 'Crystal-clear water and green banks'),
          ]),
          _TripDay(3, 'Shounter Lake & Departure', [
            _DayActivity('08:00 AM', 'Morning jeep safari to Shounter Lake', 'Remote alpine lake surrounded by glaciers'),
            _DayActivity('11:00 AM', 'Photography and nature walk', ''),
            _DayActivity('01:00 PM', 'Lunch and pack up', ''),
            _DayActivity('03:00 PM', 'Drive back to Muzaffarabad', ''),
            _DayActivity('07:00 PM', 'Return to Islamabad', 'Safe travels!'),
          ]),
        ],
      ),
      _TripPlan(
        destination: 'Skardu Adventure',
        startDate: DateTime(2025, 8, 5),
        endDate: DateTime(2025, 8, 8),
        style: 'Adventure',
        isAiGenerated: true,
        days: [
          _TripDay(1, 'Fly to Skardu', [
            _DayActivity('10:00 AM', 'PIA flight Islamabad → Skardu', 'Scenic Karakoram aerial views'),
            _DayActivity('12:30 PM', 'Check in Shangrila Resort', ''),
            _DayActivity('02:00 PM', 'Upper Kachura Lake boat ride', 'Crystal-clear mountain lake'),
            _DayActivity('06:00 PM', 'Skardu Bazaar walk', ''),
          ]),
          _TripDay(2, 'Deosai Plains', [
            _DayActivity('06:30 AM', 'Drive to Deosai National Park', 'World\'s 2nd highest plateau'),
            _DayActivity('09:00 AM', 'Wildlife spotting', 'Brown bears, snow leopards possible'),
            _DayActivity('01:00 PM', 'Picnic lunch on the plains', 'Surrounded by wildflowers'),
            _DayActivity('04:00 PM', 'Return via Satpara Lake', ''),
          ]),
          _TripDay(3, 'Shigar Fort & Valley', [
            _DayActivity('09:00 AM', 'Shigar Fort', '600-year-old fort, now a heritage hotel'),
            _DayActivity('11:30 AM', 'Shigar Valley walk', 'Green fields and apricot trees'),
            _DayActivity('01:00 PM', 'Local trout lunch', ''),
            _DayActivity('03:30 PM', 'Katpana Cold Desert', 'Desert surrounded by snow peaks'),
            _DayActivity('05:30 PM', 'Sunset over the Indus River', ''),
          ]),
          _TripDay(4, 'Departure', [
            _DayActivity('07:00 AM', 'Morning drive to Askole', 'K2 expedition base — optional hike'),
            _DayActivity('12:00 PM', 'Packed lunch', ''),
            _DayActivity('03:00 PM', 'Return to Skardu', ''),
            _DayActivity('06:30 PM', 'Evening flight back', 'Safe travels!'),
          ]),
        ],
      ),
    ];
  }

  void _savePlanToMyPlans(_TripPlan plan) {
    setState(() {
      plan.savedToMyPlans = true;
      if (!_myPlans.any((p) => p.destination == plan.destination && p.isAiGenerated)) {
        _myPlans.add(plan);
      }
      _tabIndex = 1;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${plan.destination} saved to My Plans'),
        backgroundColor: AppColors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  List<_TripDay> _generateDays(String dest, DateTime start, DateTime end, String style) {
    final numDays = end.difference(start).inDays + 1;
    final d = dest.toLowerCase();
    final isMountain = d.contains('hunza') || d.contains('skardu') || d.contains('naran') ||
        d.contains('mountain') || d.contains('gilgit') || d.contains('swat');
    final isCity = d.contains('lahore') || d.contains('karachi') || d.contains('islamabad') ||
        d.contains('peshawar') || d.contains('quetta') || d.contains('multan');

    return List.generate(numDays, (i) {
      if (i == 0) {
        return _TripDay(1, 'Arrival & Check-in', [
          _DayActivity('02:00 PM', 'Arrive at $dest', 'Check in to your accommodation'),
          _DayActivity('05:00 PM', 'Orientation walk', 'Explore the surroundings'),
          _DayActivity('07:30 PM', 'Welcome dinner', 'Try local cuisine'),
        ]);
      }
      if (i == numDays - 1) {
        return _TripDay(numDays, 'Departure Day', [
          _DayActivity('09:00 AM', 'Last morning breakfast', ''),
          _DayActivity('10:30 AM', 'Souvenir shopping', 'Pick up local handicrafts'),
          _DayActivity('12:00 PM', 'Departure', 'Safe travels!'),
        ]);
      }
      if (isMountain) {
        return _TripDay(i + 1, 'Day ${i + 1} — Exploration', [
          _DayActivity('08:00 AM', 'Morning trek / hike', style == 'Adventure' ? 'Challenging trail' : 'Easy nature walk'),
          _DayActivity('01:00 PM', 'Lunch with mountain views', ''),
          _DayActivity('03:00 PM', 'Visit a local attraction', ''),
          _DayActivity('06:00 PM', 'Evening at camp / hotel', ''),
        ]);
      }
      if (isCity) {
        return _TripDay(i + 1, 'Day ${i + 1} — City Sights', [
          _DayActivity('10:00 AM', 'Morning at a heritage site', ''),
          _DayActivity('01:00 PM', 'Lunch at a local restaurant', ''),
          _DayActivity('03:00 PM', 'Museum or bazaar visit', ''),
          _DayActivity('07:00 PM', 'Food street dinner', ''),
        ]);
      }
      return _TripDay(i + 1, 'Day ${i + 1} — Discover $dest', [
        _DayActivity('09:00 AM', 'Morning sightseeing', ''),
        _DayActivity('01:00 PM', 'Lunch break', ''),
        _DayActivity('03:00 PM', 'Afternoon activities', ''),
        _DayActivity('07:00 PM', 'Dinner and relax', ''),
      ]);
    });
  }

  void _showCreatePlanSheet() {
    final destCtrl = TextEditingController();
    DateTime? startDate;
    DateTime? endDate;
    String selectedStyle = 'Adventure';
    final styles = ['Adventure', 'Family', 'Cultural', 'Budget'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(20, 16, 20, 28 + MediaQuery.of(ctx).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 16),
                Text('Create Trip Plan', style: Theme.of(ctx).textTheme.titleLarge),
                const SizedBox(height: 16),
                TextField(
                  controller: destCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Destination',
                    prefixIcon: Icon(Icons.place_outlined),
                    hintText: 'e.g. Hunza, Lahore...',
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: ctx,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2027),
                          );
                          if (picked != null) { setSheetState(() => startDate = picked); }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.greenSoft,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Start Date', style: TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Text(
                                startDate != null ? _formatDateShort(startDate!) : 'Select',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: startDate != null ? AppColors.textPrimary : AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: ctx,
                            initialDate: startDate ?? DateTime.now(),
                            firstDate: startDate ?? DateTime.now(),
                            lastDate: DateTime(2027),
                          );
                          if (picked != null) { setSheetState(() => endDate = picked); }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.greenSoft,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('End Date', style: TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Text(
                                endDate != null ? _formatDateShort(endDate!) : 'Select',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: endDate != null ? AppColors.textPrimary : AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Travel Style', style: Theme.of(ctx).textTheme.titleMedium),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: styles.map((s) => GestureDetector(
                    onTap: () => setSheetState(() => selectedStyle = s),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: selectedStyle == s ? AppColors.green : AppColors.greenSoft,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        s,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: selectedStyle == s ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final dest = destCtrl.text.trim();
                      if (dest.isEmpty || startDate == null || endDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please fill all fields')),
                        );
                        return;
                      }
                      if (endDate!.isBefore(startDate!)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('End date must be after start date')),
                        );
                        return;
                      }
                      final plan = _TripPlan(
                        destination: dest,
                        startDate: startDate!,
                        endDate: endDate!,
                        style: selectedStyle,
                        days: _generateDays(dest, startDate!, endDate!, selectedStyle),
                      );
                      setState(() => _myPlans.insert(0, plan));
                      Navigator.pop(ctx);
                    },
                    child: const Text('Generate Plan'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Trip Planner')),
      floatingActionButton: _tabIndex == 1
          ? FloatingActionButton(
              onPressed: _showCreatePlanSheet,
              backgroundColor: AppColors.green,
              child: const Icon(Icons.add_rounded, color: Colors.white),
            )
          : null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.greenSoft,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  _TabSegment(label: 'AI Plans', selected: _tabIndex == 0, onTap: () => setState(() => _tabIndex = 0)),
                  _TabSegment(label: 'My Plans', selected: _tabIndex == 1, onTap: () => setState(() => _tabIndex = 1)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: IndexedStack(
              index: _tabIndex,
              children: [
                _AiPlansTab(plans: _aiPlans, onSave: _savePlanToMyPlans, formatDate: _formatDate),
                _MyPlansTab(plans: _myPlans, formatDate: _formatDate, formatDateShort: _formatDateShort),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TripPlan {
  _TripPlan({
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.style,
    required this.days,
    this.isAiGenerated = false,
  });
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final String style;
  final List<_TripDay> days;
  final bool isAiGenerated;
  bool savedToMyPlans = false;
}

class _TripDay {
  const _TripDay(this.dayNumber, this.title, this.activities);
  final int dayNumber;
  final String title;
  final List<_DayActivity> activities;
}

class _DayActivity {
  const _DayActivity(this.time, this.activity, this.note);
  final String time;
  final String activity;
  final String note;
}

class _TabSegment extends StatelessWidget {
  const _TabSegment({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.green : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : AppColors.textMuted,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StyleChip extends StatelessWidget {
  const _StyleChip(this.style);
  final String style;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.greenSoft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        style,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.green),
      ),
    );
  }
}

class _AiPlansTab extends StatelessWidget {
  const _AiPlansTab({required this.plans, required this.onSave, required this.formatDate});
  final List<_TripPlan> plans;
  final void Function(_TripPlan) onSave;
  final String Function(DateTime) formatDate;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      itemCount: plans.length,
      itemBuilder: (context, i) {
        final plan = plans[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: SoftCard(
            padding: EdgeInsets.zero,
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
                childrenPadding: EdgeInsets.zero,
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.greenSoft,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.map_rounded, color: AppColors.green),
                ),
                title: Text(plan.destination, style: text.titleMedium),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    children: [
                      _StyleChip(plan.style),
                      const SizedBox(width: 8),
                      Text('${plan.days.length} days', style: text.bodyMedium?.copyWith(color: AppColors.textMuted, fontSize: 12)),
                    ],
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        plan.savedToMyPlans ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                        color: AppColors.green,
                      ),
                      onPressed: () => onSave(plan),
                      tooltip: 'Save to My Plans',
                    ),
                    const Icon(Icons.expand_more_rounded, color: AppColors.textMuted),
                  ],
                ),
                children: [
                  Container(height: 1, color: AppColors.divider),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 13, color: AppColors.textMuted),
                        const SizedBox(width: 6),
                        Text(
                          '${formatDate(plan.startDate)} – ${formatDate(plan.endDate)}',
                          style: text.bodyMedium?.copyWith(color: AppColors.textMuted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  for (final day in plan.days)
                    _DayExpansion(day: day),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DayExpansion extends StatelessWidget {
  const _DayExpansion({required this.day});
  final _TripDay day;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'D${day.dayNumber}',
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(day.title, style: text.titleMedium?.copyWith(fontSize: 14))),
            ],
          ),
          const SizedBox(height: 8),
          for (final activity in day.activities)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 76,
                    child: Text(activity.time, style: text.bodyMedium?.copyWith(color: AppColors.textMuted, fontSize: 11)),
                  ),
                  Container(width: 2, height: 36, color: AppColors.greenSoft),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(activity.activity, style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 13)),
                        if (activity.note.isNotEmpty)
                          Text(activity.note, style: text.bodyMedium?.copyWith(color: AppColors.textMuted, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          const Divider(),
        ],
      ),
    );
  }
}

class _MyPlansTab extends StatelessWidget {
  const _MyPlansTab({required this.plans, required this.formatDate, required this.formatDateShort});
  final List<_TripPlan> plans;
  final String Function(DateTime) formatDate;
  final String Function(DateTime) formatDateShort;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    if (plans.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.event_note_rounded, size: 64, color: AppColors.greenSoft),
            const SizedBox(height: 16),
            Text('No plans yet', style: text.titleMedium),
            const SizedBox(height: 6),
            Text('Tap + to create your first trip plan', style: text.bodyMedium?.copyWith(color: AppColors.textMuted)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      itemCount: plans.length,
      itemBuilder: (context, i) {
        final plan = plans[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: SoftCard(
            padding: EdgeInsets.zero,
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                childrenPadding: EdgeInsets.zero,
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.greenSoft,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.flight_takeoff_rounded, color: AppColors.green, size: 24),
                ),
                title: Text(plan.destination, style: text.titleMedium),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${formatDateShort(plan.startDate)} – ${formatDateShort(plan.endDate)}',
                        style: text.bodyMedium?.copyWith(color: AppColors.textMuted, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      _StyleChip(plan.style),
                    ],
                  ),
                ),
                children: [
                  Container(height: 1, color: AppColors.divider),
                  for (final day in plan.days)
                    _DayExpansion(day: day),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
