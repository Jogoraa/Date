import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Primary button widget following the app's design system
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.height,
    this.icon,
    this.gradient,
  });

  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final bool isDisabled;
  final double? width;
  final double? height;
  final IconData? icon;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final isEnabled = !isDisabled && !isLoading && onPressed != null;

    Widget child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isLoading)
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          )
        else if (icon != null)
          Icon(
            icon,
            size: AppSpacing.iconSM,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        if ((isLoading || icon != null) && text.isNotEmpty)
          const SizedBox(width: AppSpacing.sm),
        if (text.isNotEmpty)
          Text(
            text,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );

    Widget button = SizedBox(
      width: width,
      height: height ?? AppSpacing.buttonHeight,
      child: gradient != null
          ? Container(
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: AppSpacing.borderRadiusMD,
              ),
              child: ElevatedButton(
                onPressed: isEnabled ? onPressed : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  elevation: 0,
                ),
                child: child,
              ),
            )
          : ElevatedButton(
              onPressed: isEnabled ? onPressed : null,
              child: child,
            ),
    );

    return button;
  }
}

/// Secondary button variant
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.height,
    this.icon,
  });

  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final bool isDisabled;
  final double? width;
  final double? height;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final isEnabled = !isDisabled && !isLoading && onPressed != null;

    return SizedBox(
      width: width,
      height: height ?? AppSpacing.buttonHeight,
      child: OutlinedButton(
        onPressed: isEnabled ? onPressed : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading)
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
              )
            else if (icon != null)
              Icon(
                icon,
                size: AppSpacing.iconSM,
              ),
            if ((isLoading || icon != null) && text.isNotEmpty)
              const SizedBox(width: AppSpacing.sm),
            if (text.isNotEmpty)
              Text(text),
          ],
        ),
      ),
    );
  }
}

/// Text button variant
class AppTextButton extends StatelessWidget {
  const AppTextButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
  });

  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final bool isDisabled;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final isEnabled = !isDisabled && !isLoading && onPressed != null;

    return TextButton(
      onPressed: isEnabled ? onPressed : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLoading)
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            )
          else if (icon != null)
            Icon(
              icon,
              size: AppSpacing.iconSM,
            ),
          if ((isLoading || icon != null) && text.isNotEmpty)
            const SizedBox(width: AppSpacing.xs),
          if (text.isNotEmpty)
            Text(text),
        ],
      ),
    );
  }
}

/// Premium gradient button
class PremiumButton extends StatelessWidget {
  const PremiumButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.height,
    this.icon,
  });

  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final bool isDisabled;
  final double? width;
  final double? height;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      onPressed: onPressed,
      text: text,
      isLoading: isLoading,
      isDisabled: isDisabled,
      width: width,
      height: height,
      icon: icon,
      gradient: const LinearGradient(
        colors: AppColors.premiumGradient,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }
}

/// Elite tier button
class EliteButton extends StatelessWidget {
  const EliteButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.height,
    this.icon,
  });

  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final bool isDisabled;
  final double? width;
  final double? height;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      onPressed: onPressed,
      text: text,
      isLoading: isLoading,
      isDisabled: isDisabled,
      width: width,
      height: height,
      icon: icon,
      gradient: const LinearGradient(
        colors: AppColors.eliteGradient,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }
}
