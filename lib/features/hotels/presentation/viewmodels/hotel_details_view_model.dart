import 'package:flutter/foundation.dart';
import '../../domain/entities/hotel.dart';
import '../../domain/repositories/hotel_repository.dart';

sealed class HotelDetailsState {
  const HotelDetailsState();
}

class HotelDetailsLoading extends HotelDetailsState {
  const HotelDetailsLoading();
}

class HotelDetailsEmpty extends HotelDetailsState {
  const HotelDetailsEmpty();
}

class HotelDetailsError extends HotelDetailsState {
  const HotelDetailsError(this.message);
  final String message;
}

class HotelDetailsSuccess extends HotelDetailsState {
  const HotelDetailsSuccess(this.hotel, this.similar);
  final Hotel hotel;
  final List<Hotel> similar;
}

class HotelDetailsViewModel extends ChangeNotifier {
  HotelDetailsViewModel(this._repository, this.hotelId);
  final HotelRepository _repository;
  final String hotelId;
  HotelDetailsState state = const HotelDetailsLoading();
  Future<void> load() async {
    state = const HotelDetailsLoading();
    notifyListeners();
    try {
      final hotel = await _repository.getHotelById(hotelId);
      if (hotel == null) {
        state = const HotelDetailsEmpty();
      } else {
        state = HotelDetailsSuccess(
            hotel, await _repository.getSimilarHotels(hotelId));
      }
    } catch (_) {
      state = const HotelDetailsError('تعذر تحميل تفاصيل الفندق');
    }
    notifyListeners();
  }

  Future<void> toggleFavorite() async {
    if (state is! HotelDetailsSuccess) return;
    final value = state as HotelDetailsSuccess;
    await _repository.setFavorite(hotelId, !value.hotel.isFavorite);
    await load();
  }
}
