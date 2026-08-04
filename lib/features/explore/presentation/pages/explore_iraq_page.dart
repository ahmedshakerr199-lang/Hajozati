import 'package:flutter/material.dart';
import '../../../../app/app_dependencies.dart';
import '../../../../app/navigation/app_routes.dart';
import '../../domain/entities/tourist_destination.dart';
import '../../domain/usecases/explore_use_cases.dart';
import '../viewmodels/explore_view_model.dart';

class ExploreIraqPage extends StatefulWidget {
  const ExploreIraqPage({super.key});
  @override
  State<ExploreIraqPage> createState() => _ExploreIraqPageState();
}

class _ExploreIraqPageState extends State<ExploreIraqPage> {
  late final ExploreViewModel vm;
  @override
  void initState() {
    super.initState();
    final repo = AppDependencies.explore;
    vm = ExploreViewModel(
        GetDestinationsUseCase(repo),
        GetFeaturedDestinationsUseCase(repo),
        GetPopularDestinationsUseCase(repo),
        SearchDestinationsUseCase(repo),
        FilterDestinationsByProvinceUseCase(repo),
        FilterDestinationsByCategoryUseCase(repo))
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
          appBar: AppBar(title: const Text('اكتشف العراق')), body: _body()));
  Widget _body() {
    if (vm.state == ExploreState.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (vm.state == ExploreState.error) {
      return Center(
          child: FilledButton(
              onPressed: vm.load, child: const Text('إعادة المحاولة')));
    }
    if (vm.state == ExploreState.empty) {
      return const Center(child: Text('لا توجد وجهات مطابقة.'));
    }
    return ListView(padding: const EdgeInsets.all(16), children: [
      TextField(
          onChanged: vm.search,
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'ابحث بالعربية أو الإنجليزية')),
      const SizedBox(height: 12),
      DropdownButtonFormField<String>(
          initialValue: vm.selectedProvince,
          decoration: const InputDecoration(labelText: 'المحافظة'),
          hint: const Text('جميع المحافظات'),
          items: [
            const DropdownMenuItem(value: null, child: Text('جميع المحافظات')),
            ...vm.provinces.map(
                (value) => DropdownMenuItem(value: value, child: Text(value)))
          ],
          onChanged: vm.filterProvince),
      const SizedBox(height: 12),
      Wrap(spacing: 6, children: [
        ChoiceChip(
            label: const Text('الكل'),
            selected: vm.selectedCategory == null,
            onSelected: (_) => vm.filterCategory(null)),
        ...DestinationCategory.values.map((category) => ChoiceChip(
            label: Text(category.name),
            selected: vm.selectedCategory == category,
            onSelected: (_) => vm.filterCategory(category)))
      ]),
      if (vm.featured.isNotEmpty) ...[
        const SizedBox(height: 16),
        const Text('وجهات مميزة'),
        _row(vm.featured)
      ],
      if (vm.popular.isNotEmpty) ...[
        const SizedBox(height: 16),
        const Text('الأكثر رواجاً'),
        _row(vm.popular)
      ],
      const SizedBox(height: 16),
      const Text('كل الوجهات'),
      ...vm.destinations.map(_card)
    ]);
  }

  Widget _row(List<TouristDestination> items) => SizedBox(
      height: 120,
      child: ListView(
          scrollDirection: Axis.horizontal,
          children: items
              .map((item) => SizedBox(width: 160, child: _card(item)))
              .toList()));
  Widget _card(TouristDestination item) => Card(
      child: ListTile(
          onTap: () => Navigator.pushNamed(
              context, AppRoutes.destinationDetails, arguments: item.id),
          leading: Hero(
              tag: 'destination-${item.id}',
              child: const CircleAvatar(child: Icon(Icons.explore))),
          title: Text(item.nameAr),
          subtitle: Text(item.cityAr),
          trailing: const Icon(Icons.chevron_left)));
}
