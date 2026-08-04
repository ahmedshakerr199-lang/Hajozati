import 'package:flutter_test/flutter_test.dart';
import 'package:hajozati/features/booking/data/mock_booking_repository.dart';
import 'package:hajozati/features/booking/domain/booking_use_cases.dart';
import 'package:hajozati/features/booking/presentation/booking_confirmation_view_model.dart';

void main() {
  test('empty id is not found', () async {
    final vm = BookingConfirmationViewModel(
        GetBookingUseCase(MockBookingRepository()), '')
      ..load();
    await Future<void>.delayed(Duration.zero);
    expect(vm.state, BookingConfirmationState.notFound);
  });
  test('missing booking is not found', () async {
    final vm = BookingConfirmationViewModel(
        GetBookingUseCase(MockBookingRepository()), 'missing');
    await vm.load();
    expect(vm.state, BookingConfirmationState.notFound);
  });
}
