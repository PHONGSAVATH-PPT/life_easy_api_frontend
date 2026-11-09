import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/life_bloc.dart';
import '../../core/design.dart';
import '../widgets/entry_tile.dart';

void showNotificationsSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) {
      return BlocBuilder<LifeBloc, LifeState>(
        bloc: context.read<LifeBloc>(),
        builder: (sheetContext, state) {
          final entries =
              state.data.entries
                  .where((entry) => entry.reminder && !entry.done)
                  .toList()
                ..sort((a, b) => a.due.compareTo(b.due));

          return SafeArea(
            child: SizedBox(
              height: MediaQuery.sizeOf(sheetContext).height * 0.65,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Text(
                    tr(sheetContext, 'notifications'),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  InfoNote(tr(sheetContext, 'notificationInfo')),
                  if (entries.isEmpty)
                    Text(tr(sheetContext, 'empty'))
                  else
                    for (final entry in entries) EntryTile(entry: entry),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
