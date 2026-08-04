import 'package:hajozati/features/booking/data/mock_booking_repository.dart';
import 'package:hajozati/features/booking/domain/booking_use_cases.dart';
import 'package:hajozati/features/booking/presentation/booking_view_model.dart';

BookingViewModel createBookingViewModel() {
  final r = MockBookingRepository();
  return BookingViewModel(
      CreateBookingUseCase(r),
      GetBookingUseCase(r),
      UpdateBookingGuestsUseCase(r),
      UpdateBookingDatesUseCase(r),
      UpdateBookingRoomsUseCase(r),
      CalculateBookingPriceUseCase(r),
      ConfirmBookingUseCase(r),
      CancelBookingUseCase(r),
      const ValidateBookingUseCase());
}
