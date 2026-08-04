import '../core/location/geolocator_location_service.dart';
import '../core/location/location_service.dart';
import '../features/explore/data/repositories/mock_explore_repository.dart';
import '../features/explore/domain/repositories/explore_iraq_repository.dart';
import '../features/hotels/data/repositories/mock_hotel_repository.dart';
import '../features/hotels/domain/repositories/hotel_repository.dart';
import '../features/booking/data/mock_booking_repository.dart';
import '../features/booking/domain/booking_repository.dart';
import '../features/booking/domain/booking_use_cases.dart';
import '../features/booking/presentation/booking_flow_coordinator.dart';
import '../features/booking/presentation/booking_view_model.dart';
import '../features/booking/presentation/booking_confirmation_view_model.dart';
import '../features/search/data/mock_search_repository.dart';
import '../features/search/domain/search_repository.dart';

/// Composition root. Widgets receive view models or route ids, never mock data sources.
class AppDependencies {
  AppDependencies._();

  static final HotelRepository hotels = MockHotelRepository();
  static final ExploreIraqRepository explore = MockExploreRepository(hotels);
  static final LocationService location = GeolocatorLocationService();
  static final SearchRepository search = MockSearchRepository(hotels);
  static final BookingRepository bookings = MockBookingRepository();
  static BookingViewModel createBookingViewModel() => BookingViewModel(
      CreateBookingUseCase(bookings),
      GetBookingUseCase(bookings),
      UpdateBookingGuestsUseCase(bookings),
      UpdateBookingDatesUseCase(bookings),
      UpdateBookingRoomsUseCase(bookings),
      CalculateBookingPriceUseCase(bookings),
      ConfirmBookingUseCase(bookings),
      CancelBookingUseCase(bookings),
      const ValidateBookingUseCase());
  static final BookingFlowCoordinator bookingFlow = BookingFlowCoordinator(
      CreateBookingUseCase(bookings),
      GetBookingUseCase(bookings),
      CancelBookingUseCase(bookings),
      createBookingViewModel);
  static BookingConfirmationViewModel createBookingConfirmationViewModel(
          String bookingId) =>
      BookingConfirmationViewModel(GetBookingUseCase(bookings), bookingId);
}
