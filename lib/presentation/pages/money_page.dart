import 'package:flutter/material.dart';

import '../../bloc/life_bloc.dart';
import '../../core/design.dart';
import '../../domain/models.dart';
import '../widgets/common_widgets.dart';
import '../widgets/entry_tile.dart';

class MoneyPage extends StatefulWidget {
  const MoneyPage({super.key, required this.state});

  final LifeState state;

  @override
  State<MoneyPage> createState() => _MoneyPageState();
}

class _MoneyPageState extends State<MoneyPage> {
  int section = 0;
  String? currency;

  @override
  Widget build(BuildContext context) {
    final selectedCurrency = currency ?? widget.state.currency;
    final now = DateTime.now();

    bool inMonth(LifeEntry entry) {
      return entry.currency == selectedCurrency &&
          entry.due.year == now.year &&
          entry.due.month == now.month;
    }

    final income = widget.state.data.entries
        .where((entry) => entry.kind == EntryKind.income && inMonth(entry))
        .fold<int>(0, (total, entry) => total + entry.amount);

    final expense = widget.state.data.entries
        .where((entry) => entry.kind == EntryKind.expense && inMonth(entry))
        .fold<int>(0, (total, entry) => total + entry.amount);

    final entries = widget.state.data.entries.where((entry) {
      if (entry.currency != selectedCurrency) return false;

      if (section == 1) {
        return entry.kind == EntryKind.bill;
      }

      return inMonth(entry) &&
          (entry.kind == EntryKind.income || entry.kind == EntryKind.expense);
    }).toList()..sort((a, b) => b.due.compareTo(a.due));

    return PageBody(
      children: [
        PageHeading(tr(context, 'money'), tr(context, 'moneySub')),
        Row(
          children: [
            Expanded(
              child: Text(
                '${tr(context, 'thisMonth')} · ${now.month}/${now.year}',
                style: const TextStyle(color: muted),
              ),
            ),
            DropdownButton<String>(
              value: selectedCurrency,
              underline: const SizedBox.shrink(),
              items: ['LAK', 'THB']
                  .map(
                    (value) =>
                        DropdownMenuItem(value: value, child: Text(value)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() => currency = value);
              },
            ),
          ],
        ),
        Surface(
          color: const Color(0xFFE5EDD9),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.account_balance_wallet_outlined, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      tr(context, 'balance'),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  money(income - expense, selectedCurrency),
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Divider(color: Color(0xFFCFDBBF)),
              const SizedBox(height: 16),
              Wrap(
                spacing: 28,
                runSpacing: 12,
                children: [
                  _amount(
                    context,
                    'income',
                    income,
                    selectedCurrency,
                    Icons.south_west,
                    brand,
                  ),
                  _amount(
                    context,
                    'expense',
                    expense,
                    selectedCurrency,
                    Icons.north_east,
                    const Color(0xFFAD6A37),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        buildFilters(
          context,
          ['transactions', 'billTab'],
          section,
          (value) => setState(() => section = value),
        ),
        SectionTitle(tr(context, section == 0 ? 'transactions' : 'bills')),
        if (entries.isEmpty)
          EmptyView(kind: section == 0 ? EntryKind.expense : EntryKind.bill)
        else
          Surface(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              children: [for (final entry in entries) EntryTile(entry: entry)],
            ),
          ),
      ],
    );
  }

  Widget _amount(
    BuildContext context,
    String key,
    int amount,
    String currency,
    IconData icon,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              tr(context, key),
              style: const TextStyle(fontSize: 12, color: muted),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          money(amount, currency),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}
