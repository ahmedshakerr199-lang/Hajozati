import 'package:flutter/foundation.dart';
import '../../../core/result/app_result.dart';
import '../domain/booking_models.dart';
import '../domain/booking_use_cases.dart';

enum BookingViewState {
  initial,
  loading,
  editing,
  calculating,
  readyForConfirmation,
  confirming,
  confirmed,
  cancelled,
  validationError,
  error
}

class BookingViewModel extends ChangeNotifier {
  BookingViewModel(this._create, this._get, this._guests, this._dates,
      this._rooms, this._price, this._confirm, this._cancel, this._validate);
  final CreateBookingUseCase _create;
  final GetBookingUseCase _get;
  final UpdateBookingGuestsUseCase _guests;
  final UpdateBookingDatesUseCase _dates;
  final UpdateBookingRoomsUseCase _rooms;
  final CalculateBookingPriceUseCase _price;
  final ConfirmBookingUseCase _confirm;
  final CancelBookingUseCase _cancel;
  final ValidateBookingUseCase _validate;
  BookingViewState state = BookingViewState.initial;
  Booking? booking;
  BookingRoom? selectedRoom;
  BookingPrice? price;
  List<String> validationMessages = [];
  String? error;
  DateTime? get checkIn => booking?.checkIn;
  DateTime? get checkOut => booking?.checkOut;
  int get nights => booking?.nights ?? 0;
  int get adults => booking?.guests.adults ?? 0;
  int get children => booking?.guests.children ?? 0;
  int get rooms => booking == null
      ? 0
      : booking!.rooms.fold<int>(0, (total, room) => total + room.quantity);
  int get subtotal => price?.subtotal ?? 0;
  int get taxes => price?.taxes ?? 0;
  int get discount => price?.discount ?? 0;
  int get grandTotal {
    final total = price?.total ?? 0;
    return total < 0 ? 0 : total;
  }

  Future<void> initializeBooking(String hotelId) async {
    state = BookingViewState.loading;
    notifyListeners();
    _applyBooking(await _create(hotelId));
  }

  Future<void> loadBooking(String id) async {
    state = BookingViewState.loading;
    notifyListeners();
    _applyBooking(await _get(id));
  }

  Future<void> selectRoom(BookingRoom room) async {
    selectedRoom = room;
    await updateRooms([room]);
  }

  Future<void> updateDates(DateTime a, DateTime d) async {
    if (booking == null) return;
    _applyBooking(await _dates(booking!.id, a, d));
  }

  Future<void> updateGuests(int a, int c) async {
    if (booking == null) return;
    _applyBooking(
        await _guests(booking!.id, BookingGuest(adults: a, children: c)));
  }

  Future<void> updateRooms(List<BookingRoom> rooms) async {
    if (booking == null) return;
    _applyBooking(await _rooms(booking!.id, rooms));
  }

  Future<void> calculatePrice() async {
    if (booking == null) return;
    state = BookingViewState.calculating;
    notifyListeners();
    final result = await _price(booking!.id);
    if (result is AppSuccess<BookingPrice>) {
      price = result.data;
      state = BookingViewState.editing;
    } else {
      _failure((result as AppFailure).error);
    }
    notifyListeners();
  }

  Future<void> validateBooking() async {
    if (booking == null) return;
    final result = _validate(booking!);
    if (result is AppFailure) {
      validationMessages = [result.error.message];
      state = BookingViewState.validationError;
    } else {
      validationMessages = [];
      state = BookingViewState.readyForConfirmation;
    }
    notifyListeners();
  }

  Future<void> confirmBooking() async {
    if (booking == null) return;
    await validateBooking();
    if (state != BookingViewState.readyForConfirmation) return;
    state = BookingViewState.confirming;
    notifyListeners();
    _applyBooking(await _confirm(booking!.id), confirmed: true);
  }

  Future<void> cancelBooking() async {
    if (booking == null) return;
    _applyBooking(await _cancel(booking!.id), cancelled: true);
  }

  Future<void> retry() async {
    if (booking == null) return;
    await loadBooking(booking!.id);
  }

  void _applyBooking(AppResult<Booking> result,
      {bool confirmed = false, bool cancelled = false}) {
    if (result is AppSuccess<Booking>) {
      booking = result.data;
      state = confirmed
          ? BookingViewState.confirmed
          : cancelled
              ? BookingViewState.cancelled
              : BookingViewState.editing;
    } else {
      _failure((result as AppFailure).error);
    }
    notifyListeners();
  }

  void _failure(AppError value) {
    error = value.message;
    state = value is ValidationAppError
        ? BookingViewState.validationError
        : BookingViewState.error;
  }
}
