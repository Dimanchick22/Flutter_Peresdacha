import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:planner_plus/features/tasks/presentation/providers/theme_provider.dart';
import 'package:planner_plus/core/navigation/app_router.dart';
import 'package:planner_plus/core/theme/app_theme.dart';

class MockThemeNotifier extends ThemeNotifier {
  MockThemeNotifier() : super() {
    state = ThemeMode.system;
  }

  @override
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
  }
}

void main() {
  setUpAll(() async {
    final tempDir = Directory.systemTemp.createTempSync('hive_test_');
    Hive.init(tempDir.path);
  });

  tearDownAll(() async {
    await Hive.close();
  });

  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          themeProvider.overrideWith((ref) => MockThemeNotifier()),
        ],
        child: MaterialApp.router(
          title: 'Planner+',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          routerConfig: AppRouter.router,
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Planner+'), findsOneWidget);
  });
}