import '../../../core/result/app_result.dart';
import '../domain/booking_models.dart';
import '../domain/booking_use_cases.dart';
import 'booking_view_model.dart';

/// Session-scoped owner of booking drafts and their single ViewModel instances.
class BookingFlowCoordinator {
  BookingFlowCoordinator(this._create, this._get, this._cancel, this._factory);
  final CreateBookingUseCase _create;
  final GetBookingUseCase _get;
  final CancelBookingUseCase _cancel;
  final BookingViewModel Function() _factory;
  final Map<String, BookingViewModel> _flows = {};
  String? activeBookingId;

  Future<AppResult<BookingViewModel>> createDraftForHotel(
      String hotelId) async {
    if (hotelId.trim().isEmpty) {
      return const AppFailure(ValidationAppError('معرف الفندق مطلوب.'));
    }
    final result = await _create(hotelId);
    if (result is AppFailure<Booking>) return AppFailure(result.error);
    final booking = (result as AppSuccess<Booking>).data;
    final vm = _factory();
    await vm.loadBooking(booking.id);
    _flows[booking.id] = vm;
    activeBookingId = booking.id;
    return AppSuccess(vm);
  }

  Future<AppResult<BookingViewModel>> getOrCreateBookingViewModel(
      String bookingId) async {
    if (bookingId.trim().isEmpty) {
      return const AppFailure(ValidationAppError('معرف الحجز مطلوب.'));
    }
    final existing = _flows[bookingId];
    if (existing != null) return AppSuccess(existing);
    final result = await _get(bookingId);
    if (result is AppFailure<Booking>) return AppFailure(result.error);
    if ((result as AppSuccess<Booking>).data.status != BookingStatus.draft) {
      return const AppFailure(ValidationAppError('الحجز ليس مسودة نشطة.'));
    }
    final vm = _factory();
    await vm.loadBooking(bookingId);
    _flows[bookingId] = vm;
    activeBookingId = bookingId;
    return AppSuccess(vm);
  }

  Future<AppResult<void>> releaseBookingFlow(String bookingId,
      {bool cancel = false}) async {
    final vm = _flows.remove(bookingId);
    if (cancel) {
      final result = await _cancel(bookingId);
      if (result is AppFailure<Booking>) return AppFailure(result.error);
    }
    vm?.dispose();
    if (activeBookingId == bookingId) activeBookingId = null;
    return const AppSuccess(null);
  }
}
