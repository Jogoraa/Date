import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/navigation/main_scaffold.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../shared/widgets/primary_button.dart';

/// Discovery page - main swipe interface
class DiscoveryPage extends StatelessWidget {
  const DiscoveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Discover',
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () {
              // TODO: Navigate to filters
            },
            tooltip: 'Filters',
          ),
        ],
      ),
      body: const DiscoveryContent(),
      floatingActionButton: MatchFAB(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Boost feature coming soon!')),
          );
        },
        tooltip: 'Boost',
      ),
    );
  }
}

class DiscoveryContent extends StatelessWidget {
  const DiscoveryContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.explore,
                    size: 120,
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Discovery Coming Soon!',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Start swiping to find amazing people from the Habesha community around the world.',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  PrimaryButton(
                    onPressed: () => context.push(AppRoutes.subscription),
                    text: 'Get Premium',
                    icon: Icons.diamond,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
