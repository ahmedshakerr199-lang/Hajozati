import 'package:flutter/material.dart';
import '../../../../app/app_dependencies.dart';
import '../../../../app/navigation/app_routes.dart';
import '../../domain/nearby_hotels.dart';
import '../viewmodels/nearby_hotels_view_model.dart';

class NearbyHotelsPage extends StatefulWidget {
  const NearbyHotelsPage({super.key});
  @override
  State<NearbyHotelsPage> createState() => _NearbyHotelsPageState();
}

class _NearbyHotelsPageState extends State<NearbyHotelsPage> {
  late final NearbyHotelsViewModel vm;
  @override
  void initState() {
    super.initState();
    vm = NearbyHotelsViewModel(
        AppDependencies.location,
        GetNearbyHotelsUseCase(
            AppDependencies.hotels, CalculateDistanceUseCase()))
      ..load();
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
          appBar: AppBar(title: const Text('فنادق قريبة منك'), actions: [
            IconButton(onPressed: vm.load, icon: const Icon(Icons.my_location))
          ]),
          body: switch (vm.state) {
            NearbyViewState.loading =>
              const Center(child: CircularProgressIndicator()),
            NearbyViewState.success => _list(),
            NearbyViewState.permissionDenied => _action(
                'نحتاج إذن الموقع لعرض الفنادق القريبة.',
                'السماح بالموقع',
                vm.requestPermission),
            NearbyViewState.permanentlyDenied => _action(
                'تم رفض إذن الموقع بشكل دائم.',
                'فتح إعدادات التطبيق',
                vm.openSettings),
            NearbyViewState.serviceDisabled => _action('خدمة الموقع متوقفة.',
                'فتح الإعدادات', vm.openLocationSettings),
            NearbyViewState.locationUnavailable =>
              _action('تعذر تحديد الموقع.', 'إعادة المحاولة', vm.load),
            NearbyViewState.error =>
              _action(vm.message ?? 'تعذر التحميل.', 'إعادة المحاولة', vm.load),
            NearbyViewState.idle => const SizedBox.shrink()
          }));
  Widget _list() => ListView(children: [
        Wrap(
            spacing: 6,
            children: NearbyRange.values
                .map((x) => ChoiceChip(
                    label: Text(x.name),
                    selected: vm.range == x,
                    onSelected: (_) => vm.setRange(x)))
                .toList()),
        ...vm.hotels.map((item) => ListTile(
            onTap: () => Navigator.pushNamed(context, AppRoutes.hotelDetails,
                arguments: item.hotel.id),
            leading: const CircleAvatar(child: Icon(Icons.hotel)),
            title: Text(item.hotel.nameAr),
            subtitle: Text(item.hotel.province.nameAr),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              Text(item.distanceKm < 1
                  ? '${(item.distanceKm * 1000).round()} م'
                  : '${item.distanceKm.toStringAsFixed(1)} كم'),
              IconButton(
                  onPressed: () => AppDependencies.hotels
                      .setFavorite(item.hotel.id, !item.hotel.isFavorite),
                  icon: Icon(item.hotel.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border))
            ])))
      ]);
  Widget _action(String text, String label, Future<void> Function() action) =>
      Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(text),
        FilledButton(onPressed: action, child: Text(label))
      ]));
}
