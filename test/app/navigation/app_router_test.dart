import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hajozati/app/navigation/app_router.dart';
import 'package:hajozati/app/navigation/app_routes.dart';

void main() {
  testWidgets('unknown route renders a clear error page', (tester) async {
    await tester.pumpWidget(const MaterialApp(
        onGenerateRoute: AppRouter.onGenerateRoute, initialRoute: '/unknown'));
    expect(find.byType(Scaffold), findsOneWidget);
  });
  test('destination route accepts an id', () {
    final route = AppRouter.onGenerateRoute(const RouteSettings(
        name: AppRoutes.destinationDetails, arguments: 'ur-ziggurat'));
    expect(route, isA<MaterialPageRoute<dynamic>>());
  });
}
