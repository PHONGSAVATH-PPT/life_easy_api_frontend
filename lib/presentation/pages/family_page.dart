import 'package:flutter/material.dart';

import '../../bloc/life_bloc.dart';
import '../../core/design.dart';
import '../widgets/common_widgets.dart';
import '../widgets/entry_tile.dart';

class FamilyPage extends StatelessWidget {
  const FamilyPage({super.key, required this.state});

  final LifeState state;

  @override
  Widget build(BuildContext context) {
    final entries = state.data.entries.where((entry) => entry.shared).toList();

    return PageBody(
      children: [
        PageHeading(tr(context, 'family'), tr(context, 'familySub')),
        Surface(
          color: const Color(0xFFEBE8DC),
          child: Row(
            children: [
              const Icon(Icons.cottage_outlined, size: 46, color: brand),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr(context, 'house'),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      tr(context, 'houseSub'),
                      style: const TextStyle(fontSize: 12, color: muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SectionTitle(
          '${tr(context, 'members')} · ${state.data.members.length}',
        ),
        Surface(
          child: Column(
            children: [
              for (final member in state.data.members)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: member.role == 'owner'
                        ? const Color(0xFFDCE7D1)
                        : const Color(0xFFF4E8D7),
                    child: Text(
                      member.name.isEmpty ? '?' : member.name.substring(0, 1),
                      style: const TextStyle(color: ink),
                    ),
                  ),
                  title: Text(member.name),
                  subtitle: Text(
                    tr(context, member.role),
                    style: const TextStyle(fontSize: 12, color: muted),
                  ),
                  trailing: const Icon(
                    Icons.verified_user_outlined,
                    color: muted,
                    size: 18,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () {
            showNotice(context, tr(context, 'inviteInfo'));
          },
          icon: const Icon(Icons.person_add_alt),
          label: Text(tr(context, 'invite')),
        ),
        SectionTitle(tr(context, 'sharedItems')),
        if (entries.isEmpty)
          Surface(child: Center(child: Text(tr(context, 'noShared'))))
        else
          Surface(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              children: [for (final entry in entries) EntryTile(entry: entry)],
            ),
          ),
        InfoNote(tr(context, 'shareSub')),
      ],
    );
  }
}
