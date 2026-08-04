import '../../../core/result/app_result.dart';
import 'booking_models.dart';

abstract interface class BookingRepository {
  Future<AppResult<Booking>> createDraftBooking(String hotelId);
  Future<AppResult<Booking>> getBookingById(String id);
  Future<AppResult<Booking>> updateGuests(String id, BookingGuest guests);
  Future<AppResult<Booking>> updateDates(
      String id, DateTime checkIn, DateTime checkOut);
  Future<AppResult<Booking>> updateRooms(String id, List<BookingRoom> rooms);
  Future<AppResult<BookingPrice>> calculatePrice(String id);
  Future<AppResult<Booking>> confirmBooking(String id);
  Future<AppResult<Booking>> cancelBooking(String id);
}
