import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hajozati/app/app_dependencies.dart';
import 'package:hajozati/app/navigation/app_router.dart';
import 'package:hajozati/app/navigation/app_routes.dart';
import 'package:hajozati/core/result/app_result.dart';

void main() {
  test('booking routes accept only a booking id', () async {
    final created =
        await AppDependencies.bookingFlow.createDraftForHotel('hotel-1');
    final id = ((created as AppSuccess).data).booking!.id;
    expect(
        AppRouter.onGenerateRoute(
            RouteSettings(name: AppRoutes.roomSelection, arguments: id)),
        isA<MaterialPageRoute>());
    expect(
        AppRouter.onGenerateRoute(
            RouteSettings(name: AppRoutes.bookingDetails, arguments: id)),
        isA<MaterialPageRoute>());
    expect(
        AppRouter.onGenerateRoute(
            RouteSettings(name: AppRoutes.bookingSummary, arguments: id)),
        isA<MaterialPageRoute>());
  });
  test(
      'unknown route is an error route',
      () => expect(
          AppRouter.onGenerateRoute(const RouteSettings(name: '/unknown')),
          isA<MaterialPageRoute>()));
  test('same booking id keeps the same view model', () async {
    final created =
        await AppDependencies.bookingFlow.createDraftForHotel('hotel-2');
    final id = ((created as AppSuccess).data).booking!.id;
    final first =
        await AppDependencies.bookingFlow.getOrCreateBookingViewModel(id);
    final second =
        await AppDependencies.bookingFlow.getOrCreateBookingViewModel(id);
    expect((first as AppSuccess).data, same((second as AppSuccess).data));
  });
}
