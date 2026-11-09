import 'package:flutter/material.dart';

import '../../bloc/life_bloc.dart';
import '../../core/design.dart';
import '../widgets/common_widgets.dart';
import '../widgets/entry_tile.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key, required this.state});

  final LifeState state;

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  int filter = 0;

  @override
  Widget build(BuildContext context) {
    final entries = widget.state.data.entries.where((entry) {
      if (!entry.isTask) return false;
      if (filter == 1) return !entry.done;
      if (filter == 2) return entry.done;
      return true;
    }).toList()..sort((a, b) => a.due.compareTo(b.due));

    return PageBody(
      children: [
        PageHeading(tr(context, 'tasks'), tr(context, 'taskSub')),
        buildFilters(
          context,
          ['all', 'open', 'done'],
          filter,
          (value) => setState(() => filter = value),
        ),
        const SizedBox(height: 20),
        if (entries.isEmpty)
          const EmptyView()
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
}
