class UploadResult {
  final String url;
  final String deleteUrl;
  final int sizeInBytes;

  const UploadResult({
    required this.url,
    required this.deleteUrl,
    required this.sizeInBytes,
  });

  factory UploadResult.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return UploadResult(
      url: (data['display_url'] as String?) ?? (data['url'] as String?) ?? '',
      deleteUrl: (data['delete_url'] as String?) ?? '',
      sizeInBytes: (data['size'] as int?) ?? 0,
    );
  }
}