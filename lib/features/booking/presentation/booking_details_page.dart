import 'package:flutter/material.dart';
import 'booking_view_model.dart';

class BookingDetailsPage extends StatelessWidget {
  const BookingDetailsPage({super.key, required this.viewModel});
  final BookingViewModel viewModel;
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الحجز')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Text('الوصول: ${viewModel.checkIn}'),
        Text('المغادرة: ${viewModel.checkOut}'),
        Text('الليالي: ${viewModel.nights}'),
        Text('الغرف: ${viewModel.rooms}'),
        Text('البالغون: ${viewModel.adults}'),
        Text('الأطفال: ${viewModel.children}'),
        ...viewModel.validationMessages.map(Text.new),
        FilledButton(
            onPressed: viewModel.validateBooking, child: const Text('متابعة'))
      ]));
}
