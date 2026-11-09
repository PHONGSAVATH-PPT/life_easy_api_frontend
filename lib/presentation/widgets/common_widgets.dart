import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/life_bloc.dart';
import '../../core/design.dart';
import '../../domain/models.dart';
import '../pages/entry_form_page.dart';

// Widget สำหรับแสดงรายการ entry แต่ละรายการ
class PageBody extends StatelessWidget {
  const PageBody({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),

      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
        physics: const ClampingScrollPhysics(),
        children: children,
      ),
    );
  }
}

class PageHeading extends StatelessWidget {
  const PageHeading(this.title, this.subtitle, {super.key});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: 0,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: muted, fontSize: 13)),
        ],
      ),
    );
  }
}

class EmptyView extends StatelessWidget {
  const EmptyView({super.key, this.kind = EntryKind.task});

  final EntryKind kind;

  @override
  Widget build(BuildContext context) {
    context.watch<LifeBloc>();

    return Surface(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFEDF2E8),
                shape: BoxShape.circle,
              ),
              child: Icon(kindIcon(kind), size: 32, color: brand),
            ),
            const SizedBox(height: 16),
            Text(
              tr(context, 'empty'),
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              tr(context, 'emptySub'),
              textAlign: TextAlign.center,
              style: const TextStyle(color: muted),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () => openEntryForm(context, kind: kind),
              icon: const Icon(Icons.add),
              label: Text(tr(context, 'add')),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildFilters(
  BuildContext context,
  List<String> keys,
  int current,
  ValueChanged<int> change,
) {
  return Wrap(
    spacing: 8,
    runSpacing: 8,
    children: List.generate(
      keys.length,
      (index) => ChoiceChip(
        label: Text(tr(context, keys[index])),
        selected: index == current,
        showCheckmark: false,
        selectedColor: const Color(0xFFDDE9D2),
        side: BorderSide.none,
        onSelected: (_) => change(index),
      ),
    ),
  );
}

void showNotice(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}
