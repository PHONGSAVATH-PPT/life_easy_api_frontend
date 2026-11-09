import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/life_bloc.dart';
import '../../core/design.dart';

void showSettingsSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) {
      return BlocBuilder<LifeBloc, LifeState>(
        bloc: context.read<LifeBloc>(),
        builder: (sheetContext, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr(sheetContext, 'settings'),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: state.language,
                    decoration: InputDecoration(
                      labelText: tr(sheetContext, 'language'),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'th', child: Text('ไทย')),
                      DropdownMenuItem(value: 'lo', child: Text('ລາວ')),
                      DropdownMenuItem(value: 'en', child: Text('English')),
                      DropdownMenuItem(value: 'zh', child: Text('中文')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        context.read<LifeBloc>().add(LanguageChanged(value));
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: state.currency,
                    decoration: InputDecoration(
                      labelText: tr(sheetContext, 'currency'),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'LAK', child: Text('LAK · ກີບ')),
                      DropdownMenuItem(value: 'THB', child: Text('THB · บาท')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        context.read<LifeBloc>().add(CurrencyChanged(value));
                      }
                    },
                  ),
                  InfoNote(tr(sheetContext, 'demoInfo')),
                  Text(
                    tr(sheetContext, 'prototype'),
                    style: const TextStyle(fontSize: 12, color: muted),
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
