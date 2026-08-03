import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/hotel.dart';

class HotelCard extends StatelessWidget {
  const HotelCard({required this.hotel, super.key});

  final Hotel hotel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 246,
      margin: const EdgeInsetsDirectional.only(end: 16),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(color: Color(0x160F3554), blurRadius: 18, offset: Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Color(hotel.color), Color(hotel.color).withOpacity(.62)],
                    ),
                  ),
                  child: const Align(
                    alignment: Alignment.bottomCenter,
                    child: Icon(Icons.apartment_rounded, color: Colors.white30, size: 108),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.92),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 17, color: AppColors.gold),
                        const SizedBox(width: 3),
                        Text('${hotel.rating}', style: const TextStyle(fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                ),
                const Positioned(
                  bottom: 14,
                  left: 14,
                  child: Icon(Icons.favorite_border_rounded, color: Colors.white, size: 25),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 13, 16, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(hotel.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.navy)),
                const SizedBox(height: 5),
                Row(children: [
                  const Icon(Icons.location_on_outlined, size: 16, color: AppColors.ocean),
                  const SizedBox(width: 3),
                  Text(hotel.location, style: const TextStyle(fontSize: 12, color: Color(0xFF627D98))),
                ]),
                const SizedBox(height: 11),
                RichText(text: TextSpan(
                  style: const TextStyle(color: AppColors.ocean, fontWeight: FontWeight.w800, fontFamily: 'Arial'),
                  children: [TextSpan(text: '${hotel.price} ر.س '), const TextSpan(text: '/ ليلة', style: TextStyle(color: Color(0xFF627D98), fontSize: 12, fontWeight: FontWeight.w400))],
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
