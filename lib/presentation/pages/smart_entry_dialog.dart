import 'package:flutter/material.dart';

import '../../core/design.dart';
import '../../domain/models.dart';
import '../widgets/common_widgets.dart';
import 'entry_form_page.dart';

Future<void> showSmartEntryDialog(BuildContext context) async {
  final controller = TextEditingController();

  final raw = await showDialog<String>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(tr(dialogContext, 'smart')),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: tr(dialogContext, 'smartHint'),
                ),
              ),
              InfoNote(tr(dialogContext, 'smartInfo')),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(tr(dialogContext, 'cancel')),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext, controller.text);
            },
            child: Text(tr(dialogContext, 'preview')),
          ),
        ],
      );
    },
  );

  // รอ dialog ปิด animation ก่อน dispose controller
  Future<void>.delayed(const Duration(milliseconds: 400), controller.dispose);

  if (!context.mounted || raw == null) return;

  final pattern = RegExp(
    r'^(?:จ่าย|ຈ່າຍ)\s*(.+?)\s+([\d,]+)\s*'
    r'(?:กีบ|ກີບ)\s*(?:ทุกวันที่|ທຸກວັນທີ)\s*(\d{1,2})\s*$',
  );

  final match = pattern.firstMatch(raw.trim());

  if (match == null) {
    showNotice(context, tr(context, 'smartError'));
    return;
  }

  final day = int.parse(match.group(3)!);
  final amount = int.tryParse(match.group(2)!.replaceAll(',', '')) ?? 0;

  if (day < 1 || day > 28 || amount <= 0) {
    showNotice(context, tr(context, 'smartError'));
    return;
  }

  final now = DateTime.now();
  var due = DateTime(now.year, now.month, day);
  final today = DateTime(now.year, now.month, now.day);

  if (due.isBefore(today)) {
    due = DateTime(now.year, now.month + 1, day);
  }

  openEntryForm(
    context,
    isNew: true,
    entry: LifeEntry(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      kind: EntryKind.bill,
      title: match.group(1)!.trim(),
      due: due,
      amount: amount,
      recurrence: 'monthly',
    ),
  );
}
