import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/life_bloc.dart';
import '../../core/design.dart';
import '../../domain/models.dart';
import '../pages/entry_detail_sheet.dart';

class EntryTile extends StatelessWidget {
  const EntryTile({super.key, required this.entry});

  final LifeEntry entry;

  @override
  Widget build(BuildContext context) {
    final color = kindColor(entry.kind);
    final saving = context.watch<LifeBloc>().state.saving;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      onTap: () => showEntryDetails(context, entry),
      leading: entry.isTask
          ? SizedBox(
              width: 42,
              height: 48,
              child: Checkbox(
                value: entry.done,
                activeColor: brand,
                shape: const CircleBorder(),
                onChanged: saving
                    ? null
                    : (_) {
                        context.read<LifeBloc>().add(TaskToggled(entry.id));
                      },
              ),
            )
          : Container(
              width: 42,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(kindIcon(entry.kind), color: color, size: 22),
            ),
      title: Text(
        entry.title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: entry.done ? muted : ink,
          decoration: entry.isTask && entry.done
              ? TextDecoration.lineThrough
              : null,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            Text(
              '${dateText(entry.due)}'
              '${entry.isTask ? ' · ${timeText(entry.due)}' : ''}',
              style: const TextStyle(fontSize: 11, color: muted),
            ),
            if (entry.shared)
              const Icon(Icons.people_outline, size: 14, color: brand),
            if (entry.reminder)
              const Icon(Icons.notifications_none, size: 14, color: muted),
          ],
        ),
      ),
      trailing: entry.isMoney
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${entry.kind == EntryKind.income ? '+' : ''}'
                  '${money(entry.amount, entry.currency)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: color,
                  ),
                ),
                if (entry.kind == EntryKind.bill)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      tr(context, entry.done ? 'paid' : 'unpaid'),
                      style: TextStyle(
                        fontSize: 10,
                        color: entry.done ? brand : amber,
                      ),
                    ),
                  ),
              ],
            )
          : const Icon(Icons.chevron_right, color: muted, size: 18),
    );
  }
}
