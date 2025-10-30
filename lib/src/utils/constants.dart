/// App Constants
/// All constant values used throughout the Tapyble application
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  /// Application name
  static const String zAppName = "tapyble";

  /// Base URL for API calls
  static const String zApiBaseURL = "https://app.tapyble.com/";

  /// Default padding value in pixels
  static const double zDefaultPadding = 10;

  /// Default margin value in pixels
  static const double zDefaultMargin = 10;

  /// API timeout duration in seconds
  static const int apiTimeoutSeconds = 30;

  /// Maximum retry attempts for API calls
  static const int maxRetryAttempts = 3;
} 