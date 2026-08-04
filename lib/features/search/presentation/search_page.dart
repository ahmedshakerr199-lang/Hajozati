import 'package:flutter/material.dart';
import '../../../app/app_dependencies.dart';
import '../domain/search_use_cases.dart';
import 'search_view_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
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
          appBar: AppBar(title: const Text('البحث')),
          body: Column(children: [
            TextField(
                onChanged: vm.search,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'ابحث عن فندق أو محافظة')),
            if (vm.state == SearchState.loading)
              const LinearProgressIndicator(),
            Expanded(
                child: vm.state == SearchState.empty
                    ? const Center(
                        child: Text('لا توجد نتائج. جرّب إزالة بعض الفلاتر.'))
                    : ListView(children: [
                        ...vm.suggestions.map((x) => ListTile(
                            title: Text(x), onTap: () => vm.search(x))),
                        ...vm.results.map((h) => ListTile(
                            title: Text(h.nameAr),
                            subtitle: Text(h.province.nameAr),
                            trailing: Text('${h.minimumPricePerNight} د.ع')))
                      ]))
          ])));
}
