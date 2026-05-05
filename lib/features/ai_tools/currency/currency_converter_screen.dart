import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/soft_card.dart';

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  State<CurrencyConverterScreen> createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  static const Map<String, double> _ratesToPkr = {
    'PKR': 1.0,
    'USD': 278.0,
    'AED': 75.7,
    'SAR': 74.0,
    'GBP': 352.0,
    'EUR': 302.0,
    'CAD': 202.0,
    'CNY': 38.3,
  };

  static const List<String> _currencies = ['PKR', 'USD', 'AED', 'SAR', 'GBP', 'EUR', 'CAD', 'CNY'];

  static const Map<String, String> _currencyNames = {
    'PKR': 'Pakistani Rupee',
    'USD': 'US Dollar',
    'AED': 'UAE Dirham',
    'SAR': 'Saudi Riyal',
    'GBP': 'British Pound',
    'EUR': 'Euro',
    'CAD': 'Canadian Dollar',
    'CNY': 'Chinese Yuan',
  };

  static const Map<String, String> _currencyFlags = {
    'PKR': '🇵🇰',
    'USD': '🇺🇸',
    'AED': '🇦🇪',
    'SAR': '🇸🇦',
    'GBP': '🇬🇧',
    'EUR': '🇪🇺',
    'CAD': '🇨🇦',
    'CNY': '🇨🇳',
  };

  String _fromCurrency = 'USD';
  String _toCurrency = 'PKR';
  final TextEditingController _amountCtrl = TextEditingController();
  String _resultText = '';
  String _resultCurrency = '';

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  void _convert() {
    final input = double.tryParse(_amountCtrl.text.trim());
    if (input == null) {
      setState(() => _resultText = 'Please enter a valid amount');
      return;
    }
    final fromRate = _ratesToPkr[_fromCurrency]!;
    final toRate = _ratesToPkr[_toCurrency]!;
    final result = input * fromRate / toRate;
    setState(() {
      _resultText = result.toStringAsFixed(2);
      _resultCurrency = _toCurrency;
    });
  }

  void _swapCurrencies() {
    setState(() {
      final temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
      _resultText = '';
    });
    if (_amountCtrl.text.isNotEmpty) _convert();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Currency Converter')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SoftCard(
              color: AppColors.greenSoft,
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: AppColors.green, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Rates are approximate (early 2025). For live rates, check your bank.',
                      style: text.bodyMedium?.copyWith(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SoftCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: _CurrencySelector(
                          label: 'From',
                          value: _fromCurrency,
                          currencies: _currencies,
                          names: _currencyNames,
                          flags: _currencyFlags,
                          onChanged: (v) => setState(() { _fromCurrency = v!; _resultText = ''; }),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4, left: 8, right: 8),
                        child: GestureDetector(
                          onTap: _swapCurrencies,
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.green,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.swap_horiz_rounded, color: Colors.white, size: 24),
                          ),
                        ),
                      ),
                      Expanded(
                        child: _CurrencySelector(
                          label: 'To',
                          value: _toCurrency,
                          currencies: _currencies,
                          names: _currencyNames,
                          flags: _currencyFlags,
                          onChanged: (v) => setState(() { _toCurrency = v!; _resultText = ''; }),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _amountCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onSubmitted: (_) => _convert(),
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      prefixIcon: const Icon(Icons.attach_money_rounded),
                      suffixText: _fromCurrency,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _convert,
                      child: const Text('Convert'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _resultText.isEmpty
                  ? const SizedBox.shrink()
                  : SoftCard(
                      key: ValueKey(_resultText + _resultCurrency),
                      color: AppColors.greenSoft,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${_amountCtrl.text} ${_currencyFlags[_fromCurrency]} $_fromCurrency =',
                            style: text.bodyMedium?.copyWith(color: AppColors.textMuted),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _resultText,
                            style: text.headlineLarge?.copyWith(
                              color: AppColors.green,
                              fontSize: 38,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            '${_currencyFlags[_toCurrency]} $_toCurrency',
                            style: text.titleMedium?.copyWith(color: AppColors.green),
                          ),
                          const SizedBox(height: 12),
                          const Divider(),
                          const SizedBox(height: 4),
                          Text(
                            _currencyNames[_toCurrency]!,
                            style: text.bodyMedium?.copyWith(color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: 24),
            Text('Quick Reference (to PKR)', style: text.titleMedium),
            const SizedBox(height: 12),
            SoftCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: _currencies
                    .where((c) => c != 'PKR')
                    .map((c) => Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Text('${_currencyFlags[c]} $c', style: text.titleMedium),
                                  const SizedBox(width: 6),
                                  Text(_currencyNames[c]!, style: text.bodyMedium?.copyWith(color: AppColors.textMuted, fontSize: 12)),
                                  const Spacer(),
                                  Text(
                                    '= PKR ${_ratesToPkr[c]!.toStringAsFixed(1)}',
                                    style: text.titleMedium?.copyWith(color: AppColors.green),
                                  ),
                                ],
                              ),
                            ),
                            if (c != _currencies.where((x) => x != 'PKR').last)
                              const Divider(height: 1),
                          ],
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurrencySelector extends StatelessWidget {
  const _CurrencySelector({
    required this.label,
    required this.value,
    required this.currencies,
    required this.names,
    required this.flags,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> currencies;
  final Map<String, String> names;
  final Map<String, String> flags;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.greenSoft,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              isDense: true,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
              items: currencies.map((c) => DropdownMenuItem(
                value: c,
                child: Text('${flags[c]} $c'),
              )).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          names[value]!,
          style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
