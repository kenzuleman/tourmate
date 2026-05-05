import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/soft_card.dart';

enum _Category { food, transport, accommodation, activities, shopping, other }

class _Expense {
  _Expense({required this.amount, required this.category, required this.note, required this.date});
  final double amount;
  final _Category category;
  final String note;
  final DateTime date;
}

class ExpenseTrackerScreen extends StatefulWidget {
  const ExpenseTrackerScreen({super.key});

  @override
  State<ExpenseTrackerScreen> createState() => _ExpenseTrackerScreenState();
}

class _ExpenseTrackerScreenState extends State<ExpenseTrackerScreen> {
  double _budget = 15000.0;
  late List<_Expense> _expenses;

  static const _categoryIcon = {
    _Category.food: Icons.restaurant_rounded,
    _Category.transport: Icons.directions_car_rounded,
    _Category.accommodation: Icons.hotel_rounded,
    _Category.activities: Icons.local_activity_rounded,
    _Category.shopping: Icons.shopping_bag_rounded,
    _Category.other: Icons.more_horiz_rounded,
  };

  static const _categoryLabel = {
    _Category.food: 'Food',
    _Category.transport: 'Transport',
    _Category.accommodation: 'Stay',
    _Category.activities: 'Activities',
    _Category.shopping: 'Shopping',
    _Category.other: 'Other',
  };

  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  void initState() {
    super.initState();
    _expenses = [
      _Expense(amount: 1200, category: _Category.food, note: 'Dinner at BBQ Tonight', date: DateTime.now().subtract(const Duration(days: 2))),
      _Expense(amount: 3500, category: _Category.accommodation, note: 'Serena Hotel (1 night)', date: DateTime.now().subtract(const Duration(days: 1))),
      _Expense(amount: 800, category: _Category.transport, note: 'Lahore to Islamabad coach', date: DateTime.now()),
    ];
  }

  double get _totalSpent => _expenses.fold(0, (s, e) => s + e.amount);
  double get _progress => _budget > 0 ? (_totalSpent / _budget).clamp(0.0, 1.0) : 0.0;


  String _formatDate(DateTime d) => '${d.day} ${_months[d.month - 1]}';

  double _categoryTotal(_Category cat) =>
      _expenses.where((e) => e.category == cat).fold(0, (s, e) => s + e.amount);

  void _showBudgetSheet() {
    final ctrl = TextEditingController(text: _budget.toStringAsFixed(0));
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(20, 16, 20, 28 + MediaQuery.of(ctx).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Text('Set Budget', style: Theme.of(ctx).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextField(
              controller: ctrl,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Budget (PKR)',
                prefixIcon: Icon(Icons.attach_money_rounded),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final val = double.tryParse(ctrl.text);
                  if (val != null && val > 0) {
                    setState(() => _budget = val);
                  }
                  Navigator.pop(ctx);
                },
                child: const Text('Save Budget'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddExpenseSheet() {
    final amountCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    _Category selectedCat = _Category.food;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(20, 16, 20, 28 + MediaQuery.of(ctx).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 16),
              Text('Add Expense', style: Theme.of(ctx).textTheme.titleLarge),
              const SizedBox(height: 16),
              TextField(
                controller: amountCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Amount (PKR)',
                  prefixIcon: Icon(Icons.attach_money_rounded),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<_Category>(
                initialValue: selectedCat,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category_rounded),
                ),
                items: _Category.values.map((cat) => DropdownMenuItem(
                  value: cat,
                  child: Row(
                    children: [
                      Icon(_categoryIcon[cat], size: 18, color: AppColors.green),
                      const SizedBox(width: 8),
                      Text(_categoryLabel[cat]!),
                    ],
                  ),
                )).toList(),
                onChanged: (v) => setSheetState(() => selectedCat = v ?? _Category.food),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: noteCtrl,
                decoration: const InputDecoration(
                  labelText: 'Note (optional)',
                  prefixIcon: Icon(Icons.notes_rounded),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final amt = double.tryParse(amountCtrl.text);
                    if (amt != null && amt > 0) {
                      setState(() {
                        _expenses.insert(0, _Expense(
                          amount: amt,
                          category: selectedCat,
                          note: noteCtrl.text.trim(),
                          date: DateTime.now(),
                        ));
                      });
                      Navigator.pop(ctx);
                    }
                  },
                  child: const Text('Add Expense'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final categoriesWithExpenses = _Category.values.where((c) => _categoryTotal(c) > 0).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Expense Tracker')),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddExpenseSheet,
        backgroundColor: AppColors.green,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: SoftCard(
                color: AppColors.green,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Total Spent', style: TextStyle(color: Colors.white70, fontSize: 12)),
                            const SizedBox(height: 2),
                            Text(
                              'PKR ${_totalSpent.toStringAsFixed(0)}',
                              style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: _showBudgetSheet,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.22),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.edit_rounded, color: Colors.white, size: 20),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          'Budget: PKR ${_budget.toStringAsFixed(0)}',
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        const Spacer(),
                        Text(
                          '${(_progress * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: _progress,
                        minHeight: 10,
                        backgroundColor: Colors.white.withValues(alpha: 0.25),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (categoriesWithExpenses.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Breakdown', style: text.titleMedium),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: categoriesWithExpenses.map((cat) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: AppColors.greenSoft,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_categoryIcon[cat], size: 14, color: AppColors.green),
                            const SizedBox(width: 6),
                            Text(
                              '${_categoryLabel[cat]} · PKR ${_categoryTotal(cat).toStringAsFixed(0)}',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.green),
                            ),
                          ],
                        ),
                      )).toList(),
                    ),
                  ],
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
              child: Row(
                children: [
                  Text('Expenses', style: text.titleMedium),
                  const Spacer(),
                  Text('${_expenses.length} items', style: text.bodyMedium?.copyWith(color: AppColors.textMuted)),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
            sliver: _expenses.isEmpty
                ? SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          children: [
                            Icon(Icons.receipt_long_rounded, size: 56, color: AppColors.greenSoft),
                            const SizedBox(height: 12),
                            Text('No expenses yet', style: text.titleMedium),
                            const SizedBox(height: 6),
                            Text('Tap + to log your first expense', style: text.bodyMedium?.copyWith(color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                    ),
                  )
                : SliverList.separated(
                    itemCount: _expenses.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final e = _expenses[i];
                      return SoftCard(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.greenSoft,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(_categoryIcon[e.category], color: AppColors.green, size: 22),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    e.note.isEmpty ? _categoryLabel[e.category]! : e.note,
                                    style: text.titleMedium,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${_categoryLabel[e.category]} · ${_formatDate(e.date)}',
                                    style: text.bodyMedium?.copyWith(color: AppColors.textMuted, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'PKR ${e.amount.toStringAsFixed(0)}',
                              style: text.titleMedium?.copyWith(color: AppColors.green),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
