import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/soft_card.dart';

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({super.key});

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  static const List<String> _languages = ['English', 'Urdu', 'Punjabi', 'Sindhi', 'Pashto'];

  static const Map<String, Map<String, String>> _translations = {
    'hello': {
      'Urdu': 'سلام / آداب',
      'Punjabi': 'ਸਤ ਸ੍ਰੀ ਅਕਾਲ',
      'Sindhi': 'هيلو / سلام',
      'Pashto': 'سلام',
    },
    'thank you': {
      'Urdu': 'شکریہ',
      'Punjabi': 'ਧੰਨਵਾਦ',
      'Sindhi': 'مهرباني',
      'Pashto': 'مننه',
    },
    'where is the hotel': {
      'Urdu': 'ہوٹل کہاں ہے؟',
      'Punjabi': 'ਹੋਟਲ ਕਿੱਥੇ ਹੈ?',
      'Sindhi': 'هوٽل ڪٿي آهي؟',
      'Pashto': 'هوټل چیرته دی؟',
    },
    'how much': {
      'Urdu': 'کتنا ہے؟',
      'Punjabi': 'ਕਿੰਨਾ ਹੈ?',
      'Sindhi': 'ڪيترو آهي؟',
      'Pashto': 'څومره دی؟',
    },
    'food': {
      'Urdu': 'کھانا',
      'Punjabi': 'ਖਾਣਾ',
      'Sindhi': 'کاڌو',
      'Pashto': 'خواړه',
    },
    'water': {
      'Urdu': 'پانی',
      'Punjabi': 'ਪਾਣੀ',
      'Sindhi': 'پاڻي',
      'Pashto': 'اوبه',
    },
    'help': {
      'Urdu': 'مدد',
      'Punjabi': 'ਮਦਦ',
      'Sindhi': 'مدد',
      'Pashto': 'مرسته',
    },
    'good morning': {
      'Urdu': 'صبح بخیر',
      'Punjabi': 'ਸ਼ੁਭ ਸਵੇਰ',
      'Sindhi': 'صبح جو خير',
      'Pashto': 'سهار مو پخیر',
    },
    'goodbye': {
      'Urdu': 'خدا حافظ',
      'Punjabi': 'ਰੱਬ ਰਾਖਾ',
      'Sindhi': 'الله واهه',
      'Pashto': 'پرخیر',
    },
    'hospital': {
      'Urdu': 'ہسپتال',
      'Punjabi': 'ਹਸਪਤਾਲ',
      'Sindhi': 'اسپتال',
      'Pashto': 'روغتون',
    },
    'taxi': {
      'Urdu': 'ٹیکسی',
      'Punjabi': 'ਟੈਕਸੀ',
      'Sindhi': 'ٽيڪسي',
      'Pashto': 'ټکسي',
    },
    'airport': {
      'Urdu': 'ہوائی اڈہ',
      'Punjabi': 'ਹਵਾਈ ਅੱਡਾ',
      'Sindhi': 'هوائي اڏو',
      'Pashto': 'هوائی ډګر',
    },
    'beautiful': {
      'Urdu': 'خوبصورت',
      'Punjabi': 'ਸੁੰਦਰ',
      'Sindhi': 'سهڻو',
      'Pashto': 'ښکلی',
    },
    'cheap': {
      'Urdu': 'سستا',
      'Punjabi': 'ਸਸਤਾ',
      'Sindhi': 'سستو',
      'Pashto': 'ارزانه',
    },
    'yes': {
      'Urdu': 'ہاں / جی',
      'Punjabi': 'ਹਾਂ',
      'Sindhi': 'ها',
      'Pashto': 'هو',
    },
    'where can i find the nearest atm': {
      'Urdu': 'قریب ترین اے ٹی ایم کہاں مل سکتا ہے؟',
      'Punjabi': 'ਸਭ ਤੋਂ ਨਜ਼ਦੀਕੀ ATM ਕਿੱਥੇ ਹੈ?',
      'Sindhi': 'ويجهو ATM ڪٿي آهي؟',
      'Pashto': 'ترټولو نږدې ATM چیرته دی؟',
    },
  };

  String _sourceLang = 'English';
  String _targetLang = 'Urdu';
  final TextEditingController _inputCtrl = TextEditingController();
  String _translatedText = '';
  bool _isTranslating = false;

  @override
  void dispose() {
    _inputCtrl.dispose();
    super.dispose();
  }

  void _swapLanguages() {
    setState(() {
      final temp = _sourceLang;
      _sourceLang = _targetLang;
      _targetLang = temp;
      _translatedText = '';
    });
  }

  void _translate() {
    final input = _inputCtrl.text.trim();
    if (input.isEmpty) return;

    if (_sourceLang == _targetLang) {
      setState(() => _translatedText = input);
      return;
    }

    setState(() => _isTranslating = true);

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      final result = _doTranslate(input);
      setState(() {
        _translatedText = result;
        _isTranslating = false;
      });
    });
  }

  String _doTranslate(String input) {
    final lower = input.toLowerCase().trim();

    if (_sourceLang == 'English') {
      for (final entry in _translations.entries) {
        if (lower.contains(entry.key)) {
          return entry.value[_targetLang] ?? 'Translation not available';
        }
      }
      return 'Translation not found. Try phrases like: hello, thank you, food, water, taxi, help.';
    }

    if (_targetLang == 'English') {
      for (final entry in _translations.entries) {
        final translations = entry.value[_sourceLang] ?? '';
        if (translations.isNotEmpty && lower.contains(translations.toLowerCase())) {
          return entry.key[0].toUpperCase() + entry.key.substring(1);
        }
      }
      return 'Translation not found. Try typing in $_sourceLang.';
    }

    return 'Direct translation between $_sourceLang and $_targetLang is not available in demo mode. Please use English as an intermediate language.';
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Language Translator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SoftCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(child: _LangSelector(
                    label: 'From',
                    value: _sourceLang,
                    languages: _languages,
                    onChanged: (v) => setState(() { _sourceLang = v!; _translatedText = ''; }),
                  )),
                  GestureDetector(
                    onTap: _swapLanguages,
                    child: Container(
                      width: 44,
                      height: 44,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: AppColors.greenSoft,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.swap_horiz_rounded, color: AppColors.green, size: 24),
                    ),
                  ),
                  Expanded(child: _LangSelector(
                    label: 'To',
                    value: _targetLang,
                    languages: _languages,
                    onChanged: (v) => setState(() { _targetLang = v!; _translatedText = ''; }),
                  )),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _inputCtrl,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Enter text to translate...',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isTranslating ? null : _translate,
                    child: _isTranslating
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Translate'),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.greenSoft,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.record_voice_over_rounded, color: AppColors.green),
                ),
              ],
            ),
            if (_translatedText.isNotEmpty) ...[
              const SizedBox(height: 20),
              SoftCard(
                color: AppColors.greenSoft,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.translate_rounded, color: AppColors.green, size: 18),
                        const SizedBox(width: 8),
                        Text('Translation ($_targetLang)',
                            style: text.bodyMedium?.copyWith(color: AppColors.textMuted)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SelectableText(
                      _translatedText,
                      style: text.titleLarge?.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.5,
                      ),
                    ),
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

class _LangSelector extends StatelessWidget {
  const _LangSelector({
    required this.label,
    required this.value,
    required this.languages,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> languages;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
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
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              items: languages.map((lang) => DropdownMenuItem(
                value: lang,
                child: Text(lang),
              )).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
