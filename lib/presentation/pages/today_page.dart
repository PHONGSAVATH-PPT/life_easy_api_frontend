import 'package:flutter/material.dart';

import '../../bloc/life_bloc.dart';
import '../../core/design.dart';
import '../../domain/models.dart';
import '../widgets/common_widgets.dart';
import '../widgets/entry_tile.dart';
import 'entry_form_page.dart';
import 'smart_entry_dialog.dart';

class TodayPage extends StatelessWidget {
  const TodayPage({super.key, required this.state, required this.onNavigate});

  final LifeState state;
  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);

    final tasks = state.data.entries
        .where((entry) => entry.isTask && sameDay(entry.due, now))
        .toList();

    final pending = tasks.where((entry) => !entry.done).length;

    final bills = state.data.entries
        .where((entry) => entry.kind == EntryKind.bill && !entry.done)
        .length;

    final docs = state.data.entries
        .where(
          (entry) =>
              entry.kind == EntryKind.document &&
              entry.due.isBefore(start.add(const Duration(days: 31))),
        )
        .length;

    final agenda = state.data.entries.where((entry) {
      if (entry.done) return false;

      if (entry.isTask) {
        return entry.due.isBefore(start.add(const Duration(days: 1)));
      }

      if (entry.kind == EntryKind.bill) {
        return entry.due.isBefore(start.add(const Duration(days: 8)));
      }

      if (entry.kind == EntryKind.document) {
        return entry.due.isBefore(start.add(const Duration(days: 31)));
      }

      return false;
    }).toList()..sort((a, b) => a.due.compareTo(b.due));

    return PageBody(
      children: [
        Text(
          '${tr(context, 'today')} · ${dateText(now)}',
          style: const TextStyle(color: muted, fontSize: 12),
        ),
        const SizedBox(height: 8),
        PageHeading(tr(context, 'greeting'), tr(context, 'subtitle')),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              colors: [Color(0xFF184D40), Color(0xFF2E755C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.wb_sunny_outlined,
                    color: Color(0xFFD5E6AE),
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    tr(context, 'overview'),
                    style: const TextStyle(
                      color: Color(0xFFD5E6AE),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                tr(context, 'focus'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                tr(context, 'focusSub'),
                style: const TextStyle(
                  color: Color(0xFFD2E0D8),
                  height: 1.8,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: tasks.isEmpty
                            ? 0
                            : (tasks.length - pending) / tasks.length,
                        minHeight: 7,
                        backgroundColor: Colors.white24,
                        color: const Color(0xFFCCE3A4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    '${tasks.length - pending}/${tasks.length}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                tr(context, 'completed'),
                style: const TextStyle(color: Color(0xFFD2E0D8), fontSize: 11),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _stat(
                context,
                '$pending',
                'pending',
                Icons.check_circle_outline,
                brand,
                () => onNavigate(1),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _stat(
                context,
                '$bills',
                'bills',
                Icons.receipt_long_outlined,
                amber,
                () => onNavigate(2),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _stat(
                context,
                '$docs',
                'expiring',
                Icons.folder_outlined,
                const Color(0xFF5B8B97),
                () => onNavigate(3),
              ),
            ),
          ],
        ),
        SectionTitle(tr(context, 'quick')),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _quick(context, 'newTask', Icons.add_task, EntryKind.task),
            _quick(
              context,
              'newExpense',
              Icons.wallet_outlined,
              EntryKind.expense,
            ),
            _quick(
              context,
              'newDocument',
              Icons.note_add_outlined,
              EntryKind.document,
            ),
          ],
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => showSmartEntryDialog(context),
          icon: const Icon(Icons.auto_awesome_outlined, size: 18),
          label: Text(tr(context, 'smart')),
        ),
        SectionTitle(
          tr(context, 'schedule'),
          action: tr(context, 'viewAll'),
          onTap: () => onNavigate(1),
        ),
        if (agenda.isEmpty)
          const EmptyView()
        else
          Surface(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              children: [
                for (final entry in agenda.take(6)) EntryTile(entry: entry),
              ],
            ),
          ),
        InfoNote(tr(context, 'demoInfo')),
      ],
    );
  }

  Widget _quick(
    BuildContext context,
    String key,
    IconData icon,
    EntryKind kind,
  ) {
    return ActionChip(
      avatar: Icon(icon, size: 18, color: brand),
      label: Text(tr(context, key)),
      backgroundColor: Colors.white,
      side: const BorderSide(color: Color(0xFFE3E9DD)),
      padding: const EdgeInsets.all(8),
      onPressed: () => openEntryForm(context, kind: kind),
    );
  }

  Widget _stat(
    BuildContext context,
    String value,
    String key,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Surface(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w800),
            ),
            Text(
              tr(context, key),
              style: const TextStyle(fontSize: 10, color: muted),
            ),
          ],
        ),
      ),
    );
  }
}
