import 'package:flutter/material.dart';
import '../../../../app/app_dependencies.dart';
import '../../../../app/navigation/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/hajozati_components.dart';
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
      return const HajozatiStateView.loading();
    }
    if (vm.state == ExploreState.error) {
      return HajozatiStateView.error(
          message: 'تعذر تحميل الوجهات.', onAction: vm.load);
    }
    if (vm.state == ExploreState.empty) {
      return const HajozatiStateView.empty(message: 'لا توجد وجهات مطابقة.');
    }
    return ListView(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.page, AppSpacing.sm, AppSpacing.page, AppSpacing.xl),
        children: [
          TextField(
              onChanged: vm.scheduleSearch,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'ابحث بالعربية أو الإنجليزية')),
          const SizedBox(height: AppSpacing.sm),
          DropdownButtonFormField<String>(
              isExpanded: true,
              initialValue: vm.selectedProvince,
              decoration: const InputDecoration(labelText: 'المحافظة'),
              hint: const Text('جميع المحافظات'),
              items: [
                const DropdownMenuItem(
                    value: null, child: Text('جميع المحافظات')),
                ...vm.provinces.map((value) =>
                    DropdownMenuItem(value: value, child: Text(value)))
              ],
              onChanged: vm.filterProvince),
          const SizedBox(height: AppSpacing.sm),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                ChoiceChip(
                    label: const Text('الكل'),
                    selected: vm.selectedCategory == null,
                    onSelected: (_) => vm.filterCategory(null)),
                ...DestinationCategory.values.map((category) => Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.xs),
                    child: ChoiceChip(
                        label: Text(category.name),
                        selected: vm.selectedCategory == category,
                        onSelected: (_) => vm.filterCategory(category))))
              ])),
          if (vm.featured.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            const SectionHeader(title: 'وجهات مميزة'),
            _row(vm.featured)
          ],
          if (vm.popular.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            const SectionHeader(title: 'الأكثر رواجاً'),
            _row(vm.popular)
          ],
          const SizedBox(height: AppSpacing.lg),
          const SectionHeader(title: 'كل الوجهات'),
          ...vm.destinations.map(_card)
        ]);
  }

  Widget _row(List<TouristDestination> items) => SizedBox(
      height: 220,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          itemBuilder: (_, index) => Padding(
              padding: const EdgeInsets.only(left: AppSpacing.sm),
              child: SizedBox(width: 190, child: _card(items[index])))));
  Widget _card(TouristDestination item) => HajozatiCard(
      padding: EdgeInsets.zero,
      onTap: () => Navigator.pushNamed(context, AppRoutes.destinationDetails,
          arguments: item.id),
      child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(children: [
            Hero(
                tag: 'destination-${item.id}',
                child: const CircleAvatar(child: Icon(Icons.explore_rounded))),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(item.nameAr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, fontFamily: 'Cairo')),
                  Text(item.cityAr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.muted))
                ])),
            const Icon(Icons.arrow_back_ios_new_rounded, size: 15)
          ])));
}
