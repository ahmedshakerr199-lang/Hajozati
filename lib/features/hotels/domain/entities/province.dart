class Province {
  const Province({required this.id, required this.nameAr, required this.nameEn, required this.hotelsCount, this.isFeatured = false});
  final String id, nameAr, nameEn;
  final int hotelsCount;
  final bool isFeatured;
}
