import 'package:flutter/material.dart';
import '../utils/formatters.dart';

/// Batas atas slider harga (= "tanpa batas").
const double maxPriceFilter = 50000;

class FilterBottomSheet extends StatefulWidget {
  final String selectedCategory;
  final double maxPrice;
  final Function(String category, double maxPrice) onApply;

  const FilterBottomSheet({
    super.key,
    required this.selectedCategory,
    required this.maxPrice,
    required this.onApply,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late String _currentCategory;
  late double _currentMaxPrice;

  final List<String> _categories = const [
    'Semua',
    'Seminar',
    'Workshop',
    'Festival',
  ];

  @override
  void initState() {
    super.initState();
    _currentCategory = widget.selectedCategory;
    _currentMaxPrice = widget.maxPrice;
  }

  String get _priceLabel {
    if (_currentMaxPrice == 0) return 'Hanya gratis';
    if (_currentMaxPrice >= maxPriceFilter) return 'Semua harga';
    return '≤ ${formatRupiah(_currentMaxPrice)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sectionStyle = theme.textTheme.labelLarge?.copyWith(
      fontWeight: FontWeight.w600,
    );

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          0,
          20,
          MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Filter Katalog Event',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => setState(() {
                    _currentCategory = 'Semua';
                    _currentMaxPrice = maxPriceFilter;
                  }),
                  child: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Text('Kategori Kegiatan', style: sectionStyle),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categories.map((cat) {
                return ChoiceChip(
                  label: Text(cat),
                  selected: _currentCategory == cat,
                  onSelected: (selected) {
                    if (selected) setState(() => _currentCategory = cat);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Text('Biaya Maksimum', style: sectionStyle),
                const Spacer(),
                Text(
                  _priceLabel,
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Slider(
              value: _currentMaxPrice,
              min: 0,
              max: maxPriceFilter,
              divisions: 10,
              label: formatRupiah(_currentMaxPrice),
              padding: const EdgeInsets.symmetric(vertical: 12),
              onChanged: (val) => setState(() => _currentMaxPrice = val),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  widget.onApply(_currentCategory, _currentMaxPrice);
                  Navigator.pop(context);
                },
                child: const Text('Terapkan Filter'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
