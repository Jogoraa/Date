import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/navigation/main_scaffold.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../shared/widgets/primary_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profile',
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person,
                size: 120,
                color: Theme.of(context).primaryColor.withOpacity(0.3),
              ),
              const SizedBox(height: 24),
              Text(
                'Your Profile',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Text(
                'Complete your profile to start meeting amazing people.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                onPressed: () => context.push(AppRoutes.editProfile),
                text: 'Edit Profile',
                icon: Icons.edit,
              ),
              const SizedBox(height: 16),
              SecondaryButton(
                onPressed: () => context.push(AppRoutes.subscription),
                text: 'Upgrade to Premium',
                icon: Icons.diamond,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
