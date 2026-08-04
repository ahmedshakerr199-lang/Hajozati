import '../../../core/result/app_result.dart';
import 'booking_models.dart';
import 'booking_repository.dart';

class CreateBookingUseCase {
  const CreateBookingUseCase(this.r);
  final BookingRepository r;
  Future<AppResult<Booking>> call(String id) => r.createDraftBooking(id);
}

class GetBookingUseCase {
  const GetBookingUseCase(this.r);
  final BookingRepository r;
  Future<AppResult<Booking>> call(String id) => r.getBookingById(id);
}

class UpdateBookingGuestsUseCase {
  const UpdateBookingGuestsUseCase(this.r);
  final BookingRepository r;
  Future<AppResult<Booking>> call(String id, BookingGuest g) =>
      r.updateGuests(id, g);
}

class UpdateBookingDatesUseCase {
  const UpdateBookingDatesUseCase(this.r);
  final BookingRepository r;
  Future<AppResult<Booking>> call(String id, DateTime a, DateTime d) =>
      r.updateDates(id, a, d);
}

class UpdateBookingRoomsUseCase {
  const UpdateBookingRoomsUseCase(this.r);
  final BookingRepository r;
  Future<AppResult<Booking>> call(String id, List<BookingRoom> rooms) =>
      r.updateRooms(id, rooms);
}

class CalculateBookingPriceUseCase {
  const CalculateBookingPriceUseCase(this.r);
  final BookingRepository r;
  Future<AppResult<BookingPrice>> call(String id) => r.calculatePrice(id);
}

class ConfirmBookingUseCase {
  const ConfirmBookingUseCase(this.r);
  final BookingRepository r;
  Future<AppResult<Booking>> call(String id) => r.confirmBooking(id);
}

class CancelBookingUseCase {
  const CancelBookingUseCase(this.r);
  final BookingRepository r;
  Future<AppResult<Booking>> call(String id) => r.cancelBooking(id);
}

class ValidateBookingUseCase {
  const ValidateBookingUseCase();
  AppResult<void> call(Booking b) {
    if (b.nights < 1 || b.guests.total < 1 || b.rooms.isEmpty) {
      return const AppFailure(ValidationAppError('بيانات الحجز غير مكتملة.'));
    }
    return const AppSuccess(null);
  }
}
