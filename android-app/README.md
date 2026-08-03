# حجوزاتي | Android

تطبيق Android عربي لحجز الفنادق والشقق السياحية داخل العراق، مبني بـ Kotlin وJetpack Compose وMaterial 3.

## التشغيل

افتح مجلد `android-app` في Android Studio ثم نفّذ Gradle Sync وشغّل وحدة `app` على Android 7.0 (API 24) أو أحدث.

يمكن ضبط عنوان خدمة API من دون تضمين أسرار في المستودع:

```properties
# ~/.gradle/gradle.properties أو gradle.properties المحلي غير المتعقّب
API_BASE_URL=https://api.your-domain.example/
```

لا توجد خدمة خلفية في هذه المرحلة؛ القيمة الافتراضية غير قابلة للاستخدام عمداً، وتعرض الواجهة بيانات Mock محلية فقط.

## الطبقات

- `core`: أساسيات الشبكة؛ HTTPS فقط، نقطة جاهزة لـ Auth وCertificate Pinning.
- `common`: حالات الواجهة المشتركة.
- `designsystem`: مكونات Compose والتباعد المشترك.
- `data`: Mock وRoom والمستودعات.
- `domain`: النماذج والعقود وحالات الاستخدام.
- `presentation`: الشاشات وViewModel والثيم.
- `navigation`, `di`, `utils`: التنقل والحقن والتحقق من المدخلات.

## ما هو جاهز

Theme ضوئي كامل بألوان العلامة، splash، شريط تنقل سفلي، الرئيسية والبحث والحجوزات والحساب، Hilt، Room، Retrofit/OkHttp، Coroutines/Flow وCoil. لا يُسجل العميل أجسام الطلبات أو الترويسات، ولا يحتوي المشروع على مفاتيح API أو أسرار.
