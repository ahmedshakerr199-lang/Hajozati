import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';

/// A branded surface with the standard Hajozati radius and quiet elevation.
class HajozatiCard extends StatelessWidget {
  const HajozatiCard(
      {super.key, required this.child, this.padding, this.onTap, this.color});
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) => Material(
        color: color ?? AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.card),
          child: Container(
            padding: padding ?? const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.card),
                boxShadow: AppShadows.card),
            child: child,
          ),
        ),
      );
}

/// Standard section title with an optional action.
class SectionHeader extends StatelessWidget {
  const SectionHeader(
      {super.key, required this.title, this.actionLabel, this.onAction});
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  @override
  Widget build(BuildContext context) => Row(children: [
        Expanded(
            child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
        if (actionLabel != null)
          TextButton(onPressed: onAction, child: Text(actionLabel!)),
      ]);
}

/// Reusable empty, loading and error treatments rather than bare text screens.
class HajozatiStateView extends StatelessWidget {
  const HajozatiStateView.loading({super.key})
      : kind = HajozatiStateKind.loading,
        message = null,
        actionLabel = null,
        onAction = null;
  const HajozatiStateView.empty(
      {super.key,
      required String this.message,
      this.actionLabel,
      this.onAction})
      : kind = HajozatiStateKind.empty;
  const HajozatiStateView.error(
      {super.key,
      required String this.message,
      this.actionLabel = 'إعادة المحاولة',
      this.onAction})
      : kind = HajozatiStateKind.error;
  final HajozatiStateKind kind;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  @override
  Widget build(BuildContext context) {
    if (kind == HajozatiStateKind.loading) return const _Skeleton();
    final icon = kind == HajozatiStateKind.error
        ? Icons.cloud_off_rounded
        : Icons.luggage_rounded;
    return Center(
        child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              CircleAvatar(
                  radius: 34,
                  backgroundColor: kind == HajozatiStateKind.error
                      ? AppColors.softAccent
                      : AppColors.softPrimary,
                  child: Icon(icon,
                      color: kind == HajozatiStateKind.error
                          ? AppColors.accent
                          : AppColors.primary,
                      size: 32)),
              const SizedBox(height: AppSpacing.md),
              Text(message!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium),
              if (onAction != null) ...[
                const SizedBox(height: AppSpacing.md),
                FilledButton(onPressed: onAction, child: Text(actionLabel!))
              ],
            ])));
  }
}

enum HajozatiStateKind { loading, empty, error }

class _Skeleton extends StatelessWidget {
  const _Skeleton();
  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(AppSpacing.page),
        children: List.generate(
          4,
          (index) => Container(
            height: index == 0 ? 170 : 86,
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(AppRadius.card),
            ),
          ),
        ),
      );
}

/// Network image with a brand-aligned fallback, safe for all mock and future URLs.
class HajozatiNetworkImage extends StatelessWidget {
  const HajozatiNetworkImage(
      {super.key,
      required this.url,
      required this.fit,
      this.borderRadius = AppRadius.card,
      this.cacheWidth,
      this.cacheHeight});
  final String url;
  final BoxFit fit;
  final double borderRadius;
  final int? cacheWidth;
  final int? cacheHeight;
  @override
  Widget build(BuildContext context) => ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.network(url,
          fit: fit,
          cacheWidth: cacheWidth,
          cacheHeight: cacheHeight,
          filterQuality: FilterQuality.low,
          errorBuilder: (_, __, ___) => const ColoredBox(
              color: AppColors.softPrimary,
              child: Center(
                  child: Icon(Icons.hotel_rounded,
                      color: AppColors.primary, size: 34))),
          loadingBuilder: (context, child, progress) => progress == null
              ? child
              : const ColoredBox(color: AppColors.border)));
}

/// Compact hotel preview shared by discovery and search result lists.
class HotelPreviewCard extends StatelessWidget {
  const HotelPreviewCard(
      {super.key,
      required this.name,
      required this.location,
      required this.price,
      required this.rating,
      required this.imageUrl,
      this.onTap,
      this.badge});
  final String name, location, price, imageUrl;
  final double rating;
  final VoidCallback? onTap;
  final String? badge;
  @override
  Widget build(BuildContext context) => HajozatiCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 280) {
          return Column(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(
                height: 92,
                width: double.infinity,
                child: Stack(fit: StackFit.expand, children: [
                  HajozatiNetworkImage(
                      url: imageUrl,
                      fit: BoxFit.cover,
                      cacheWidth: 232,
                      cacheHeight: 184),
                  if (badge != null)
                    Positioned(top: 8, right: 8, child: _Badge(label: badge!))
                ])),
            Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w800)),
                      Text(location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: AppColors.muted)),
                      const SizedBox(height: AppSpacing.xs),
                      Row(children: [
                        const Icon(Icons.star_rounded,
                            color: AppColors.warning, size: 17),
                        Text(' ${rating.toStringAsFixed(1)}'),
                        const Spacer(),
                        Flexible(
                            child: Text(price,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.w800)))
                      ])
                    ]))
          ]);
        }
        return SizedBox(
            height: 124,
            child: Row(children: [
              SizedBox(
                  width: 116,
                  height: 124,
                  child: Stack(fit: StackFit.expand, children: [
                    HajozatiNetworkImage(
                        url: imageUrl,
                        fit: BoxFit.cover,
                        cacheWidth: 232,
                        cacheHeight: 248),
                    if (badge != null)
                      Positioned(top: 8, right: 8, child: _Badge(label: badge!))
                  ])),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.w800)),
                            const SizedBox(height: 4),
                            Text(location,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: AppColors.muted)),
                            const SizedBox(height: AppSpacing.sm),
                            Row(children: [
                              const Icon(Icons.star_rounded,
                                  color: AppColors.warning, size: 18),
                              Text(' ${rating.toStringAsFixed(1)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700)),
                              const SizedBox(width: AppSpacing.xs),
                              Expanded(
                                  child: Text(price,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.end,
                                      style: const TextStyle(
                                          color: AppColors.accent,
                                          fontWeight: FontWeight.w800)))
                            ]),
                          ]))),
            ]));
      }));
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(AppRadius.pill)),
      child: Text(label,
          style: const TextStyle(
              color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)));
}
