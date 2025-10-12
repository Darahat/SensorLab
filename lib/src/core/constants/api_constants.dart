/// A class containing the endpoints for the API.
class ApiEndPoints {
  ///Base URL is already set in your dio_provider.dart
  /// So, We only need the specific paths here
  ///
  /// Example for fetching products
  static const String products = '/products';

  ///Example for fetching a single product by its ID
  static String productById(int id) => '/products/$id';

  /// Example for fetching todos
  static const String todos = '/todos';
}
