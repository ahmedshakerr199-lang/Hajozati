import 'package:flutter_test/flutter_test.dart';
import 'package:hajozati/features/explore/presentation/pages/destination_details_page.dart';

void main() {
  test('destination details page accepts an id', () {
    const page = DestinationDetailsPage(destinationId: 'ur-ziggurat');
    expect(page.destinationId, 'ur-ziggurat');
  });
}
