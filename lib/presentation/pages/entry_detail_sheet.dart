import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/life_bloc.dart';
import '../../core/design.dart';
import '../../domain/models.dart';
import 'entry_form_page.dart';

Future<void> showEntryDetails(BuildContext context, LifeEntry original) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) {
      return BlocBuilder<LifeBloc, LifeState>(
        bloc: context.read<LifeBloc>(),
        builder: (sheetContext, state) {
          final matches = state.data.entries.where(
            (entry) => entry.id == original.id,
          );

          if (matches.isEmpty) {
            return const SizedBox(height: 80);
          }

          final entry = matches.first;

          final readOnly =
              (entry.kind == EntryKind.bill && entry.done) ||
              entry.sourceBillId != null;

          final assigned = state.data.members.where(
            (member) => member.id == entry.assignee,
          );

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    kindIcon(entry.kind),
                    color: kindColor(entry.kind),
                    size: 36,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    entry.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    '${tr(sheetContext, entry.kind.name)} · '
                    '${dateText(entry.due)} · ${timeText(entry.due)}',
                  ),
                  if (entry.isMoney)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        money(entry.amount, entry.currency),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  Chip(
                    label: Text(
                      tr(sheetContext, entry.shared ? 'shared' : 'private'),
                    ),
                    avatar: Icon(
                      entry.shared ? Icons.people_outline : Icons.lock_outline,
                      size: 16,
                    ),
                  ),
                  if (assigned.isNotEmpty)
                    Text(
                      '${tr(sheetContext, 'assignee')}: '
                      '${assigned.first.name}',
                    ),
                  if (entry.note.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(entry.note),
                    ),
                  if (entry.kind == EntryKind.document)
                    InfoNote(tr(sheetContext, 'attachInfo')),
                  if (entry.recurrence != 'none')
                    InfoNote(
                      '${tr(sheetContext, entry.recurrence)} · '
                      '${tr(sheetContext, 'recurrenceInfo')}',
                    ),
                  if (entry.kind == EntryKind.bill && !entry.done)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: state.saving
                              ? null
                              : () {
                                  context.read<LifeBloc>().add(
                                    BillPaid(entry.id),
                                  );
                                },
                          icon: const Icon(Icons.check_rounded),
                          label: Text(tr(sheetContext, 'pay')),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  if (readOnly)
                    InfoNote(tr(sheetContext, 'readonlyPayment'))
                  else
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: state.saving
                                ? null
                                : () {
                                    Navigator.pop(sheetContext);
                                    openEntryForm(context, entry: entry);
                                  },
                            icon: const Icon(Icons.edit_outlined),
                            label: Text(tr(sheetContext, 'edit')),
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          tooltip: tr(sheetContext, 'delete'),
                          color: const Color(0xFFB45848),
                          onPressed: state.saving
                              ? null
                              : () async {
                                  final confirmed = await showDialog<bool>(
                                    context: sheetContext,
                                    builder: (dialogContext) {
                                      return AlertDialog(
                                        title: Text(
                                          tr(dialogContext, 'deleteAsk'),
                                        ),
                                        content: Text(entry.title),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(
                                                dialogContext,
                                                false,
                                              );
                                            },
                                            child: Text(
                                              tr(dialogContext, 'cancel'),
                                            ),
                                          ),
                                          FilledButton(
                                            onPressed: () {
                                              Navigator.pop(
                                                dialogContext,
                                                true,
                                              );
                                            },
                                            child: Text(
                                              tr(dialogContext, 'delete'),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (confirmed == true &&
                                      sheetContext.mounted &&
                                      context.mounted) {
                                    context.read<LifeBloc>().add(
                                      EntryRemoved(entry.id),
                                    );
                                    Navigator.pop(sheetContext);
                                  }
                                },
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
