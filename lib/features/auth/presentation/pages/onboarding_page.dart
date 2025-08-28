import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/primary_button.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  final List<OnboardingStep> _steps = [
    OnboardingStep(
      icon: Icons.photo_camera,
      title: 'Add Your Best Photos',
      description: 'Show your authentic self with photos that represent who you are.',
    ),
    OnboardingStep(
      icon: Icons.tune,
      title: 'Set Your Preferences',
      description: 'Tell us what you\'re looking for to find better matches.',
    ),
    OnboardingStep(
      icon: Icons.public,
      title: 'Share Your Culture',
      description: 'Connect with people who share your Habesha heritage and values.',
    ),
    OnboardingStep(
      icon: Icons.verified_user,
      title: 'Stay Safe',
      description: 'Our community guidelines keep everyone safe and respected.',
    ),
    OnboardingStep(
      icon: Icons.favorite,
      title: 'Start Matching!',
      description: 'You\'re all set to meet amazing people in the Habesha community.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentPage < _steps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go(AppRoutes.discovery);
    }
  }

  void _skip() {
    context.go(AppRoutes.discovery);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: AppSpacing.paddingMD,
                child: TextButton(
                  onPressed: _skip,
                  child: const Text('Skip'),
                ),
              ),
            ),
            
            // Page view
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemCount: _steps.length,
                itemBuilder: (context, index) {
                  final step = _steps[index];
                  return Padding(
                    padding: AppSpacing.screenPadding,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            step.icon,
                            size: 60,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        Text(
                          step.title,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          step.description,
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            
            // Progress indicator
            Padding(
              padding: AppSpacing.paddingHorizontalMD,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _steps.length,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == _currentPage
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).primaryColor.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            
            // Continue button
            Padding(
              padding: AppSpacing.screenPaddingHorizontal,
              child: PrimaryButton(
                onPressed: _nextStep,
                text: _currentPage == _steps.length - 1 ? 'Get Started' : 'Continue',
                width: double.infinity,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

class OnboardingStep {
  final IconData icon;
  final String title;
  final String description;

  OnboardingStep({
    required this.icon,
    required this.title,
    required this.description,
  });
}
