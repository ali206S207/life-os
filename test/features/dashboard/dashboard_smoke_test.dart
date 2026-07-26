import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_os/features/dashboard/presentation/screens/dashboard_screen.dart';

void main() {
  testWidgets('DashboardScreen renders greeting and progress ring', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: DashboardScreen(userName: 'Ali')),
      ),
    );

    // Initial frame shows the loading state before the repository resolves.
    await tester.pump();
    expect(find.textContaining('Ali'), findsOneWidget);

    // Let the simulated repository delay resolve.
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Workout'), findsOneWidget);
  });
}
