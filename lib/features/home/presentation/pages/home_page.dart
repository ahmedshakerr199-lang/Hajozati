import 'package:flutter/material.dart';

import '../../../../app/app_dependencies.dart';
import '../../../../app/navigation/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/hajozati_components.dart';
import '../../../../shared/widgets/hotel_search_panel.dart';
import '../viewmodels/home_view_model.dart';

/// Reference-aligned booking landing page with a responsive hero and search panel.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = HomeViewModel(AppDependencies.hotels)..load();
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
          drawer: const _HomeDrawer(),
          bottomNavigationBar: const _HomeNavigation(),
          body: _body()));

  Widget _body() {
    if (vm.isLoading) {
      return const SafeArea(child: HajozatiStateView.loading());
    }
    if (vm.error != null) {
      return SafeArea(
          child:
              HajozatiStateView.error(message: vm.error!, onAction: vm.retry));
    }
    return CustomScrollView(slivers: [
      SliverToBoxAdapter(child: _header()),
      SliverToBoxAdapter(
          child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [AppColors.heroStart, AppColors.heroEnd])),
              child: SafeArea(
                  top: false,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(AppSpacing.page,
                          AppSpacing.xl, AppSpacing.page, AppSpacing.xl),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Align(
                                alignment: Alignment.centerRight,
                                child: _HeroBadge()),
                            const SizedBox(height: AppSpacing.md),
                            const Text(
                                'اكتشف أفضل الفنادق والشاليهات\nفي جميع المحافظات العراقية',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 34,
                                    height: 1.12,
                                    fontWeight: FontWeight.w800)),
                            const SizedBox(height: AppSpacing.sm),
                            const Text(
                                'احجز إقامتك القادمة بأسهل طريقة وأفضل الأسعار. أكثر من 40 عقاراً فاخراً في 18 محافظة.',
                                style: TextStyle(
                                    color: AppColors.heroTextMuted,
                                    fontSize: 16,
                                    height: 1.55)),
                            const SizedBox(height: AppSpacing.lg),
                            HotelSearchPanel(
                                provinces: vm.provinces,
                                onSearch: (criteria) => Navigator.pushNamed(
                                    context, AppRoutes.search,
                                    arguments: criteria)),
                          ]))))),
      SliverToBoxAdapter(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.page, AppSpacing.xl, AppSpacing.page, 0),
              child: _sectionHeader(
                  'عقارات مميزة', 'الأكثر طلباً وتقييماً هذا الموسم'))),
      SliverToBoxAdapter(
          child: SizedBox(
              height: 252,
              child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.page, vertical: AppSpacing.md),
                  scrollDirection: Axis.horizontal,
                  itemCount: vm.featured.length,
                  itemBuilder: (_, index) {
                    final hotel = vm.featured[index];
                    return Padding(
                        padding: const EdgeInsets.only(left: AppSpacing.md),
                        child: SizedBox(
                            width: 255,
                            child: HotelPreviewCard(
                                name: hotel.nameAr,
                                location:
                                    '${hotel.cityAr}، ${hotel.province.nameAr}',
                                price: '${hotel.minimumPricePerNight} د.ع',
                                rating: hotel.rating,
                                imageUrl: hotel.coverImageUrl,
                                badge: hotel.isFeatured ? 'فندق' : null,
                                onTap: () => Navigator.pushNamed(
                                    context, AppRoutes.hotelDetails,
                                    arguments: hotel.id))));
                  }))),
      SliverToBoxAdapter(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.page, AppSpacing.lg, AppSpacing.page, 0),
              child: _sectionHeader(
                  'لماذا حجوزاتي؟', 'تجربة حجز سهلة وآمنة وموثوقة'))),
      SliverPadding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.page, AppSpacing.md, AppSpacing.page, AppSpacing.xl),
          sliver: SliverList.list(children: const [
            _ReasonCard(
                icon: Icons.travel_explore_rounded,
                title: 'بحث ذكي وسهل',
                description:
                    'ابحث حسب المحافظة والتواريخ وعدد الضيوف لتجد العقار المثالي.'),
            SizedBox(height: AppSpacing.sm),
            _ReasonCard(
                icon: Icons.sell_outlined,
                title: 'أفضل الأسعار',
                description: 'أسعار تنافسية بالدينار العراقي، بدون رسوم خفية.'),
            SizedBox(height: AppSpacing.sm),
            _ReasonCard(
                icon: Icons.verified_user_outlined,
                title: 'حجز فوري كضيف',
                description: 'أكمل حجزك بسرعة وبخطوات واضحة وآمنة.'),
          ]))
    ]);
  }

  Widget _header() => SafeArea(
      bottom: false,
      child: Container(
          height: 64,
          color: AppColors.header,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
          child: Builder(
              builder: (scaffoldContext) => Row(children: [
                    const _BrandMark(),
                    const Spacer(),
                    IconButton(
                        tooltip: 'القائمة',
                        onPressed: () =>
                            Scaffold.of(scaffoldContext).openDrawer(),
                        icon: const Icon(Icons.menu_rounded,
                            color: AppColors.text))
                  ]))));

  Widget _sectionHeader(String title, String subtitle) => Row(children: [
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 25,
                  fontWeight: FontWeight.w800)),
          Text(subtitle,
              style: const TextStyle(color: AppColors.muted, fontSize: 13))
        ])),
        TextButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.search),
            child: const Text('عرض الكل'))
      ]);
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) => SizedBox(
      width: 180,
      child: Row(children: [
        Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppRadius.field)),
            child: const Icon(Icons.logout_rounded, color: Colors.white)),
        const SizedBox(width: AppSpacing.xs),
        const Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('حجوزاتي',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
          Text('فنادق وشاليهات العراق',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: AppColors.muted, fontSize: 9))
        ]))
      ]));
}

class _HeroBadge extends StatelessWidget {
  const _HeroBadge();

  @override
  Widget build(BuildContext context) => ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 340),
      child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
          decoration: BoxDecoration(
              color: AppColors.heroBadge,
              borderRadius: BorderRadius.circular(AppRadius.pill)),
          child: const Text('✨ منصة الحجوزات الأولى في العراق',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700))));
}

class _ReasonCard extends StatelessWidget {
  const _ReasonCard(
      {required this.icon, required this.title, required this.description});
  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          boxShadow: AppShadows.card),
      child: Row(children: [
        CircleAvatar(
            backgroundColor: AppColors.softPrimary,
            child: Icon(icon, color: AppColors.primary)),
        const SizedBox(width: AppSpacing.md),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: AppSpacing.xxs),
          Text(description,
              style: const TextStyle(color: AppColors.muted, height: 1.4))
        ]))
      ]));
}

class _HomeDrawer extends StatelessWidget {
  const _HomeDrawer();

  @override
  Widget build(BuildContext context) => Drawer(
      backgroundColor: AppColors.navigationSurface,
      child: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(AppSpacing.page),
              child: Column(children: [
                Row(children: [
                  const _BrandMark(),
                  const Spacer(),
                  IconButton(
                      tooltip: 'إغلاق القائمة',
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded))
                ]),
                const Divider(height: AppSpacing.xl),
                _DrawerItem(
                    icon: Icons.home_outlined,
                    label: 'الرئيسية',
                    selected: true,
                    onTap: () => Navigator.pop(context)),
                _DrawerItem(
                    icon: Icons.explore_outlined,
                    label: 'استكشف العراق',
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.explore)),
                const _DrawerItem(
                    icon: Icons.favorite_border, label: 'المفضلة'),
                const _DrawerItem(
                    icon: Icons.calendar_month_outlined, label: 'حجوزاتي'),
                const Spacer(),
                SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                        onPressed: () {}, child: const Text('تسجيل الدخول')))
              ]))));
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem(
      {required this.icon,
      required this.label,
      this.onTap,
      this.selected = false});
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) => ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.field)),
      tileColor: selected ? AppColors.navigationSelected : null,
      leading:
          Icon(icon, color: selected ? AppColors.primary : AppColors.muted),
      title: Text(label,
          style: TextStyle(
              color: selected ? AppColors.primary : AppColors.text,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w600)));
}

class _HomeNavigation extends StatelessWidget {
  const _HomeNavigation();

  @override
  Widget build(BuildContext context) => SafeArea(
      top: false,
      child: Container(
          height: 68,
          decoration: const BoxDecoration(
              color: AppColors.navigationSurface, boxShadow: AppShadows.card),
          child: Row(children: [
            const _NavItem(
                icon: Icons.home_outlined, label: 'الرئيسية', selected: true),
            _NavItem(
                icon: Icons.explore_outlined,
                label: 'استكشف',
                onTap: () => Navigator.pushNamed(context, AppRoutes.explore)),
            const _NavItem(icon: Icons.favorite_border, label: 'المفضلة'),
            const _NavItem(
                icon: Icons.calendar_month_outlined, label: 'حجوزاتي'),
          ])));
}

class _NavItem extends StatelessWidget {
  const _NavItem(
      {required this.icon,
      required this.label,
      this.selected = false,
      this.onTap});
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Expanded(
      child: Semantics(
          button: true,
          selected: selected,
          label: label,
          child: InkWell(
              onTap: onTap,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon,
                        color: selected ? AppColors.primary : AppColors.muted,
                        size: 22),
                    const SizedBox(height: 2),
                    Text(label,
                        style: TextStyle(
                            color:
                                selected ? AppColors.primary : AppColors.muted,
                            fontSize: 11,
                            fontWeight:
                                selected ? FontWeight.w800 : FontWeight.w600))
                  ]))));
}
