import 'package:flutter/material.dart';
import '../../../app/app_dependencies.dart';
import '../../../app/navigation/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/hajozati_components.dart';
import '../domain/search_use_cases.dart';
import '../domain/hotel_search_criteria.dart';
import 'search_view_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, this.criteria});
  final HotelSearchCriteria? criteria;
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final SearchViewModel vm;
  @override
  void initState() {
    super.initState();
    final r = AppDependencies.search;
    vm = SearchViewModel(SearchHotelsUseCase(r), GetSearchSuggestionsUseCase(r),
        SaveRecentSearchUseCase(r), ClearRecentSearchesUseCase(r), r);
    if (widget.criteria case final criteria?) vm.searchCriteria(criteria);
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
          appBar: AppBar(title: const Text('البحث عن إقامة')),
          body: SafeArea(
              child: Column(children: [
            if (widget.criteria != null)
              Padding(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.page, AppSpacing.sm, AppSpacing.page, 0),
                  child: Text(
                      '${widget.criteria!.provinceName} • ${widget.criteria!.nights} ليالٍ',
                      style: const TextStyle(fontWeight: FontWeight.w700))),
            Padding(
                padding: const EdgeInsets.all(AppSpacing.page),
                child: TextField(
                    onChanged: vm.scheduleSearch,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'ابحث عن فندق أو محافظة'))),
            if (vm.state == SearchState.loading)
              const LinearProgressIndicator(),
            Expanded(
                child: vm.state == SearchState.empty
                    ? const HajozatiStateView.empty(
                        message: 'لا توجد نتائج. جرّب إزالة بعض الفلاتر.')
                    : vm.state == SearchState.error
                        ? HajozatiStateView.error(
                            message: vm.error ?? 'حدث خطأ أثناء البحث.',
                            onAction: vm.retry)
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.page),
                            itemCount: vm.results.length +
                                (vm.results.isEmpty ? 0 : 1),
                            itemBuilder: (context, index) {
                              if (index == 0 && vm.results.isNotEmpty) {
                                return const Padding(
                                    padding: EdgeInsets.only(
                                        top: AppSpacing.lg,
                                        bottom: AppSpacing.sm),
                                    child: SectionHeader(
                                        title: 'الفنادق المتاحة'));
                              }
                              final hotel = vm.results[index - 1];
                              return Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: AppSpacing.sm),
                                  child: HotelPreviewCard(
                                      name: hotel.nameAr,
                                      location:
                                          '${hotel.cityAr}، ${hotel.province.nameAr}',
                                      price:
                                          '${hotel.minimumPricePerNight} د.ع',
                                      rating: hotel.rating,
                                      imageUrl: hotel.coverImageUrl,
                                      badge: hotel.isFeatured ? 'مميز' : null,
                                      onTap: () => Navigator.pushNamed(
                                          context, AppRoutes.hotelDetails,
                                          arguments: hotel.id)));
                            }))
          ]))));
}
