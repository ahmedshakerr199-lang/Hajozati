import 'package:flutter/foundation.dart';
import '../../../core/result/app_result.dart';
import '../domain/booking_models.dart';
import '../domain/booking_use_cases.dart';

enum BookingConfirmationState {
  initial,
  loading,
  success,
  notFound,
  invalidStatus,
  error
}

class BookingConfirmationViewModel extends ChangeNotifier {
  BookingConfirmationViewModel(this._get, this.bookingId);
  final GetBookingUseCase _get;
  final String bookingId;
  BookingConfirmationState state = BookingConfirmationState.initial;
  Booking? confirmedBooking;
  String? error;
  Future<void> load() async {
    state = BookingConfirmationState.loading;
    notifyListeners();
    if (bookingId.trim().isEmpty) {
      state = BookingConfirmationState.notFound;
      notifyListeners();
      return;
    }
    final result = await _get(bookingId);
    if (result is AppFailure<Booking>) {
      state = result.error is NotFoundAppError
          ? BookingConfirmationState.notFound
          : BookingConfirmationState.error;
      error = result.error.message;
    } else {
      final booking = (result as AppSuccess<Booking>).data;
      if (booking.status != BookingStatus.confirmed) {
        state = BookingConfirmationState.invalidStatus;
      } else {
        confirmedBooking = booking;
        state = BookingConfirmationState.success;
      }
    }
    notifyListeners();
  }
}
