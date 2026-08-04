import 'package:flutter/material.dart';
import '../../../../app/app_dependencies.dart';
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
          appBar: AppBar(title: const Text('فنادق قريبة منك')),
          body: switch (vm.state) {
            NearbyViewState.loading =>
              const Center(child: CircularProgressIndicator()),
            NearbyViewState.success => _list(),
            NearbyViewState.permissionDenied => _action(
                'نحتاج إذن الموقع لعرض الفنادق القريبة.',
                'السماح بالموقع',
                vm.requestPermission),
            NearbyViewState.serviceDisabled => _action('خدمة الموقع متوقفة.',
                'فتح الإعدادات', vm.openLocationSettings),
            NearbyViewState.error =>
              _action(vm.message ?? 'تعذر التحميل.', 'إعادة المحاولة', vm.load),
            NearbyViewState.idle => const SizedBox.shrink()
          }));
  Widget _list() => Column(children: [
        Wrap(
            spacing: 6,
            children: NearbyRange.values
                .map((value) => ChoiceChip(
                    label: Text(_label(value)),
                    selected: vm.range == value,
                    onSelected: (_) => vm.setRange(value)))
                .toList()),
        Expanded(
            child: vm.hotels.isEmpty
                ? const Center(child: Text('لا توجد فنادق ضمن هذا النطاق.'))
                : ListView.builder(
                    itemCount: vm.hotels.length,
                    itemBuilder: (_, index) {
                      final item = vm.hotels[index];
                      return ListTile(
                          leading: const CircleAvatar(child: Icon(Icons.hotel)),
                          title: Text(item.hotel.nameAr),
                          subtitle: Text(item.hotel.province.nameAr),
                          trailing:
                              Text('${item.distanceKm.toStringAsFixed(1)} كم'));
                    }))
      ]);
  Widget _action(String text, String label, Future<void> Function() action) =>
      Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(text),
        const SizedBox(height: 12),
        FilledButton(onPressed: action, child: Text(label))
      ]));
  String _label(NearbyRange value) => switch (value) {
        NearbyRange.all => 'الكل',
        NearbyRange.km5 => '5 كم',
        NearbyRange.km10 => '10 كم',
        NearbyRange.km25 => '25 كم',
        NearbyRange.km50 => '50 كم'
      };
}
