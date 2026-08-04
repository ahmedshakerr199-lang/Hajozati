import 'package:flutter/material.dart';
import 'booking_view_model.dart';

class BookingSummaryPage extends StatelessWidget {
  const BookingSummaryPage({super.key, required this.viewModel});
  final BookingViewModel viewModel;
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('ملخص الحجز')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Text('الفندق: ${viewModel.booking?.hotelId ?? ''}'),
        Text('الليالي: ${viewModel.nights}'),
        Text('الضيوف: ${viewModel.adults + viewModel.children}'),
        Text('Subtotal: ${viewModel.subtotal}'),
        Text('Taxes: ${viewModel.taxes}'),
        Text('Discount: ${viewModel.discount}'),
        Text('Grand Total: ${viewModel.grandTotal}'),
        FilledButton(
            onPressed: viewModel.confirmBooking,
            child: const Text('تأكيد الحجز'))
      ]));
}
