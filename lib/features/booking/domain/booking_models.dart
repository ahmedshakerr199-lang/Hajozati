import '../../hotels/domain/entities/hotel.dart';

enum BookingStatus { draft, confirmed, cancelled }

class BookingGuest {
  const BookingGuest({required this.adults, this.children = 0});
  final int adults, children;
  int get total => adults + children;
}

class BookingRoom {
  const BookingRoom({required this.roomType, required this.quantity});
  final RoomType roomType;
  final int quantity;
}

class BookingPrice {
  const BookingPrice(
      {required this.subtotal, required this.taxes, required this.discount});
  final int subtotal, taxes, discount;
  int get total => subtotal + taxes - discount;
}

class Booking {
  const Booking(
      {required this.id,
      required this.hotelId,
      required this.checkIn,
      required this.checkOut,
      required this.guests,
      required this.rooms,
      required this.status,
      this.number});
  final String id, hotelId;
  final DateTime checkIn, checkOut;
  final BookingGuest guests;
  final List<BookingRoom> rooms;
  final BookingStatus status;
  final String? number;
  int get nights => checkOut.difference(checkIn).inDays;
}

class BookingSummary {
  const BookingSummary(this.booking, this.price);
  final Booking booking;
  final BookingPrice price;
}
