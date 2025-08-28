import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Profile photo widget with various styles and states
class ProfilePhoto extends StatelessWidget {
  const ProfilePhoto({
    super.key,
    required this.imageUrl,
    this.size = AppSpacing.avatarMD,
    this.isOnline,
    this.isVerified = false,
    this.onTap,
    this.heroTag,
    this.borderRadius,
  });

  final String? imageUrl;
  final double size;
  final bool? isOnline;
  final bool isVerified;
  final VoidCallback? onTap;
  final String? heroTag;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    Widget photoWidget = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(size / 2),
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(size / 2),
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: Icon(
                    Icons.person,
                    size: size * 0.5,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              )
            : Container(
                color: Theme.of(context).colorScheme.surface,
                child: Icon(
                  Icons.person,
                  size: size * 0.5,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
      ),
    );

    // Add hero animation if heroTag is provided
    if (heroTag != null) {
      photoWidget = Hero(
        tag: heroTag!,
        child: photoWidget,
      );
    }

    // Add tap gesture if onTap is provided
    if (onTap != null) {
      photoWidget = GestureDetector(
        onTap: onTap,
        child: photoWidget,
      );
    }

    return Stack(
      children: [
        photoWidget,
        // Online status indicator
        if (isOnline != null)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: size * 0.3,
              height: size * 0.3,
              decoration: BoxDecoration(
                color: isOnline! ? AppColors.online : AppColors.offline,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.background,
                  width: 2,
                ),
              ),
            ),
          ),
        // Verified badge
        if (isVerified)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: size * 0.3,
              height: size * 0.3,
              decoration: BoxDecoration(
                color: AppColors.verified,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.background,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: size * 0.2,
              ),
            ),
          ),
      ],
    );
  }
}

/// Large profile photo for profile cards
class ProfilePhotoLarge extends StatelessWidget {
  const ProfilePhotoLarge({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.onTap,
    this.heroTag,
    this.showGradient = true,
    this.child,
  });

  final String? imageUrl;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final String? heroTag;
  final bool showGradient;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    Widget photoWidget = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: AppSpacing.borderRadiusLG,
        color: Theme.of(context).colorScheme.surface,
      ),
      child: ClipRRect(
        borderRadius: AppSpacing.borderRadiusLG,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (imageUrl != null && imageUrl!.isNotEmpty)
              CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: Icon(
                    Icons.person,
                    size: 64,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              )
            else
              Container(
                color: Theme.of(context).colorScheme.surface,
                child: Icon(
                  Icons.person,
                  size: 64,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            // Gradient overlay
            if (showGradient)
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.photoOverlay,
                    ],
                    stops: [0.4, 1.0],
                  ),
                ),
              ),
            // Child content (like name/age overlay)
            if (child != null) child!,
          ],
        ),
      ),
    );

    // Add hero animation if heroTag is provided
    if (heroTag != null) {
      photoWidget = Hero(
        tag: heroTag!,
        child: photoWidget,
      );
    }

    // Add tap gesture if onTap is provided
    if (onTap != null) {
      photoWidget = GestureDetector(
        onTap: onTap,
        child: photoWidget,
      );
    }

    return photoWidget;
  }
}

/// Photo placeholder for adding new photos
class PhotoPlaceholder extends StatelessWidget {
  const PhotoPlaceholder({
    super.key,
    required this.onTap,
    this.size = 100,
    this.text = 'Add Photo',
  });

  final VoidCallback onTap;
  final double size;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: AppSpacing.borderRadiusMD,
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
            width: 2,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_a_photo_outlined,
              size: size * 0.3,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              text,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Photo grid widget for profile editing
class PhotoGrid extends StatelessWidget {
  const PhotoGrid({
    super.key,
    required this.photos,
    required this.onAddPhoto,
    this.onPhotoTap,
    this.onPhotoLongPress,
    this.maxPhotos = 9,
  });

  final List<String> photos;
  final VoidCallback onAddPhoto;
  final Function(int index)? onPhotoTap;
  final Function(int index)? onPhotoLongPress;
  final int maxPhotos;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: AppSpacing.profilePhotoGridSpacing,
        mainAxisSpacing: AppSpacing.profilePhotoGridSpacing,
      ),
      itemCount: photos.length < maxPhotos ? photos.length + 1 : photos.length,
      itemBuilder: (context, index) {
        if (index == photos.length && photos.length < maxPhotos) {
          return PhotoPlaceholder(
            onTap: onAddPhoto,
            size: double.infinity,
          );
        }

        return GestureDetector(
          onTap: () => onPhotoTap?.call(index),
          onLongPress: () => onPhotoLongPress?.call(index),
          child: Stack(
            children: [
              ProfilePhotoLarge(
                imageUrl: photos[index],
                showGradient: false,
              ),
              if (index == 0)
                Positioned(
                  top: 4,
                  left: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: AppSpacing.borderRadiusXS,
                    ),
                    child: Text(
                      'Main',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Story-style photo indicator
class PhotoIndicator extends StatelessWidget {
  const PhotoIndicator({
    super.key,
    required this.totalPhotos,
    required this.currentIndex,
  });

  final int totalPhotos;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        totalPhotos,
        (index) => Expanded(
          child: Container(
            height: 4,
            margin: EdgeInsets.only(
              right: index < totalPhotos - 1 ? 2 : 0,
            ),
            decoration: BoxDecoration(
              color: index <= currentIndex
                  ? Colors.white
                  : Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }
}
