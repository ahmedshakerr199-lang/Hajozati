import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';
import '../../features/hotels/domain/entities/province.dart';
import '../../features/search/domain/hotel_search_criteria.dart';

/// Reusable, mobile-first criteria panel for hotel discovery.
class HotelSearchPanel extends StatefulWidget {
  const HotelSearchPanel(
      {super.key,
      required this.provinces,
      required this.onSearch,
      this.initialCriteria = const HotelSearchCriteria()});
  final List<Province> provinces;
  final ValueChanged<HotelSearchCriteria> onSearch;
  final HotelSearchCriteria initialCriteria;
  @override
  State<HotelSearchPanel> createState() => _HotelSearchPanelState();
}

class _HotelSearchPanelState extends State<HotelSearchPanel> {
  late HotelSearchCriteria value = widget.initialCriteria;
  String? error;
  String _date(DateTime? date) =>
      date == null ? 'اختر التاريخ' : '${date.year}/${date.month}/${date.day}';
  String _guests() =>
      '${value.adults} بالغ • ${value.children} أطفال • ${value.rooms} غرفة';
  void _set(HotelSearchCriteria next) => setState(() {
        value = next;
        error = null;
      });
  Future<void> _pickDate(bool checkIn) async {
    final first = checkIn
        ? DateTime.now()
        : (value.checkIn ?? DateTime.now()).add(const Duration(days: 1));
    final selected = await showDatePicker(
        context: context,
        firstDate: DateTime(first.year, first.month, first.day),
        lastDate: DateTime.now().add(const Duration(days: 730)),
        initialDate:
            checkIn ? value.checkIn ?? first : value.checkOut ?? first);
    if (selected == null) return;
    final out = checkIn &&
            (value.checkOut == null || !value.checkOut!.isAfter(selected))
        ? selected.add(const Duration(days: 1))
        : value.checkOut;
    _set(HotelSearchCriteria(
        provinceId: value.provinceId,
        provinceName: value.provinceName,
        checkIn: checkIn ? selected : value.checkIn,
        checkOut: checkIn ? out : selected,
        adults: value.adults,
        children: value.children,
        rooms: value.rooms));
  }

  Future<void> _province() async {
    final picked = await showModalBottomSheet<Province>(
        context: context,
        isScrollControlled: true,
        builder: (context) => _ProvinceSheet(
            provinces: widget.provinces, selectedId: value.provinceId));
    if (picked != null) {
      _set(HotelSearchCriteria(
          provinceId: picked.id,
          provinceName: picked.nameAr,
          checkIn: value.checkIn,
          checkOut: value.checkOut,
          adults: value.adults,
          children: value.children,
          rooms: value.rooms));
    }
  }

  Future<void> _guestsSheet() async {
    final result = await showModalBottomSheet<List<int>>(
        context: context,
        builder: (context) => _GuestSheet(
            adults: value.adults,
            children: value.children,
            rooms: value.rooms));
    if (result != null) {
      _set(HotelSearchCriteria(
          provinceId: value.provinceId,
          provinceName: value.provinceName,
          checkIn: value.checkIn,
          checkOut: value.checkOut,
          adults: result[0],
          children: result[1],
          rooms: result[2]));
    }
  }

  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
          color: AppColors.searchSurface,
          borderRadius: BorderRadius.circular(AppRadius.hero),
          boxShadow: AppShadows.floating),
      child: Column(children: [
        const Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            alignment: WrapAlignment.end,
            children: [
              _SearchCategory(
                  label: 'الكل',
                  icon: Icons.auto_awesome_rounded,
                  selected: true),
              _SearchCategory(label: 'فنادق', icon: Icons.apartment_rounded),
              _SearchCategory(label: 'شاليهات', icon: Icons.home_outlined),
              _SearchCategory(label: 'منتجعات', icon: Icons.waves_rounded),
              _SearchCategory(
                  label: 'أجنحة VIP', icon: Icons.workspace_premium_outlined),
            ]),
        const SizedBox(height: AppSpacing.md),
        LayoutBuilder(builder: (context, constraints) {
          final fields = [
            _field(Icons.location_on_outlined, 'المحافظة',
                value.provinceName ?? 'كل المحافظات', _province),
            _field(Icons.calendar_today_outlined, 'تاريخ الوصول',
                _date(value.checkIn), () => _pickDate(true)),
            _field(Icons.calendar_today_outlined, 'تاريخ المغادرة',
                _date(value.checkOut), () => _pickDate(false)),
            _field(Icons.group_outlined, 'عدد الضيوف', _guests(), _guestsSheet),
          ];
          if (constraints.maxWidth < 620) {
            return Column(children: [
              for (final field in fields) ...[
                field,
                const SizedBox(height: AppSpacing.sm),
              ],
            ]);
          }
          return Row(children: [
            for (var index = 0; index < fields.length; index++) ...[
              Expanded(child: fields[index]),
              if (index != fields.length - 1)
                const SizedBox(width: AppSpacing.sm),
            ],
          ]);
        }),
        if (error != null)
          Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Text(error!,
                  style: const TextStyle(color: AppColors.danger))),
        const SizedBox(height: AppSpacing.xs),
        SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
                style: FilledButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    minimumSize: const Size.fromHeight(52)),
                onPressed: () {
                  if (value.provinceId == null ||
                      value.checkIn == null ||
                      value.checkOut == null) {
                    setState(
                        () => error = 'يرجى اختيار المحافظة وتواريخ الإقامة.');
                    return;
                  }
                  widget.onSearch(value);
                },
                icon: const Icon(Icons.search_rounded),
                label: const Text('بحث عن عقار')))
      ]));
  Widget _field(
          IconData icon, String title, String subtitle, VoidCallback action) =>
      InkWell(
          onTap: action,
          borderRadius: BorderRadius.circular(AppRadius.field),
          child: Container(
              constraints: const BoxConstraints(minHeight: 68),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(AppRadius.field)),
              child: Row(children: [
                Icon(icon, size: 19, color: AppColors.primary),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(title,
                          style: const TextStyle(
                              color: AppColors.muted, fontSize: 12)),
                      Text(subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700))
                    ])),
                const Icon(Icons.keyboard_arrow_down_rounded,
                    color: AppColors.text)
              ])));
}

class _SearchCategory extends StatelessWidget {
  const _SearchCategory(
      {required this.label, required this.icon, this.selected = false});
  final String label;
  final IconData icon;
  final bool selected;

  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.navigationSelected,
          borderRadius: BorderRadius.circular(AppRadius.pill)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 16, color: selected ? Colors.white : AppColors.muted),
        const SizedBox(width: AppSpacing.xxs),
        Text(label,
            style: TextStyle(
                color: selected ? Colors.white : AppColors.text,
                fontWeight: FontWeight.w700,
                fontSize: 12))
      ]));
}

class _ProvinceSheet extends StatefulWidget {
  const _ProvinceSheet({required this.provinces, this.selectedId});
  final List<Province> provinces;
  final String? selectedId;
  @override
  State<_ProvinceSheet> createState() => _ProvinceSheetState();
}

class _ProvinceSheetState extends State<_ProvinceSheet> {
  String q = '';
  @override
  Widget build(BuildContext context) {
    final values = widget.provinces
        .where((p) =>
            p.nameAr.contains(q) ||
            p.nameEn.toLowerCase().contains(q.toLowerCase()))
        .toList();
    return SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(AppSpacing.page),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(
                  onChanged: (x) => setState(() => q = x),
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'ابحث عن محافظة')),
              const SizedBox(height: AppSpacing.sm),
              Flexible(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: values.length,
                      itemBuilder: (_, i) {
                        final p = values[i];
                        return ListTile(
                            onTap: () => Navigator.pop(context, p),
                            leading: const Icon(Icons.location_on_outlined),
                            title: Text(p.nameAr),
                            trailing: p.id == widget.selectedId
                                ? const Icon(Icons.check)
                                : null);
                      }))
            ])));
  }
}

class _GuestSheet extends StatefulWidget {
  const _GuestSheet(
      {required this.adults, required this.children, required this.rooms});
  final int adults, children, rooms;
  @override
  State<_GuestSheet> createState() => _GuestSheetState();
}

class _GuestSheetState extends State<_GuestSheet> {
  late int a = widget.adults, c = widget.children, r = widget.rooms;
  @override
  Widget build(BuildContext context) => SafeArea(
      child: Padding(
          padding: const EdgeInsets.all(AppSpacing.page),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            _counter('البالغون', a, 1, (v) => setState(() => a = v)),
            _counter('الأطفال', c, 0, (v) => setState(() => c = v)),
            _counter('الغرف', r, 1, (v) => setState(() => r = v)),
            FilledButton(
                onPressed: () => Navigator.pop(context, [a, c, r]),
                child: const Text('تم'))
          ])));
  Widget _counter(String label, int value, int min, ValueChanged<int> change) =>
      Row(children: [
        Expanded(child: Text(label)),
        IconButton(
            onPressed: value > min ? () => change(value - 1) : null,
            icon: const Icon(Icons.remove_circle_outline)),
        Text('$value'),
        IconButton(
            onPressed: () => change(value + 1),
            icon: const Icon(Icons.add_circle_outline))
      ]);
}
