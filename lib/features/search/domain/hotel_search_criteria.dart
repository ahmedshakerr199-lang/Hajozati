/// Immutable criteria selected in the main hotel search panel.
class HotelSearchCriteria {
  const HotelSearchCriteria(
      {this.provinceId,
      this.provinceName,
      this.checkIn,
      this.checkOut,
      this.adults = 1,
      this.children = 0,
      this.rooms = 1});
  final String? provinceId, provinceName;
  final DateTime? checkIn, checkOut;
  final int adults, children, rooms;
  int get nights => checkIn == null || checkOut == null
      ? 0
      : checkOut!.difference(checkIn!).inDays;
}
