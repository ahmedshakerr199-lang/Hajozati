import 'package:flutter_test/flutter_test.dart';
import 'package:hajozati/app/app_dependencies.dart';
import 'package:hajozati/core/result/app_result.dart';

void main() {
  test('returns the same view model for one draft', () async {
    final created =
        await AppDependencies.bookingFlow.createDraftForHotel('hotel-1');
    final vm = (created as AppSuccess).data;
    final id = vm.booking!.id;
    final loaded =
        await AppDependencies.bookingFlow.getOrCreateBookingViewModel(id);
    expect((loaded as AppSuccess).data, same(vm));
  });
  test(
      'rejects an empty booking id',
      () async => expect(
          await AppDependencies.bookingFlow.getOrCreateBookingViewModel(''),
          isA<AppFailure>()));
}
