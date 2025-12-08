import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Token storage interface for managing authentication tokens
/// Implement this with your preferred storage solution
/// (SharedPreferences, FlutterSecureStorage, Hive, etc.)
abstract class TokenStorage {
  /// Save access token
  Future<void> saveAccessToken(String token);

  /// Save refresh token
  Future<void> saveRefreshToken(String token);

  /// Get access token
  Future<String?> getAccessToken();

  /// Get refresh token
  Future<String?> getRefreshToken();

  /// Clear all tokens
  Future<void> clearTokens();

  /// Check if user is authenticated (has valid token)
  Future<bool> isAuthenticated();

  /// Factory constructor - uses SecureTokenStorage in production
  factory TokenStorage() => SecureTokenStorage();
}

/// Production-ready secure token storage using FlutterSecureStorage
/// Encrypts tokens on device for maximum security
class SecureTokenStorage implements TokenStorage {
  static final SecureTokenStorage _instance = SecureTokenStorage._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  factory SecureTokenStorage() => _instance;

  SecureTokenStorage._internal();

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  @override
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  @override
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  @override
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  @override
  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}

/// Memory-based token storage for testing/development
/// WARNING: Tokens are lost when app restarts
class MemoryTokenStorage implements TokenStorage {
  String? _accessToken;
  String? _refreshToken;

  @override
  Future<void> saveAccessToken(String token) async {
    _accessToken = token;
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    _refreshToken = token;
  }

  @override
  Future<String?> getAccessToken() async {
    return _accessToken;
  }

  @override
  Future<String?> getRefreshToken() async {
    return _refreshToken;
  }

  @override
  Future<void> clearTokens() async {
    _accessToken = null;
    _refreshToken = null;
  }

  @override
  Future<bool> isAuthenticated() async {
    return _accessToken != null && _accessToken!.isNotEmpty;
  }
}
