import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/repositories/hotel_repository.dart';
import '../viewmodels/hotel_details_view_model.dart';

class HotelDetailsPage extends StatefulWidget {
  const HotelDetailsPage(
      {super.key, required this.hotelId, required this.repository});
  final String hotelId;
  final HotelRepository repository;
  @override
  State<HotelDetailsPage> createState() => _HotelDetailsPageState();
}

class _HotelDetailsPageState extends State<HotelDetailsPage> {
  late final HotelDetailsViewModel vm;
  @override
  void initState() {
    super.initState();
    vm = HotelDetailsViewModel(widget.repository, widget.hotelId)..load();
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: vm,
        builder: (_, __) => Scaffold(
            appBar: AppBar(title: const Text('تفاصيل الفندق')), body: _body()),
      );
  Widget _body() {
    final state = vm.state;
    if (state is HotelDetailsLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is HotelDetailsEmpty) {
      return const Center(child: Text('الفندق غير موجود'));
    }
    if (state is HotelDetailsError) return Center(child: Text(state.message));
    final success = state as HotelDetailsSuccess;
    final hotel = success.hotel;
    return ListView(padding: const EdgeInsets.all(16), children: [
      AspectRatio(
          aspectRatio: 1.7,
          child: Image.network(hotel.coverImageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const ColoredBox(color: AppColors.primary))),
      const SizedBox(height: 12),
      Text(hotel.nameAr, style: Theme.of(context).textTheme.headlineSmall),
      Text('${hotel.province.nameAr} · ${hotel.rating.toStringAsFixed(1)} ★'),
      Text('${hotel.minimumPricePerNight ~/ 1000} ألف د.ع / ليلة'),
      const SizedBox(height: 12),
      Text(hotel.descriptionAr),
      Wrap(
          spacing: 8,
          children: hotel.amenities
              .map((item) => Chip(label: Text(item.name)))
              .toList()),
      if (success.similar.isNotEmpty) ...[
        const SizedBox(height: 20),
        const Text('فنادق مشابهة'),
        ...success.similar.map((item) => ListTile(
            title: Text(item.nameAr), subtitle: Text(item.province.nameAr)))
      ],
    ]);
  }
}
