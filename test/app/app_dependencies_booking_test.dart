import 'package:flutter_test/flutter_test.dart';
import 'package:hajozati/app/app_dependencies.dart';

void main() {
  test(
      'composition root exposes one booking coordinator',
      () => expect(
          identical(AppDependencies.bookingFlow, AppDependencies.bookingFlow),
          isTrue));
}
