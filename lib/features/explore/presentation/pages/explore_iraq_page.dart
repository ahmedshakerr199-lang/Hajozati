import 'dart:async';
import 'package:flutter/material.dart';

import '../../../../app/app_dependencies.dart';
import '../../domain/entities/tourist_destination.dart';

/// Browse destinations through the repository-owned catalog.
class ExploreIraqPage extends StatefulWidget {
  const ExploreIraqPage({super.key});
  @override
  State<ExploreIraqPage> createState() => _ExploreIraqPageState();
}

class _ExploreIraqPageState extends State<ExploreIraqPage> {
  StreamSubscription<List<TouristDestination>>? _subscription;
  List<TouristDestination> _items = const [];
  String _query = '';
  DestinationCategory? _category;
  bool _loading = true;
  @override
  void initState() {
    super.initState();
    _subscription =
        AppDependencies.explore.observeDestinations().listen((items) {
      if (mounted)
        setState(() {
          _items = items;
          _loading = false;
        });
    }, onError: (_) {
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visible = _items
        .where((item) =>
            (_category == null || item.category == _category) &&
            '${item.nameAr} ${item.nameEn}'
                .toLowerCase()
                .contains(_query.toLowerCase()))
        .toList();
    return Scaffold(
        appBar: AppBar(title: const Text('اكتشف العراق')),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(children: [
                Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                        onChanged: (value) => setState(() => _query = value),
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            hintText: 'ابحث عن وجهة'))),
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(children: [
                      ChoiceChip(
                          label: const Text('الكل'),
                          selected: _category == null,
                          onSelected: (_) => setState(() => _category = null)),
                      ...DestinationCategory.values.map((value) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                              label: Text(_categoryName(value)),
                              selected: _category == value,
                              onSelected: (_) =>
                                  setState(() => _category = value))))
                    ])),
                Expanded(
                    child: visible.isEmpty
                        ? const Center(child: Text('لا توجد وجهات مطابقة.'))
                        : ListView.builder(
                            itemCount: visible.length,
                            itemBuilder: (_, index) {
                              final item = visible[index];
                              return Card(
                                  child: ListTile(
                                      leading: const CircleAvatar(
                                          child: Icon(Icons.explore)),
                                      title: Text(item.nameAr),
                                      subtitle: Text(item.cityAr),
                                      trailing:
                                          const Icon(Icons.chevron_left)));
                            }))
              ]));
  }

  String _categoryName(DestinationCategory value) => switch (value) {
        DestinationCategory.archaeologicalSite => 'آثار',
        DestinationCategory.religiousSite => 'دينية',
        DestinationCategory.naturalAttraction => 'طبيعة',
        DestinationCategory.culturalLandmark => 'ثقافة',
        DestinationCategory.museum => 'متاحف',
        DestinationCategory.heritageMarket => 'أسواق',
        DestinationCategory.waterfront => 'مياه',
        DestinationCategory.familyAttraction => 'عائلية',
        DestinationCategory.monument => 'معالم',
        DestinationCategory.traditionalArea => 'تراث'
      };
}
