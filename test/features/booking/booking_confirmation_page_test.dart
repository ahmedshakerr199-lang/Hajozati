import 'package:flutter_test/flutter_test.dart';
import 'package:hajozati/features/booking/presentation/booking_confirmation_page.dart';

void main() {
  test(
      'confirmation page uses only a booking id',
      () => expect(
          const BookingConfirmationPage(bookingId: 'id').bookingId, 'id'));
}
