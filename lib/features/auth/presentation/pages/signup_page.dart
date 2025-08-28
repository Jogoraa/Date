import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/models/user_profile.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  
  bool _isLoading = false;
  DateTime? _selectedDate;
  Gender? _selectedGender;
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 18 * 365)),
      firstDate: DateTime.now().subtract(const Duration(days: 100 * 365)),
      lastDate: DateTime.now().subtract(const Duration(days: 18 * 365)),
      helpText: 'Select your date of birth',
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the terms and conditions')),
      );
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      // TODO: Implement Supabase signup
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      
      if (mounted) {
        context.go(AppRoutes.onboarding);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign up failed: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPaddingHorizontal,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: AppSpacing.xxl),
                        
                        // Header
                        Text(
                          'Create Account',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Join the Habesha community',
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        
                        // Name field
                        AppTextField(
                          controller: _nameController,
                          label: 'Full Name',
                          hint: 'Enter your full name',
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          validator: Validators.validateName,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        
                        // Email field
                        AppTextField(
                          controller: _emailController,
                          label: 'Email',
                          hint: 'Enter your email address',
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!Validators.isValidEmail(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        
                        // Date of birth field
                        AppTextField(
                          controller: _dobController,
                          label: 'Date of Birth',
                          hint: 'Select your date of birth',
                          readOnly: true,
                          onTap: _selectDate,
                          validator: (value) {
                            if (_selectedDate == null) {
                              return 'Please select your date of birth';
                            }
                            return Validators.validateDateOfBirth(_selectedDate);
                          },
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        
                        // Gender selection
                        Text(
                          'Gender',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Row(
                          children: Gender.values.map((gender) {
                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: AppSpacing.sm),
                                child: InkWell(
                                  onTap: () => setState(() => _selectedGender = gender),
                                  child: Container(
                                    padding: AppSpacing.paddingMD,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: _selectedGender == gender
                                            ? Theme.of(context).primaryColor
                                            : Theme.of(context).colorScheme.outline,
                                      ),
                                      borderRadius: AppSpacing.borderRadiusMD,
                                      color: _selectedGender == gender
                                          ? Theme.of(context).primaryColor.withOpacity(0.1)
                                          : null,
                                    ),
                                    child: Text(
                                      gender.displayName,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: _selectedGender == gender
                                            ? Theme.of(context).primaryColor
                                            : null,
                                        fontWeight: _selectedGender == gender
                                            ? FontWeight.w600
                                            : null,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        
                        // Password field
                        AppTextField(
                          controller: _passwordController,
                          label: 'Password',
                          hint: 'Create a strong password',
                          obscureText: true,
                          textInputAction: TextInputAction.next,
                          validator: Validators.validatePassword,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        
                        // Confirm password field
                        AppTextField(
                          controller: _confirmPasswordController,
                          label: 'Confirm Password',
                          hint: 'Confirm your password',
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        
                        // Terms and conditions
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: _agreedToTerms,
                              onChanged: (value) {
                                setState(() => _agreedToTerms = value ?? false);
                              },
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _agreedToTerms = !_agreedToTerms),
                                child: Text.rich(
                                  TextSpan(
                                    text: 'I agree to the ',
                                    style: Theme.of(context).textTheme.bodySmall,
                                    children: [
                                      TextSpan(
                                        text: 'Terms of Service',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      const TextSpan(text: ' and '),
                                      TextSpan(
                                        text: 'Privacy Policy',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        
                        // Sign up button
                        PrimaryButton(
                          onPressed: _handleSignUp,
                          text: 'Create Account',
                          isLoading: _isLoading,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                    ),
                  ),
                ),
                
                // Sign in link
                Padding(
                  padding: AppSpacing.paddingVerticalMD,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      AppTextButton(
                        onPressed: () => context.pop(),
                        text: 'Sign In',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
