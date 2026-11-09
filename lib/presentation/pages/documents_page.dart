import 'package:flutter/material.dart';

import '../../bloc/life_bloc.dart';
import '../../core/design.dart';
import '../../domain/models.dart';
import '../widgets/common_widgets.dart';
import 'entry_detail_sheet.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key, required this.state});

  final LifeState state;

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final entries =
        widget.state.data.entries
            .where(
              (entry) =>
                  entry.kind == EntryKind.document &&
                  entry.title.toLowerCase().contains(query.toLowerCase()),
            )
            .toList()
          ..sort((a, b) => a.due.compareTo(b.due));

    return PageBody(
      children: [
        PageHeading(tr(context, 'documents'), tr(context, 'documentSub')),
        TextField(
          onChanged: (value) => setState(() => query = value),
          decoration: InputDecoration(
            hintText: tr(context, 'search'),
            prefixIcon: const Icon(Icons.search_rounded),
          ),
        ),
        InfoNote(tr(context, 'attachInfo')),
        if (entries.isEmpty)
          const EmptyView(kind: EntryKind.document)
        else
          for (final entry in entries)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Surface(
                child: InkWell(
                  onTap: () => showEntryDetails(context, entry),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F0F1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.description_outlined,
                              color: Color(0xFF5B8B97),
                            ),
                          ),
                          const Spacer(),
                          Chip(
                            label: Text(
                              tr(context, entry.shared ? 'shared' : 'private'),
                              style: const TextStyle(fontSize: 11),
                            ),
                            side: BorderSide.none,
                            backgroundColor: canvas,
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        entry.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${tr(context, 'expiry')} ${dateText(entry.due)}',
                        style: const TextStyle(color: muted, fontSize: 12),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        tr(context, 'noFile'),
                        style: const TextStyle(color: muted, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      ],
    );
  }
}
