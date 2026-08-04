import '../../../core/result/app_result.dart';
import '../domain/booking_models.dart';
import '../domain/booking_repository.dart';

class MockBookingRepository implements BookingRepository {
  final Map<String, Booking> _items = {};
  int _next = 1;
  @override
  Future<AppResult<Booking>> createDraftBooking(String hotelId) async {
    final now = DateTime.now();
    final b = Booking(
        id: 'draft-${_next++}',
        hotelId: hotelId,
        checkIn: now.add(const Duration(days: 1)),
        checkOut: now.add(const Duration(days: 2)),
        guests: const BookingGuest(adults: 1),
        rooms: const [],
        status: BookingStatus.draft);
    _items[b.id] = b;
    return AppSuccess(b);
  }

  @override
  Future<AppResult<Booking>> getBookingById(String id) async =>
      _items.containsKey(id)
          ? AppSuccess(_items[id]!)
          : const AppFailure(NotFoundAppError('الحجز غير موجود.'));
  @override
  Future<AppResult<Booking>> updateGuests(String id, BookingGuest g) async {
    if (g.total < 1) {
      return const AppFailure(
          ValidationAppError('يجب اختيار ضيف واحد على الأقل.'));
    }
    final b = await getBookingById(id);
    if (b is AppFailure<Booking>) return b;
    final v = (b as AppSuccess<Booking>).data;
    final n = Booking(
        id: v.id,
        hotelId: v.hotelId,
        checkIn: v.checkIn,
        checkOut: v.checkOut,
        guests: g,
        rooms: v.rooms,
        status: v.status);
    _items[id] = n;
    return AppSuccess(n);
  }

  @override
  Future<AppResult<Booking>> updateDates(
      String id, DateTime a, DateTime d) async {
    if (!d.isAfter(a)) {
      return const AppFailure(ValidationAppError('تاريخ المغادرة غير صالح.'));
    }
    final b = await getBookingById(id);
    if (b is AppFailure<Booking>) return b;
    final v = (b as AppSuccess<Booking>).data;
    final n = Booking(
        id: v.id,
        hotelId: v.hotelId,
        checkIn: a,
        checkOut: d,
        guests: v.guests,
        rooms: v.rooms,
        status: v.status);
    _items[id] = n;
    return AppSuccess(n);
  }

  @override
  Future<AppResult<Booking>> updateRooms(
      String id, List<BookingRoom> rooms) async {
    if (rooms.isEmpty ||
        rooms.any(
            (r) => r.quantity < 1 || r.quantity > r.roomType.availableRooms)) {
      return const AppFailure(ValidationAppError('الغرفة غير متوفرة.'));
    }
    final b = await getBookingById(id);
    if (b is AppFailure<Booking>) return b;
    final v = (b as AppSuccess<Booking>).data;
    final n = Booking(
        id: v.id,
        hotelId: v.hotelId,
        checkIn: v.checkIn,
        checkOut: v.checkOut,
        guests: v.guests,
        rooms: rooms,
        status: v.status);
    _items[id] = n;
    return AppSuccess(n);
  }

  @override
  Future<AppResult<BookingPrice>> calculatePrice(String id) async {
    final b = await getBookingById(id);
    if (b is AppFailure<Booking>) return AppFailure(b.error);
    final v = (b as AppSuccess<Booking>).data;
    final sub = v.rooms.fold(
        0, (x, r) => x + r.roomType.pricePerNight * r.quantity * v.nights);
    return AppSuccess(
        BookingPrice(subtotal: sub, taxes: (sub * .1).round(), discount: 0));
  }

  @override
  Future<AppResult<Booking>> confirmBooking(String id) async {
    final b = await getBookingById(id);
    if (b is AppFailure<Booking>) return b;
    final v = (b as AppSuccess<Booking>).data;
    if (v.rooms.isEmpty) {
      return const AppFailure(ValidationAppError('الحجز غير مكتمل.'));
    }
    final n = Booking(
        id: v.id,
        hotelId: v.hotelId,
        checkIn: v.checkIn,
        checkOut: v.checkOut,
        guests: v.guests,
        rooms: v.rooms,
        status: BookingStatus.confirmed,
        number: 'MOCK-${v.id}');
    _items[id] = n;
    return AppSuccess(n);
  }

  @override
  Future<AppResult<Booking>> cancelBooking(String id) async {
    final b = await getBookingById(id);
    if (b is AppFailure<Booking>) return b;
    final v = (b as AppSuccess<Booking>).data;
    final n = Booking(
        id: v.id,
        hotelId: v.hotelId,
        checkIn: v.checkIn,
        checkOut: v.checkOut,
        guests: v.guests,
        rooms: v.rooms,
        status: BookingStatus.cancelled,
        number: v.number);
    _items[id] = n;
    return AppSuccess(n);
  }
}
