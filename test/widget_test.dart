import 'package:flutter_test/flutter_test.dart';
import 'package:hajozati/main.dart';

void main() {
  testWidgets('app starts with Arabic splash screen', (tester) async {
    await tester.pumpWidget(const HajozatiApp());
    expect(find.text('حجوزاتي'), findsOneWidget);
  });
}
