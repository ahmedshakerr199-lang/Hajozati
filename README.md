# حجوزاتي

حجوزاتي تطبيق حجوزات فنادق وشقق سياحية داخل العراق، مبني باستخدام **Flutter** لاستهداف Android وiOS من قاعدة كود واحدة.

## البنية

- `lib/core`: الثيم، الثوابت، والأساسيات المشتركة.
- `lib/features/hotels`: نماذج النطاق، العقود، بيانات Mock، والمستودع.
- `lib/features/home`: واجهة Home وViewModel وفق MVVM.
- `assets/fonts`: خطوط Cairo وTajawal المحلية.
- `test`: اختبارات Flutter.

طبقة Flutter هي المصدر الرسمي للتطوير. لا يحتوي المشروع على مفاتيح API أو Backend أو تسجيل دخول أو دفع في هذه المرحلة.

## التشغيل

شغّل التطبيق من مشروع Flutter الرئيسي:

```bash
flutter pub get
flutter run
```

المجلدان `android/` و`ios/` هما منصتا Flutter الرسميتان. لا يوجد مشروع Android Native مستقل معتمد.
