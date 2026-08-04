import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../app/navigation/app_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
    _navigationTimer = Timer(const Duration(milliseconds: 2400), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      }
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [AppColors.primary, AppColors.text, AppColors.accent],
          ),
        ),
        child: Stack(
          children: [
            const _DecorativeWaves(),
            Center(
              child: FadeTransition(
                opacity:
                    CurvedAnimation(parent: _controller, curve: Curves.easeOut),
                child: ScaleTransition(
                  scale: Tween<double>(begin: .78, end: 1).animate(
                    CurvedAnimation(
                        parent: _controller, curve: Curves.elasticOut),
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _CompassLogo(),
                      SizedBox(height: 24),
                      Text(
                        AppStrings.appName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        AppStrings.tagline,
                        style:
                            TextStyle(color: Color(0xFFD7F7F1), fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Positioned(
              bottom: 52,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                      color: Colors.white70, strokeWidth: 2.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompassLogo extends StatelessWidget {
  const _CompassLogo();

  @override
  Widget build(BuildContext context) => Container(
        width: 106,
        height: 106,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .14),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white54, width: 1.5),
        ),
        child: const Icon(Icons.explore_rounded,
            size: 60, color: AppColors.warning),
      );
}

class _DecorativeWaves extends StatelessWidget {
  const _DecorativeWaves();

  @override
  Widget build(BuildContext context) => Positioned(
        bottom: -90,
        left: -60,
        right: -60,
        child: Container(
          height: 230,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .08),
            borderRadius: BorderRadius.circular(160),
          ),
        ),
      );
}
