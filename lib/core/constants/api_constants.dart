class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.escuelajs.co/api/v1';

  // Auth
  static const String login = '/auth/login';
  static const String refreshToken = '/auth/refresh-token';
  static const String profile = '/auth/profile';

  // Products (lazy load)
  static const String products = '/products';

  // ImgBB
  static const String imgbbBaseUrl = 'https://api.imgbb.com/1/upload';
  static const String imgbbApiKey = '8df53c18cf344c165b7f57f8a00669a3';
}
