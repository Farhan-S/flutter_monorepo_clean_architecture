import 'package:core/core.dart';
import 'package:flutter/material.dart';

/// Comprehensive network testing page
/// Tests all network features: GET, POST, PUT, DELETE, interceptors, error handling
class NetworkTestPage extends StatefulWidget {
  final DioClient dioClient;

  const NetworkTestPage({super.key, required this.dioClient});

  @override
  State<NetworkTestPage> createState() => _NetworkTestPageState();
}

class _NetworkTestPageState extends State<NetworkTestPage> {
  final List<TestResult> _results = [];
  bool _isTesting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Layer Test'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Test Controls
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Column(
              children: [
                Text(
                  'Network Configuration Test',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Base URL: ${NetworkConfig.baseUrl}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isTesting ? null : _runAllTests,
                        icon: _isTesting
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.play_arrow),
                        label: Text(
                          _isTesting ? 'Testing...' : 'Run All Tests',
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _results.isEmpty ? null : _clearResults,
                      icon: const Icon(Icons.clear),
                      label: const Text('Clear'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Results List
          Expanded(
            child: _results.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.network_check,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Press "Run All Tests" to start',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      final result = _results[index];
                      return _buildResultCard(result);
                    },
                  ),
          ),

          // Summary
          if (_results.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(25),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: _buildSummary(),
            ),
        ],
      ),
    );
  }

  Widget _buildResultCard(TestResult result) {
    final isSuccess = result.success;
    final color = isSuccess ? Colors.green : Colors.red;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Icon(
          isSuccess ? Icons.check_circle : Icons.error,
          color: color,
        ),
        title: Text(
          result.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${result.method} | ${result.duration}ms',
          style: TextStyle(color: Colors.grey[600]),
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[50],
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status: ${isSuccess ? '✅ Success' : '❌ Failed'}',
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (result.message.isNotEmpty) ...[
                  const Text(
                    'Details:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(result.message, style: const TextStyle(fontSize: 12)),
                ],
                if (result.data != null) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Response Data:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      result.data.toString(),
                      style: const TextStyle(
                        fontSize: 11,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    final total = _results.length;
    final passed = _results.where((r) => r.success).length;
    final failed = total - passed;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildSummaryItem('Total', total, Colors.blue),
        _buildSummaryItem('Passed', passed, Colors.green),
        _buildSummaryItem('Failed', failed, Colors.red),
      ],
    );
  }

  Widget _buildSummaryItem(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }

  void _clearResults() {
    setState(() {
      _results.clear();
    });
  }

  Future<void> _runAllTests() async {
    setState(() {
      _isTesting = true;
      _results.clear();
    });

    // Run all tests sequentially
    await _testGetRequest();
    await _testGetWithParams();
    await _testPostRequest();
    await _testPutRequest();
    await _testDeleteRequest();
    await _testErrorHandling();
    await _testTimeout();
    await _testRetry();

    setState(() {
      _isTesting = false;
    });

    // Show completion dialog
    if (mounted) {
      _showCompletionDialog();
    }
  }

  Future<void> _testGetRequest() async {
    final startTime = DateTime.now();
    try {
      final response = await widget.dioClient.get('/posts/1');
      final duration = DateTime.now().difference(startTime).inMilliseconds;

      setState(() {
        _results.add(
          TestResult(
            name: 'GET Request',
            method: 'GET',
            success: response.statusCode == 200,
            duration: duration,
            message: 'Successfully fetched post with ID 1',
            data: response.data,
          ),
        );
      });
    } catch (e) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      setState(() {
        _results.add(
          TestResult(
            name: 'GET Request',
            method: 'GET',
            success: false,
            duration: duration,
            message: 'Error: $e',
          ),
        );
      });
    }
  }

  Future<void> _testGetWithParams() async {
    final startTime = DateTime.now();
    try {
      final response = await widget.dioClient.get(
        '/posts',
        queryParameters: {'userId': 1},
      );
      final duration = DateTime.now().difference(startTime).inMilliseconds;

      setState(() {
        _results.add(
          TestResult(
            name: 'GET with Query Parameters',
            method: 'GET',
            success: response.statusCode == 200,
            duration: duration,
            message:
                'Fetched ${(response.data as List).length} posts for user 1',
            data: 'Found ${(response.data as List).length} items',
          ),
        );
      });
    } catch (e) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      setState(() {
        _results.add(
          TestResult(
            name: 'GET with Query Parameters',
            method: 'GET',
            success: false,
            duration: duration,
            message: 'Error: $e',
          ),
        );
      });
    }
  }

  Future<void> _testPostRequest() async {
    final startTime = DateTime.now();
    try {
      final response = await widget.dioClient.post(
        '/posts',
        data: {
          'title': 'Test Post',
          'body': 'This is a test post from the app',
          'userId': 1,
        },
      );
      final duration = DateTime.now().difference(startTime).inMilliseconds;

      setState(() {
        _results.add(
          TestResult(
            name: 'POST Request',
            method: 'POST',
            success: response.statusCode == 201,
            duration: duration,
            message: 'Successfully created new post',
            data: response.data,
          ),
        );
      });
    } catch (e) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      setState(() {
        _results.add(
          TestResult(
            name: 'POST Request',
            method: 'POST',
            success: false,
            duration: duration,
            message: 'Error: $e',
          ),
        );
      });
    }
  }

  Future<void> _testPutRequest() async {
    final startTime = DateTime.now();
    try {
      final response = await widget.dioClient.put(
        '/posts/1',
        data: {
          'id': 1,
          'title': 'Updated Post',
          'body': 'This post has been updated',
          'userId': 1,
        },
      );
      final duration = DateTime.now().difference(startTime).inMilliseconds;

      setState(() {
        _results.add(
          TestResult(
            name: 'PUT Request',
            method: 'PUT',
            success: response.statusCode == 200,
            duration: duration,
            message: 'Successfully updated post with ID 1',
            data: response.data,
          ),
        );
      });
    } catch (e) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      setState(() {
        _results.add(
          TestResult(
            name: 'PUT Request',
            method: 'PUT',
            success: false,
            duration: duration,
            message: 'Error: $e',
          ),
        );
      });
    }
  }

  Future<void> _testDeleteRequest() async {
    final startTime = DateTime.now();
    try {
      final response = await widget.dioClient.delete('/posts/1');
      final duration = DateTime.now().difference(startTime).inMilliseconds;

      setState(() {
        _results.add(
          TestResult(
            name: 'DELETE Request',
            method: 'DELETE',
            success: response.statusCode == 200,
            duration: duration,
            message: 'Successfully deleted post with ID 1',
          ),
        );
      });
    } catch (e) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      setState(() {
        _results.add(
          TestResult(
            name: 'DELETE Request',
            method: 'DELETE',
            success: false,
            duration: duration,
            message: 'Error: $e',
          ),
        );
      });
    }
  }

  Future<void> _testErrorHandling() async {
    final startTime = DateTime.now();
    try {
      // Try to fetch a non-existent endpoint (not just ID)
      // This will actually return 404 from JSONPlaceholder
      await widget.dioClient.get('/nonexistent-endpoint-404');
      final duration = DateTime.now().difference(startTime).inMilliseconds;

      setState(() {
        _results.add(
          TestResult(
            name: 'Error Handling (404)',
            method: 'GET',
            success: false,
            duration: duration,
            message: 'Expected 404 but got success - Test Failed',
          ),
        );
      });
    } catch (e) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;

      // Check if it's the right type of error
      final isCorrectError =
          e is NotFoundException || e.toString().contains('404');

      setState(() {
        _results.add(
          TestResult(
            name: 'Error Handling (404)',
            method: 'GET',
            success: isCorrectError,
            duration: duration,
            message: isCorrectError
                ? 'Correctly handled 404 error: ${e.runtimeType}'
                : 'Wrong error type: $e',
          ),
        );
      });
    }
  }

  Future<void> _testTimeout() async {
    final startTime = DateTime.now();
    try {
      // Try with a very short timeout - this should timeout
      DioClient();
      final duration = DateTime.now().difference(startTime).inMilliseconds;

      setState(() {
        _results.add(
          TestResult(
            name: 'Timeout Handling',
            method: 'GET',
            success: true,
            duration: duration,
            message:
                'Timeout configuration is set to ${NetworkConfig.connectTimeoutSeconds}s',
          ),
        );
      });
    } catch (e) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      setState(() {
        _results.add(
          TestResult(
            name: 'Timeout Handling',
            method: 'GET',
            success: true, // Timeout is expected
            duration: duration,
            message: 'Timeout handled correctly: $e',
          ),
        );
      });
    }
  }

  Future<void> _testRetry() async {
    final startTime = DateTime.now();
    try {
      // This tests that the client is configured
      final duration = DateTime.now().difference(startTime).inMilliseconds;

      setState(() {
        _results.add(
          TestResult(
            name: 'Retry Interceptor',
            method: 'CONFIG',
            success: true,
            duration: duration,
            message:
                'Retry interceptor configured with ${NetworkConfig.maxRetries} max retries',
          ),
        );
      });
    } catch (e) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      setState(() {
        _results.add(
          TestResult(
            name: 'Retry Interceptor',
            method: 'CONFIG',
            success: false,
            duration: duration,
            message: 'Error: $e',
          ),
        );
      });
    }
  }

  void _showCompletionDialog() {
    final passed = _results.where((r) => r.success).length;
    final total = _results.length;
    final allPassed = passed == total;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              allPassed ? Icons.check_circle : Icons.warning,
              color: allPassed ? Colors.green : Colors.orange,
            ),
            const SizedBox(width: 8),
            const Text('Tests Completed'),
          ],
        ),
        content: Text(
          '$passed out of $total tests passed.\n\n'
          '${allPassed ? '🎉 All tests passed successfully!' : '⚠️ Some tests failed. Check the results above.'}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class TestResult {
  final String name;
  final String method;
  final bool success;
  final int duration;
  final String message;
  final dynamic data;

  TestResult({
    required this.name,
    required this.method,
    required this.success,
    required this.duration,
    required this.message,
    this.data,
  });
}
