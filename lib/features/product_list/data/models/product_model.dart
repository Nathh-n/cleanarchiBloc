class ProductModel {
  final int id;
  final String title;
  final String imageUrl;

  const ProductModel({
    required this.id,
    required this.title,
    required this.imageUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final images = (json['images'] as List?) ?? [];

    String imageUrl = images.isNotEmpty ? images.first.toString() : '';
    // Beberapa data lama Platzi formatnya rusak, contoh:
    // "[\"https://...\"]" (string yang isinya seperti array JSON).
    imageUrl = imageUrl
        .replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll('"', '');

    return ProductModel(
      id: (json['id'] as int?) ?? 0,
      title: (json['title'] as String?) ?? '-',
      imageUrl: imageUrl,
    );
  }
}