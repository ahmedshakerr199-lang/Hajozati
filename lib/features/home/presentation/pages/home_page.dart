import 'package:flutter/material.dart';
import '../../../../app/app_dependencies.dart';
import '../../../../app/navigation/app_routes.dart';
import '../viewmodels/home_view_model.dart';

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
          appBar: AppBar(title: const Text('حجوزاتي')),
          body: vm.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(padding: const EdgeInsets.all(16), children: [
                  const Text('مرحباً أحمد',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  const Text('إلى أين ستكون رحلتك القادمة؟'),
                  const SizedBox(height: 18),
                  Card(
                      child: ListTile(
                          leading: const Icon(Icons.explore),
                          title: const Text('اكتشف العراق'),
                          subtitle: const Text('وجهات وتجارب عراقية مميزة'),
                          onTap: () =>
                              Navigator.pushNamed(context, AppRoutes.explore))),
                  Card(
                      child: ListTile(
                          leading: const Icon(Icons.location_on),
                          title: const Text('فنادق قريبة منك'),
                          subtitle: const Text('استخدم موقعك عند الطلب فقط'),
                          onTap: () =>
                              Navigator.pushNamed(context, AppRoutes.nearby))),
                  const SizedBox(height: 16),
                  const Text('إقامات مميزة',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ...vm.featured.map((hotel) => Card(
                      child: ListTile(
                          title: Text(hotel.nameAr),
                          subtitle: Text(hotel.province.nameAr),
                          trailing: Text(
                              '${hotel.minimumPricePerNight ~/ 1000} ألف'))))
                ])));
}
