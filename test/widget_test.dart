import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_easy_application/data/demo_life_repository.dart';
import 'package:life_easy_application/main.dart';

void main() {
  testWidgets('App opens with five navigation destinations', (tester) async {
    await tester.pumpWidget(
      LifeEasyApp(repository: DemoLifeRepository(delay: Duration.zero)),
    );

    await tester.pumpAndSettle();

    expect(find.text('life easy'), findsOneWidget);
    expect(find.byType(NavigationDestination), findsNWidgets(5));
    expect(tester.takeException(), isNull);
  });
}
