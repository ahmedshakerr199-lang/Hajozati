import 'package:flutter/material.dart';
import '../../../../app/app_dependencies.dart';
import '../../../../app/navigation/app_routes.dart';
import '../../../../core/result/app_result.dart';
import '../../domain/entities/tourist_destination.dart';
import '../../domain/usecases/explore_use_cases.dart';

class DestinationDetailsPage extends StatefulWidget {
  const DestinationDetailsPage({super.key, required this.destinationId});
  final String destinationId;
  @override
  State<DestinationDetailsPage> createState() => _DestinationDetailsPageState();
}

class _DestinationDetailsPageState extends State<DestinationDetailsPage> {
  AppResult<TouristDestination>? result;
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final value = await GetDestinationDetailsUseCase(AppDependencies.explore)(
        widget.destinationId);
    if (mounted) setState(() => result = value);
  }

  @override
  Widget build(BuildContext context) {
    final value = result;
    if (value == null)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (value is AppFailure<TouristDestination>)
      return Scaffold(
          appBar: AppBar(),
          body: Center(
              child: FilledButton(
                  onPressed: _load, child: Text(value.error.message))));
    final item = (value as AppSuccess<TouristDestination>).data;
    return Scaffold(
        appBar: AppBar(title: Text(item.nameAr)),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          Hero(
              tag: 'destination-${item.id}',
              child: AspectRatio(
                  aspectRatio: 1.6,
                  child: Image.network(item.coverImageUrl, fit: BoxFit.cover))),
          Text(item.nameAr, style: Theme.of(context).textTheme.headlineSmall),
          Text('${item.cityAr} · ${item.provinceId}'),
          Text(item.descriptionAr),
          if (item.openingHoursAr != null) Text(item.openingHoursAr!),
          const ListTile(
              leading: Icon(Icons.map_outlined),
              title: Text('خريطة OpenStreetMap ستكون متاحة قريبًا')),
          FilledButton.icon(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.nearby),
              icon: const Icon(Icons.hotel),
              label: const Text('عرض الفنادق القريبة'))
        ]));
  }
}
