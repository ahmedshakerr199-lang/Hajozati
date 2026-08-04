import 'package:flutter_test/flutter_test.dart';
import 'package:hajozati/app/app_dependencies.dart';
import 'package:hajozati/core/result/app_result.dart';

void main() {
  test('release removes the cached view model', () async {
    final first = await AppDependencies.bookingFlow
        .createDraftForHotel('hotel-lifecycle');
    final vm = (first as AppSuccess).data;
    final id = vm.booking!.id;
    await AppDependencies.bookingFlow.releaseBookingFlow(id);
    expect(await AppDependencies.bookingFlow.getOrCreateBookingViewModel(id),
        isA<AppSuccess>());
  });
}
