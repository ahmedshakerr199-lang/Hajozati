import 'package:flutter_test/flutter_test.dart';
import 'package:hajozati/features/nearby/presentation/pages/nearby_hotels_page.dart';

void main() {
  test('nearby hotels page is available', () {
    expect(const NearbyHotelsPage(), isA<NearbyHotelsPage>());
  });
}
