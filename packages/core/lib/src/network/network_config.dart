class NetworkConfig {
  // Environment configuration
  static const String environment = String.fromEnvironment(
    'ENV',
    defaultValue: 'dev',
  );

  // Base URLs for different environments
  // Using JSONPlaceholder for testing - replace with your actual API URLs
  static const Map<String, String> _baseUrls = {
    'dev': 'https://jsonplaceholder.typicode.com',
    'staging': 'https://jsonplaceholder.typicode.com',
    'prod': 'https://api.example.com', // Replace with your production API
  };

  static String get baseUrl => _baseUrls[environment] ?? _baseUrls['dev']!;

  // Timeout configuration
  static const int connectTimeoutSeconds = 30;
  static const int receiveTimeoutSeconds = 30;
  static const int sendTimeoutSeconds = 30;

  // Retry configuration
  static const int maxRetries = 3;
  static const int retryDelayMilliseconds = 500;

  // Default headers
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
