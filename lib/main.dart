import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/theme/app_theme.dart';
import 'app/navigation/app_router.dart';
import 'features/splash/presentation/pages/splash_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Bound decoded-image memory while thumbnail cache sizes preserve scroll reuse.
  PaintingBinding.instance.imageCache.maximumSize = 250;
  PaintingBinding.instance.imageCache.maximumSizeBytes = 60 << 20;
  runApp(const HajozatiApp());
}

class HajozatiApp extends StatelessWidget {
  const HajozatiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'حجوزاتي',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child ?? const SizedBox.shrink(),
      ),
      home: const SplashPage(),
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
