import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/soft_card.dart';

class PackingScreen extends StatefulWidget {
  const PackingScreen({super.key});

  @override
  State<PackingScreen> createState() => _PackingScreenState();
}

class _PackingScreenState extends State<PackingScreen> {
  final TextEditingController _destCtrl = TextEditingController();
  int? _selectedMonth;
  List<_PackItem> _items = [];
  bool _listGenerated = false;

  static const List<String> _monthAbbr = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  void dispose() {
    _destCtrl.dispose();
    super.dispose();
  }

  String _getSeason(int month) {
    if ([12, 1, 2].contains(month)) return 'Winter';
    if ([3, 4, 5].contains(month)) return 'Spring';
    if ([6, 7, 8].contains(month)) return 'Summer';
    return 'Autumn';
  }

  String _getDestType(String dest) {
    final d = dest.toLowerCase();
    if (d.contains('hunza') || d.contains('skardu') || d.contains('naran') ||
        d.contains('gilgit') || d.contains('fairy') || d.contains('mountain') ||
        d.contains('swat') || d.contains('murree') || d.contains('kaghan') ||
        d.contains('chitral') || d.contains('neelum')) { return 'Mountains'; }
    if (d.contains('karachi') || d.contains('beach') || d.contains('gwadar') ||
        d.contains('makran') || d.contains('coastal')) { return 'Beach'; }
    return 'Plains';
  }

  void _generateList() {
    if (_destCtrl.text.trim().isEmpty || _selectedMonth == null) return;
    final season = _getSeason(_selectedMonth!);
    final destType = _getDestType(_destCtrl.text);
    setState(() {
      _items = _buildList(season, destType);
      _listGenerated = true;
    });
  }

  List<_PackItem> _buildList(String season, String destType) {
    final List<_PackItem> items = [];

    if (destType == 'Mountains') {
      if (season == 'Winter') {
        items.addAll([
          _PackItem('Heavy down jacket', 'Clothing'),
          _PackItem('Thermal base layers (×3)', 'Clothing'),
          _PackItem('Wool socks (×4 pairs)', 'Clothing'),
          _PackItem('Fleece mid-layer', 'Clothing'),
          _PackItem('Waterproof outer shell', 'Clothing'),
          _PackItem('Gloves and beanie', 'Clothing'),
          _PackItem('Waterproof hiking boots', 'Gear'),
          _PackItem('Snow gaiters', 'Gear'),
          _PackItem('Hiking poles', 'Gear'),
          _PackItem('Sunglasses (UV protection)', 'Gear'),
          _PackItem('Head torch + spare batteries', 'Gear'),
          _PackItem('First aid kit', 'Gear'),
          _PackItem('Sunscreen SPF 50+', 'Essentials'),
          _PackItem('Lip balm with SPF', 'Essentials'),
          _PackItem('Power bank', 'Essentials'),
          _PackItem('Water purification tablets', 'Essentials'),
          _PackItem('CNIC / Passport', 'Documents'),
          _PackItem('Travel insurance documents', 'Documents'),
          _PackItem('Hotel booking confirmations', 'Documents'),
          _PackItem('Emergency contacts card', 'Documents'),
        ]);
      } else if (season == 'Summer') {
        items.addAll([
          _PackItem('Light layers (×4)', 'Clothing'),
          _PackItem('Windproof jacket', 'Clothing'),
          _PackItem('Hiking pants (×2)', 'Clothing'),
          _PackItem('Moisture-wicking t-shirts (×3)', 'Clothing'),
          _PackItem('Hat / cap', 'Clothing'),
          _PackItem('Hiking boots', 'Gear'),
          _PackItem('Trekking poles', 'Gear'),
          _PackItem('Head torch', 'Gear'),
          _PackItem('First aid kit', 'Gear'),
          _PackItem('Reusable water bottle (2L)', 'Gear'),
          _PackItem('Sunscreen SPF 50+', 'Essentials'),
          _PackItem('Insect repellent', 'Essentials'),
          _PackItem('Power bank', 'Essentials'),
          _PackItem('Trail snacks / energy bars', 'Essentials'),
          _PackItem('CNIC / Passport', 'Documents'),
          _PackItem('Travel insurance documents', 'Documents'),
          _PackItem('Hotel booking confirmations', 'Documents'),
        ]);
      } else {
        items.addAll([
          _PackItem('Medium-weight jacket', 'Clothing'),
          _PackItem('Fleece layer', 'Clothing'),
          _PackItem('Waterproof outer layer', 'Clothing'),
          _PackItem('Hiking pants (×2)', 'Clothing'),
          _PackItem('Light gloves', 'Clothing'),
          _PackItem('Hiking boots', 'Gear'),
          _PackItem('First aid kit', 'Gear'),
          _PackItem('Sunscreen SPF 30+', 'Essentials'),
          _PackItem('Power bank', 'Essentials'),
          _PackItem('Camera + spare battery', 'Essentials'),
          _PackItem('CNIC / Passport', 'Documents'),
          _PackItem('Hotel booking confirmations', 'Documents'),
        ]);
      }
    } else if (destType == 'Beach') {
      items.addAll([
        _PackItem('Swimwear (×2)', 'Clothing'),
        _PackItem('Lightweight shirts (×4)', 'Clothing'),
        _PackItem('Shorts / light trousers', 'Clothing'),
        _PackItem('Flip flops + walking shoes', 'Clothing'),
        _PackItem('Sun hat', 'Clothing'),
        _PackItem('Sunglasses', 'Gear'),
        _PackItem('Waterproof bag', 'Gear'),
        _PackItem('Snorkeling gear (optional)', 'Gear'),
        _PackItem('Sunscreen SPF 50+', 'Essentials'),
        _PackItem('After-sun lotion', 'Essentials'),
        _PackItem('Insect repellent', 'Essentials'),
        _PackItem('Power bank', 'Essentials'),
        _PackItem('CNIC / Passport', 'Documents'),
        _PackItem('Travel insurance documents', 'Documents'),
      ]);
    } else {
      if (season == 'Winter') {
        items.addAll([
          _PackItem('Warm sweater (×2)', 'Clothing'),
          _PackItem('Light jacket', 'Clothing'),
          _PackItem('Comfortable walking shoes', 'Clothing'),
          _PackItem('Scarf', 'Clothing'),
          _PackItem('City map / transport card', 'Gear'),
          _PackItem('Power bank', 'Essentials'),
          _PackItem('Hand sanitizer', 'Essentials'),
          _PackItem('CNIC / Passport', 'Documents'),
          _PackItem('Hotel booking confirmations', 'Documents'),
        ]);
      } else {
        items.addAll([
          _PackItem('Light cotton clothing (×5)', 'Clothing'),
          _PackItem('Comfortable sandals', 'Clothing'),
          _PackItem('Sun hat', 'Clothing'),
          _PackItem('Sunscreen SPF 30+', 'Essentials'),
          _PackItem('Insect repellent', 'Essentials'),
          _PackItem('Oral rehydration salts', 'Essentials'),
          _PackItem('Power bank', 'Essentials'),
          _PackItem('Hand sanitizer', 'Essentials'),
          _PackItem('CNIC / Passport', 'Documents'),
          _PackItem('Hotel booking confirmations', 'Documents'),
        ]);
      }
    }

    return items;
  }

  int get _checkedCount => _items.where((i) => i.checked).length;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final categories = ['Clothing', 'Gear', 'Essentials', 'Documents'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Packing Assistant')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StepHeader(number: '1', title: 'Where are you going?'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _destCtrl,
                    onChanged: (_) => setState(() { _listGenerated = false; _selectedMonth = null; }),
                    decoration: const InputDecoration(
                      hintText: 'e.g. Hunza, Lahore, Skardu...',
                      prefixIcon: Icon(Icons.place_outlined, color: AppColors.textMuted),
                    ),
                  ),
                ),
              ],
            ),
            if (_destCtrl.text.trim().isNotEmpty) ...[
              const SizedBox(height: 24),
              _StepHeader(number: '2', title: 'When are you travelling?'),
              const SizedBox(height: 12),
              SizedBox(
                height: 44,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 12,
                  itemBuilder: (context, i) {
                    final selected = _selectedMonth == i + 1;
                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedMonth = i + 1);
                        _generateList();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: EdgeInsets.only(right: i < 11 ? 8 : 0),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: selected ? AppColors.green : AppColors.greenSoft,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Text(
                          _monthAbbr[i],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: selected ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            if (_listGenerated) ...[
              const SizedBox(height: 24),
              _StepHeader(number: '3', title: 'Your packing list'),
              const SizedBox(height: 4),
              Text(
                '${_destCtrl.text.trim()} · ${_getSeason(_selectedMonth!)} · ${_getDestType(_destCtrl.text)}',
                style: text.bodyMedium?.copyWith(color: AppColors.textMuted),
              ),
              const SizedBox(height: 16),
              for (final category in categories)
                if (_items.any((i) => i.category == category)) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(category, style: text.titleMedium),
                      ],
                    ),
                  ),
                  SoftCard(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      children: _items
                          .where((i) => i.category == category)
                          .map((item) => _PackItemRow(
                                item: item,
                                onToggle: () => setState(() => item.checked = !item.checked),
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              const SizedBox(height: 4),
              SoftCard(
                color: AppColors.greenSoft,
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Icon(
                      _checkedCount == _items.length
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      color: AppColors.green,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '$_checkedCount of ${_items.length} items packed',
                      style: text.bodyMedium?.copyWith(
                        color: AppColors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    if (_checkedCount == _items.length)
                      const Text('Ready! 🎒', style: TextStyle(fontSize: 13, color: AppColors.green)),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PackItem {
  _PackItem(this.label, this.category);
  final String label;
  final String category;
  bool checked = false;
}

class _PackItemRow extends StatelessWidget {
  const _PackItemRow({required this.item, required this.onToggle});
  final _PackItem item;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggle,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Row(
          children: [
            Checkbox(
              value: item.checked,
              onChanged: (_) => onToggle(),
              activeColor: AppColors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            ),
            Expanded(
              child: Text(
                item.label,
                style: TextStyle(
                  fontSize: 14,
                  color: item.checked ? AppColors.textMuted : AppColors.textPrimary,
                  decoration: item.checked ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepHeader extends StatelessWidget {
  const _StepHeader({required this.number, required this.title});
  final String number;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: AppColors.green,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(title, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}
