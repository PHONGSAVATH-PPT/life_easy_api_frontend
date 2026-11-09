import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'bloc/life_bloc.dart';
import 'core/design.dart';
import 'data/demo_life_repository.dart';
import 'domain/life_repository.dart';
import 'presentation/app_shell.dart';

void main() {
  const seedData = bool.fromEnvironment('DEMO_DATA');

  runApp(LifeEasyApp(repository: DemoLifeRepository(seedData: seedData)));
}

class LifeEasyApp extends StatelessWidget {
  const LifeEasyApp({super.key, required this.repository});

  final LifeRepository repository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<LifeRepository>.value(
      value: repository,
      child: BlocProvider(
        create: (_) => LifeBloc(repository)..add(LifeLoaded()),
        child: BlocBuilder<LifeBloc, LifeState>(
          buildWhen: (previous, current) =>
              previous.language != current.language,
          builder: (context, state) {
            return MaterialApp(
              title: 'Life Easy',
              debugShowCheckedModeBanner: false,
              theme: buildTheme(state.language),

              locale: Locale(state.language),
              supportedLocales: const [
                Locale('th'),
                Locale('lo'),
                Locale('en'),
                Locale('zh'),
              ],
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              home: const LifeShell(),
            );
          },
        ),
      ),
    );
  }
}
