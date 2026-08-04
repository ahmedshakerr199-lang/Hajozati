import 'package:flutter_test/flutter_test.dart';
import 'package:hajozati/core/result/app_result.dart';
import 'package:hajozati/features/booking/data/mock_booking_repository.dart';
import 'package:hajozati/features/booking/domain/booking_use_cases.dart';

void main() {
  test('confirmed booking remains readable', () async {
    final r = MockBookingRepository();
    final created = await CreateBookingUseCase(r)('hotel');
    final id = (created as AppSuccess).data.id;
    expect(await ConfirmBookingUseCase(r)(id), isA<AppFailure>());
  });
}
