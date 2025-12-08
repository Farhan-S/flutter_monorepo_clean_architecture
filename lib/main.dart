import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'core/network/api_exceptions.dart';
import 'core/network/api_response.dart';
// Core imports
import 'core/network/dio_client.dart';
import 'core/services/auth_service.dart';
import 'core/storage/token_storage.dart';

void main() {
  // Initialize network layer with token refresh support
  _initializeNetworkLayer();

  runApp(const MyApp());
}

/// Initialize the network layer with refresh token interceptor
void _initializeNetworkLayer() {
  final dioClient = DioClient();

  // Configure token refresh interceptor
  dioClient.addRefreshTokenInterceptor(
    onRefresh: (refreshToken) async {
      print('🔄 Refreshing token...');

      // Call your refresh token endpoint
      final authService = AuthService();
      final result = await authService.refreshToken(refreshToken);

      return result.when(
        success: (data) {
          print('✅ Token refreshed successfully');
          return {
            'accessToken': data['access_token'] as String,
            'refreshToken': data['refresh_token'] as String? ?? refreshToken,
          };
        },
        failure: (error) {
          print('❌ Token refresh failed: ${error.message}');
          throw error;
        },
      );
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dio Network Layer Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _tokenStorage = TokenStorage();

  bool _isAuthenticated = false;
  bool _isLoading = false;
  String _statusMessage = 'Ready';
  Color _statusColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final isAuth = await _tokenStorage.isAuthenticated();
    setState(() {
      _isAuthenticated = isAuth;
      _statusMessage = isAuth ? '✅ Authenticated' : '🔓 Not authenticated';
      _statusColor = isAuth ? Colors.green : Colors.orange;
    });
  }

  void _setStatus(String message, Color color) {
    setState(() {
      _statusMessage = message;
      _statusColor = color;
    });
  }

  void _setLoading(bool loading) {
    setState(() => _isLoading = loading);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dio Network Layer Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (_isAuthenticated)
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
              onPressed: _handleLogout,
            ),
        ],
      ),
      body: Column(
        children: [
          // Status bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: _statusColor.withOpacity(0.2),
            child: Row(
              children: [
                if (_isLoading)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  Icon(Icons.info_outline, color: _statusColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _statusMessage,
                    style: TextStyle(
                      color: _statusColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSection('Authentication', Icons.lock, [
                    _buildFeatureCard(
                      'Mock Login',
                      'Simulate login with token storage',
                      Icons.login,
                      Colors.blue,
                      _handleMockLogin,
                    ),
                    _buildFeatureCard(
                      'Check Auth Status',
                      'Verify if user is authenticated',
                      Icons.verified_user,
                      Colors.teal,
                      _checkAuthStatus,
                    ),
                    _buildFeatureCard(
                      'Simulate Token Refresh',
                      'Test automatic token refresh',
                      Icons.refresh,
                      Colors.purple,
                      _handleTokenRefresh,
                    ),
                  ]),

                  const SizedBox(height: 24),

                  _buildSection('HTTP Operations', Icons.http, [
                    _buildFeatureCard(
                      'GET Request',
                      'Fetch data from API',
                      Icons.download,
                      Colors.green,
                      _handleGetRequest,
                    ),
                    _buildFeatureCard(
                      'POST Request',
                      'Send data to API',
                      Icons.upload,
                      Colors.orange,
                      _handlePostRequest,
                    ),
                    _buildFeatureCard(
                      'PUT Request',
                      'Update resource',
                      Icons.edit,
                      Colors.indigo,
                      _handlePutRequest,
                    ),
                    _buildFeatureCard(
                      'DELETE Request',
                      'Remove resource',
                      Icons.delete,
                      Colors.red,
                      _handleDeleteRequest,
                    ),
                  ]),

                  const SizedBox(height: 24),

                  _buildSection('Error Handling', Icons.error, [
                    _buildFeatureCard(
                      '404 Not Found',
                      'Trigger NotFoundException',
                      Icons.search_off,
                      Colors.amber,
                      _handle404Error,
                    ),
                    _buildFeatureCard(
                      'Network Error',
                      'Simulate connection failure',
                      Icons.wifi_off,
                      Colors.red,
                      _handleNetworkError,
                    ),
                    _buildFeatureCard(
                      'Timeout Error',
                      'Simulate request timeout',
                      Icons.timer_off,
                      Colors.deepOrange,
                      _handleTimeoutError,
                    ),
                  ]),

                  const SizedBox(height: 24),

                  _buildSection('Advanced Features', Icons.settings, [
                    _buildFeatureCard(
                      'Result Pattern',
                      'Use Result<T> for type-safe handling',
                      Icons.check_circle,
                      Colors.teal,
                      _handleResultPattern,
                    ),
                    _buildFeatureCard(
                      'Request Cancellation',
                      'Cancel ongoing requests',
                      Icons.cancel,
                      Colors.grey,
                      _handleCancellation,
                    ),
                    _buildFeatureCard(
                      'Mock File Upload',
                      'Simulate multipart upload',
                      Icons.upload_file,
                      Colors.deepPurple,
                      _handleFileUpload,
                    ),
                  ]),

                  const SizedBox(height: 24),

                  _buildInfoCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[700]),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildFeatureCard(
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: _isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info, color: Colors.blue[700]),
                const SizedBox(width: 8),
                Text(
                  'About This Demo',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'This demo showcases a production-ready Dio network layer with:\n\n'
              '• Clean Architecture principles\n'
              '• Automatic token refresh with request queuing\n'
              '• Comprehensive error handling\n'
              '• Retry logic with exponential backoff\n'
              '• Secure token storage\n'
              '• Type-safe Result pattern\n'
              '• Request cancellation support\n\n'
              'Check the code for implementation details!',
              style: TextStyle(
                color: Colors.blue[800],
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== Feature Handlers ====================

  Future<void> _handleMockLogin() async {
    _setLoading(true);
    _setStatus('🔐 Logging in...', Colors.blue);

    await Future.delayed(const Duration(seconds: 1));

    // Mock token data
    final mockAccessToken =
        'mock_access_token_${DateTime.now().millisecondsSinceEpoch}';
    final mockRefreshToken =
        'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}';

    await _tokenStorage.saveAccessToken(mockAccessToken);
    await _tokenStorage.saveRefreshToken(mockRefreshToken);

    setState(() {
      _isAuthenticated = true;
    });

    _setLoading(false);
    _setStatus('✅ Login successful! Token saved securely', Colors.green);

    _showSnackBar('Logged in successfully!', Colors.green);
  }

  Future<void> _handleLogout() async {
    _setLoading(true);
    _setStatus('🚪 Logging out...', Colors.orange);

    await _tokenStorage.clearTokens();

    setState(() {
      _isAuthenticated = false;
    });

    _setLoading(false);
    _setStatus('🔓 Logged out successfully', Colors.orange);

    _showSnackBar('Logged out successfully!', Colors.orange);
  }

  Future<void> _handleTokenRefresh() async {
    _setLoading(true);
    _setStatus('🔄 Simulating token refresh...', Colors.purple);

    final refreshToken = await _tokenStorage.getRefreshToken();

    if (refreshToken == null) {
      _setLoading(false);
      _setStatus('❌ No refresh token found', Colors.red);
      _showSnackBar('Please login first', Colors.red);
      return;
    }

    await Future.delayed(const Duration(seconds: 1));

    final newAccessToken =
        'refreshed_token_${DateTime.now().millisecondsSinceEpoch}';
    await _tokenStorage.saveAccessToken(newAccessToken);

    _setLoading(false);
    _setStatus('✅ Token refreshed successfully', Colors.green);
    _showSnackBar('Token refreshed!', Colors.green);
  }

  Future<void> _handleGetRequest() async {
    _setLoading(true);
    _setStatus('📥 Making GET request...', Colors.green);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      _setLoading(false);
      _setStatus('✅ GET request successful', Colors.green);
      _showSnackBar('GET request completed!', Colors.green);
    } on ApiException catch (e) {
      _setLoading(false);
      _setStatus('❌ Error: ${e.message}', Colors.red);
      _showSnackBar(e.message, Colors.red);
    }
  }

  Future<void> _handlePostRequest() async {
    _setLoading(true);
    _setStatus('📤 Making POST request...', Colors.orange);

    try {
      await Future.delayed(const Duration(seconds: 1));

      _setLoading(false);
      _setStatus('✅ POST request successful', Colors.green);
      _showSnackBar('POST request completed!', Colors.green);
    } on ApiException catch (e) {
      _setLoading(false);
      _setStatus('❌ Error: ${e.message}', Colors.red);
      _showSnackBar(e.message, Colors.red);
    }
  }

  Future<void> _handlePutRequest() async {
    _setLoading(true);
    _setStatus('✏️ Making PUT request...', Colors.indigo);

    try {
      await Future.delayed(const Duration(seconds: 1));

      _setLoading(false);
      _setStatus('✅ PUT request successful', Colors.green);
      _showSnackBar('PUT request completed!', Colors.green);
    } on ApiException catch (e) {
      _setLoading(false);
      _setStatus('❌ Error: ${e.message}', Colors.red);
      _showSnackBar(e.message, Colors.red);
    }
  }

  Future<void> _handleDeleteRequest() async {
    _setLoading(true);
    _setStatus('🗑️ Making DELETE request...', Colors.red);

    try {
      await Future.delayed(const Duration(seconds: 1));

      _setLoading(false);
      _setStatus('✅ DELETE request successful', Colors.green);
      _showSnackBar('DELETE request completed!', Colors.green);
    } on ApiException catch (e) {
      _setLoading(false);
      _setStatus('❌ Error: ${e.message}', Colors.red);
      _showSnackBar(e.message, Colors.red);
    }
  }

  Future<void> _handle404Error() async {
    _setLoading(true);
    _setStatus('🔍 Triggering 404 error...', Colors.amber);

    try {
      await Future.delayed(const Duration(milliseconds: 800));
      throw NotFoundException('Resource not found at /api/v1/nonexistent');
    } on NotFoundException catch (e) {
      _setLoading(false);
      _setStatus('✅ Caught NotFoundException: ${e.message}', Colors.amber);
      _showSnackBar('404 error handled correctly!', Colors.amber);
    }
  }

  Future<void> _handleNetworkError() async {
    _setLoading(true);
    _setStatus('📡 Simulating network error...', Colors.red);

    try {
      await Future.delayed(const Duration(milliseconds: 800));
      throw NetworkException(
        'Unable to connect to server. Check your internet.',
      );
    } on NetworkException catch (e) {
      _setLoading(false);
      _setStatus('✅ Caught NetworkException: ${e.message}', Colors.red);
      _showSnackBar('Network error handled correctly!', Colors.orange);
    }
  }

  Future<void> _handleTimeoutError() async {
    _setLoading(true);
    _setStatus('⏱️ Simulating timeout...', Colors.deepOrange);

    try {
      await Future.delayed(const Duration(milliseconds: 800));
      throw TimeoutException('Request timed out after 30 seconds');
    } on TimeoutException catch (e) {
      _setLoading(false);
      _setStatus('✅ Caught TimeoutException: ${e.message}', Colors.deepOrange);
      _showSnackBar('Timeout error handled correctly!', Colors.orange);
    }
  }

  Future<void> _handleResultPattern() async {
    _setLoading(true);
    _setStatus('🎯 Demonstrating Result pattern...', Colors.teal);

    await Future.delayed(const Duration(seconds: 1));

    // Simulate a Result
    final Result<Map<String, dynamic>> result = Success({
      'id': '123',
      'name': 'John Doe',
      'email': 'john@example.com',
    });

    result.when(
      success: (data) {
        _setLoading(false);
        _setStatus('✅ Success! User: ${data['name']}', Colors.green);
        _showSnackBar('Result pattern demo successful!', Colors.teal);
      },
      failure: (error) {
        _setLoading(false);
        _setStatus('❌ Error: ${error.message}', Colors.red);
      },
    );
  }

  Future<void> _handleCancellation() async {
    final cancelToken = CancelToken();

    _setLoading(true);
    _setStatus('⏸️ Starting cancellable request...', Colors.grey);

    // Start request
    Future.delayed(const Duration(seconds: 2)).then((_) {
      if (!cancelToken.isCancelled) {
        _setLoading(false);
        _setStatus('✅ Request completed', Colors.green);
      }
    });

    // Cancel after 1 second
    await Future.delayed(const Duration(seconds: 1));
    cancelToken.cancel('Demo cancellation');

    _setLoading(false);
    _setStatus('✅ Request cancelled successfully', Colors.orange);
    _showSnackBar('Request cancelled!', Colors.orange);
  }

  Future<void> _handleFileUpload() async {
    _setLoading(true);
    _setStatus('📤 Simulating file upload...', Colors.deepPurple);

    // Simulate progress
    for (int i = 0; i <= 100; i += 20) {
      await Future.delayed(const Duration(milliseconds: 200));
      _setStatus('📤 Uploading... $i%', Colors.deepPurple);
    }

    _setLoading(false);
    _setStatus('✅ File uploaded successfully', Colors.green);
    _showSnackBar('File upload completed!', Colors.green);
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
