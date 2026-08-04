import 'package:flutter_test/flutter_test.dart';
import 'package:hajozati/core/result/app_result.dart';
import 'package:hajozati/features/booking/data/mock_booking_repository.dart';

void main() {
  test('creates a draft and validates dates', () async {
    final r = MockBookingRepository();
    final b = await r.createDraftBooking('hotel-1');
    expect(b, isA<AppSuccess>());
    expect(
        await r.updateDates(
            (b as AppSuccess).data.id, DateTime(2027), DateTime(2027)),
        isA<AppFailure>());
  });
}
