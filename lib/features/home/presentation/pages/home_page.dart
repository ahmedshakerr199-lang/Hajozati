import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/section_title.dart';
import '../../data/datasources/hotel_local_data_source.dart';
import '../widgets/hotel_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        height: 74,
        selectedIndex: 0,
        onDestinationSelected: (_) {},
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'الرئيسية'),
          NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore_rounded), label: 'استكشف'),
          NavigationDestination(icon: Icon(Icons.bookmark_outline_rounded), selectedIcon: Icon(Icons.bookmark_rounded), label: 'حجوزاتي'),
          NavigationDestination(icon: Icon(Icons.person_outline_rounded), selectedIcon: Icon(Icons.person_rounded), label: 'حسابي'),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _Header()),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              sliver: SliverList(delegate: SliverChildListDelegate([
                const SectionTitle(title: 'وجهات ملهمة', action: 'عرض الكل'),
                const SizedBox(height: 14),
                const _Destinations(),
                const SizedBox(height: 28),
                const SectionTitle(title: 'إقامات مختارة لك', action: 'عرض الكل'),
                const SizedBox(height: 14),
                SizedBox(
                  height: 286,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: HotelLocalDataSource.featured.length,
                    itemBuilder: (_, index) => HotelCard(hotel: HotelLocalDataSource.featured[index]),
                  ),
                ),
                const SizedBox(height: 28),
                const _OfferBanner(),
                const SizedBox(height: 28),
              ])),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.navy, AppColors.deepBlue], begin: Alignment.topRight, end: Alignment.bottomLeft),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(34)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              width: 43, height: 43,
              decoration: BoxDecoration(color: Colors.white.withOpacity(.15), shape: BoxShape.circle),
              child: const Icon(Icons.notifications_none_rounded, color: Colors.white),
            ),
            const Spacer(),
            const Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('أهلاً أحمد', style: TextStyle(color: Color(0xFFD9F6F2), fontSize: 14)),
              SizedBox(height: 3), Text('إلى أين تأخذك رحلتك؟', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 19)),
            ]),
          ]),
          const SizedBox(height: 25),
          Container(
            height: 60,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(19)),
            child: const Row(children: [
              Padding(padding: EdgeInsetsDirectional.only(start: 16), child: Icon(Icons.search_rounded, color: AppColors.ocean, size: 26)),
              SizedBox(width: 11), Text('ابحث عن مدينة أو فندق', style: TextStyle(color: Color(0xFF829AB1), fontSize: 15)),
            ]),
          ),
        ]),
      );
}

class _Destinations extends StatelessWidget {
  const _Destinations();
  @override
  Widget build(BuildContext context) {
    const places = [('دبي', Icons.nightlife_rounded, 0xFFEA796F), ('العلا', Icons.landscape_rounded, 0xFFCB923D), ('بيروت', Icons.waves_rounded, 0xFF197D96), ('مسقط', Icons.sailing_rounded, 0xFF388E7A)];
    return SizedBox(height: 94, child: ListView.separated(
      scrollDirection: Axis.horizontal, itemCount: places.length, separatorBuilder: (_, __) => const SizedBox(width: 13),
      itemBuilder: (_, i) { final place = places[i]; return SizedBox(width: 70, child: Column(children: [
        Container(width: 60, height: 60, decoration: BoxDecoration(color: Color(place.$3).withOpacity(.12), shape: BoxShape.circle), child: Icon(place.$2, color: Color(place.$3), size: 29)),
        const SizedBox(height: 7), Text(place.$1, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
      ])); },
    ));
  }
}

class _OfferBanner extends StatelessWidget {
  const _OfferBanner();
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [AppColors.turquoise, AppColors.ocean]),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(children: [
          const Icon(Icons.card_giftcard_rounded, size: 48, color: AppColors.gold),
          const SizedBox(width: 15),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('خصم حتى 25٪', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
            SizedBox(height: 4), Text('على إقامتك القادمة مع حجوزاتي', style: TextStyle(color: Color(0xFFD9F6F2), fontSize: 13)),
          ])),
          const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Colors.white),
        ]),
      );
}
