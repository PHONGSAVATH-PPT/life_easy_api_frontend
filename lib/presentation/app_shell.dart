import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/life_bloc.dart';
import '../core/design.dart';
import '../domain/models.dart';
import 'pages/documents_page.dart';
import 'pages/entry_form_page.dart';
import 'pages/family_page.dart';
import 'pages/money_page.dart';
import 'pages/notifications_sheet.dart';
import 'pages/settings_sheet.dart';
import 'pages/tasks_page.dart';
import 'pages/today_page.dart';

class LifeShell extends StatefulWidget {
  const LifeShell({super.key});

  @override
  State<LifeShell> createState() => _LifeShellState();
}

class _LifeShellState extends State<LifeShell> {
  int tab = 0;

  static const keys = ['today', 'tasks', 'money', 'documents', 'family'];

  static const icons = [
    Icons.space_dashboard_outlined,
    Icons.check_circle_outline,
    Icons.account_balance_wallet_outlined,
    Icons.folder_outlined,
    Icons.people_outline,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LifeBloc, LifeState>(
      listenWhen: (previous, current) =>
          current.error != null && previous.error != current.error,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(state.error!)));
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 80,
            title: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: brand,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.spa_outlined,
                    color: Colors.white,
                    size: 23,
                  ),
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'life easy',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.8,
                      ),
                    ),
                    Text(
                      'A LITTLE MORE BALANCE',
                      style: TextStyle(
                        fontSize: 8,
                        letterSpacing: 1.3,
                        color: muted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                tooltip: tr(context, 'notifications'),
                onPressed: () => showNotificationsSheet(context),
                icon: const Icon(Icons.notifications_none_rounded),
              ),
              IconButton(
                tooltip: tr(context, 'settings'),
                onPressed: () => showSettingsSheet(context),
                icon: const CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFFE4EBD9),
                  child: Icon(
                    Icons.person_outline_rounded,
                    size: 22,
                    color: ink,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SafeArea(
            top: false,
            child: Column(
              children: [
                if (state.saving) const LinearProgressIndicator(minHeight: 2),
                Expanded(child: _body(context, state)),
              ],
            ),
          ),
          floatingActionButton: tab == 0
              ? null
              : FloatingActionButton(
                  tooltip: tr(context, 'add'),
                  backgroundColor: brand,
                  foregroundColor: Colors.white,
                  onPressed: state.saving
                      ? null
                      : () {
                          openEntryForm(
                            context,
                            kind: switch (tab) {
                              2 => EntryKind.expense,
                              3 => EntryKind.document,
                              _ => EntryKind.task,
                            },
                          );
                        },
                  child: const Icon(Icons.add_rounded),
                ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: tab,
            onDestinationSelected: (value) {
              setState(() => tab = value);
            },
            destinations: List.generate(
              keys.length,
              (index) => NavigationDestination(
                icon: Icon(icons[index]),
                label: tr(context, keys[index]),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _body(BuildContext context, LifeState state) {
    if (state.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.data.entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(tr(context, 'error')),
            TextButton(
              onPressed: () {
                context.read<LifeBloc>().add(LifeLoaded());
              },
              child: Text(tr(context, 'retry')),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        final bloc = context.read<LifeBloc>();
        final completed = bloc.stream.firstWhere(
          (value) => !value.loading && !value.saving,
        );

        bloc.add(LifeLoaded());
        await completed;
      },
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: IndexedStack(
            index: tab,
            children: [
              TodayPage(
                state: state,
                onNavigate: (value) => setState(() => tab = value),
              ),
              TasksPage(state: state),
              MoneyPage(state: state),
              DocumentsPage(state: state),
              FamilyPage(state: state),
            ],
          ),
        ),
      ),
    );
  }
}
