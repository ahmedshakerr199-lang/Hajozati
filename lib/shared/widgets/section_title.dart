import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    required this.title,
    this.action,
    super.key,
  });

  final String title;
  final String? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.navy,
                fontWeight: FontWeight.w800,
              ),
        ),
        if (action != null)
          Text(
            action!,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.ocean,
                  fontWeight: FontWeight.w700,
                ),
          ),
      ],
    );
  }
}
