import 'package:flutter_test/flutter_test.dart';
import 'package:hajozati/features/booking/data/mock_booking_repository.dart';
import 'package:hajozati/features/booking/domain/booking_use_cases.dart';
import 'package:hajozati/features/booking/presentation/booking_view_model.dart';

void main() {
  test('initializes a draft booking', () async {
    final r = MockBookingRepository();
    final vm = BookingViewModel(
        CreateBookingUseCase(r),
        GetBookingUseCase(r),
        UpdateBookingGuestsUseCase(r),
        UpdateBookingDatesUseCase(r),
        UpdateBookingRoomsUseCase(r),
        CalculateBookingPriceUseCase(r),
        ConfirmBookingUseCase(r),
        CancelBookingUseCase(r),
        const ValidateBookingUseCase());
    await vm.initializeBooking('hotel-1');
    expect(vm.booking, isNotNull);
    expect(vm.state, BookingViewState.editing);
  });
}
