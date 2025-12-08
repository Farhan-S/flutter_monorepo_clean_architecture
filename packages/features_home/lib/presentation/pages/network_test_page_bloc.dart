import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/network_test_entity.dart';
import '../bloc/network_test_bloc.dart';
import '../bloc/network_test_event.dart';
import '../bloc/network_test_state.dart';

/// Network testing page using BLoC pattern
class NetworkTestPage extends StatelessWidget {
  const NetworkTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Layer Test'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<NetworkTestBloc, NetworkTestState>(
        builder: (context, state) {
          return Column(
            children: [
              // Test Controls
              _buildControls(context, state),

              // Results Display
              Expanded(child: _buildResults(state)),

              // Summary
              if (state is NetworkTestComplete) _buildSummary(state.testSuite),
            ],
          );
        },
      ),
    );
  }

  Widget _buildControls(BuildContext context, NetworkTestState state) {
    final isRunning = state is NetworkTestRunning;

    return Container(
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
                  onPressed: isRunning
                      ? null
                      : () {
                          context.read<NetworkTestBloc>().add(
                            const RunAllNetworkTestsEvent(),
                          );
                        },
                  icon: isRunning
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.play_arrow),
                  label: Text(isRunning ? 'Testing...' : 'Run All Tests'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: state is NetworkTestInitial
                    ? null
                    : () {
                        context.read<NetworkTestBloc>().add(
                          const ClearNetworkTestsEvent(),
                        );
                      },
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
    );
  }

  Widget _buildResults(NetworkTestState state) {
    if (state is NetworkTestInitial) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.network_check, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Press "Run All Tests" to start',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (state is NetworkTestError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error: ${state.message}',
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    List<NetworkTestEntity> results = [];
    if (state is NetworkTestRunning) {
      results = state.currentResults;
    } else if (state is NetworkTestComplete) {
      results = state.testSuite.results;
    }

    if (results.isEmpty && state is NetworkTestRunning) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        return _buildResultCard(result);
      },
    );
  }

  Widget _buildResultCard(NetworkTestEntity result) {
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

  Widget _buildSummary(NetworkTestSuiteEntity testSuite) {
    return Container(
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem('Total', testSuite.totalTests, Colors.blue),
          _buildSummaryItem('Passed', testSuite.passedTests, Colors.green),
          _buildSummaryItem('Failed', testSuite.failedTests, Colors.red),
        ],
      ),
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
}
