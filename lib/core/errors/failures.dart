import 'package:equatable/equatable.dart';

/// Base failure class
abstract class Failure extends Equatable {
  const Failure({
    required this.message,
    this.code,
  });

  final String message;
  final String? code;

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() => 'Failure: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Network failures
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
  });
}

class NoInternetFailure extends NetworkFailure {
  const NoInternetFailure()
      : super(message: 'No internet connection available');
}

class ServerFailure extends NetworkFailure {
  const ServerFailure({
    String message = 'Server error occurred',
    String? code,
  }) : super(message: message, code: code);
}

class TimeoutFailure extends NetworkFailure {
  const TimeoutFailure()
      : super(message: 'Request timeout');
}

/// Authentication failures
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.code,
  });
}

class UnauthorizedFailure extends AuthFailure {
  const UnauthorizedFailure()
      : super(message: 'User is not authorized');
}

class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure()
      : super(message: 'Invalid email or password');
}

class UserNotVerifiedFailure extends AuthFailure {
  const UserNotVerifiedFailure()
      : super(message: 'User email is not verified');
}

class WeakPasswordFailure extends AuthFailure {
  const WeakPasswordFailure()
      : super(message: 'Password is too weak');
}

class EmailAlreadyInUseFailure extends AuthFailure {
  const EmailAlreadyInUseFailure()
      : super(message: 'Email is already registered');
}

class UserDisabledFailure extends AuthFailure {
  const UserDisabledFailure()
      : super(message: 'User account has been disabled');
}

class TooManyRequestsFailure extends AuthFailure {
  const TooManyRequestsFailure()
      : super(message: 'Too many requests. Please try again later');
}

/// Profile failures
class ProfileFailure extends Failure {
  const ProfileFailure({
    required super.message,
    super.code,
  });
}

class IncompleteProfileFailure extends ProfileFailure {
  const IncompleteProfileFailure()
      : super(message: 'Profile is incomplete');
}

class PhotoUploadFailure extends ProfileFailure {
  const PhotoUploadFailure({
    String message = 'Failed to upload photo',
  }) : super(message: message);
}

class InvalidPhotoFailure extends ProfileFailure {
  const InvalidPhotoFailure({
    String message = 'Invalid photo format or size',
  }) : super(message: message);
}

class PhotoModerationFailure extends ProfileFailure {
  const PhotoModerationFailure()
      : super(message: 'Photo did not pass moderation review');
}

/// Discovery failures
class DiscoveryFailure extends Failure {
  const DiscoveryFailure({
    required super.message,
    super.code,
  });
}

class SwipeLimitExceededFailure extends DiscoveryFailure {
  const SwipeLimitExceededFailure()
      : super(message: 'Daily swipe limit reached');
}

class NoMoreProfilesFailure extends DiscoveryFailure {
  const NoMoreProfilesFailure()
      : super(message: 'No more profiles to show');
}

class InvalidLikeFailure extends DiscoveryFailure {
  const InvalidLikeFailure()
      : super(message: 'Cannot like this profile');
}

/// Chat failures
class ChatFailure extends Failure {
  const ChatFailure({
    required super.message,
    super.code,
  });
}

class MessageTooLongFailure extends ChatFailure {
  const MessageTooLongFailure()
      : super(message: 'Message is too long');
}

class MediaUploadFailure extends ChatFailure {
  const MediaUploadFailure({
    String message = 'Failed to upload media',
  }) : super(message: message);
}

class RateLimitFailure extends ChatFailure {
  const RateLimitFailure()
      : super(message: 'Sending messages too fast. Please slow down');
}

class BlockedUserFailure extends ChatFailure {
  const BlockedUserFailure()
      : super(message: 'Cannot message blocked user');
}

/// Subscription failures
class SubscriptionFailure extends Failure {
  const SubscriptionFailure({
    required super.message,
    super.code,
  });
}

class SubscriptionExpiredFailure extends SubscriptionFailure {
  const SubscriptionExpiredFailure()
      : super(message: 'Subscription has expired');
}

class PaymentFailedFailure extends SubscriptionFailure {
  const PaymentFailedFailure({
    String message = 'Payment failed',
  }) : super(message: message);
}

class InvalidReceiptFailure extends SubscriptionFailure {
  const InvalidReceiptFailure()
      : super(message: 'Invalid payment receipt');
}

class SubscriptionNotActiveFailure extends SubscriptionFailure {
  const SubscriptionNotActiveFailure()
      : super(message: 'Premium subscription required');
}

/// Verification failures
class VerificationFailure extends Failure {
  const VerificationFailure({
    required super.message,
    super.code,
  });
}

class InvalidOTPFailure extends VerificationFailure {
  const InvalidOTPFailure()
      : super(message: 'Invalid or expired OTP code');
}

class VerificationFailedFailure extends VerificationFailure {
  const VerificationFailedFailure({
    String message = 'Verification failed',
  }) : super(message: message);
}

class TooManyVerificationAttemptsFailure extends VerificationFailure {
  const TooManyVerificationAttemptsFailure()
      : super(message: 'Too many verification attempts. Please try again later');
}

/// Safety failures
class SafetyFailure extends Failure {
  const SafetyFailure({
    required super.message,
    super.code,
  });
}

class UserReportedFailure extends SafetyFailure {
  const UserReportedFailure()
      : super(message: 'User has been reported and restricted');
}

class ContentViolationFailure extends SafetyFailure {
  const ContentViolationFailure({
    String message = 'Content violates community guidelines',
  }) : super(message: message);
}

class BannedUserFailure extends SafetyFailure {
  const BannedUserFailure()
      : super(message: 'User account has been banned');
}

/// Cache failures
class CacheFailure extends Failure {
  const CacheFailure({
    String message = 'Cache operation failed',
    String? code,
  }) : super(message: message, code: code);
}

/// Validation failures
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code,
  });
}

class InvalidEmailFailure extends ValidationFailure {
  const InvalidEmailFailure()
      : super(message: 'Please enter a valid email address');
}

class InvalidPhoneFailure extends ValidationFailure {
  const InvalidPhoneFailure()
      : super(message: 'Please enter a valid phone number');
}

class InvalidAgeFailure extends ValidationFailure {
  const InvalidAgeFailure()
      : super(message: 'You must be 18 or older to use this app');
}

class InvalidNameFailure extends ValidationFailure {
  const InvalidNameFailure()
      : super(message: 'Please enter a valid name');
}

/// Permission failures
class PermissionFailure extends Failure {
  const PermissionFailure({
    required super.message,
    super.code,
  });
}

class CameraPermissionFailure extends PermissionFailure {
  const CameraPermissionFailure()
      : super(message: 'Camera permission is required');
}

class LocationPermissionFailure extends PermissionFailure {
  const LocationPermissionFailure()
      : super(message: 'Location permission is required');
}

class StoragePermissionFailure extends PermissionFailure {
  const StoragePermissionFailure()
      : super(message: 'Storage permission is required');
}

class MicrophonePermissionFailure extends PermissionFailure {
  const MicrophonePermissionFailure()
      : super(message: 'Microphone permission is required');
}

class NotificationPermissionFailure extends PermissionFailure {
  const NotificationPermissionFailure()
      : super(message: 'Notification permission is required');
}

/// Location failures
class LocationFailure extends Failure {
  const LocationFailure({
    required super.message,
    super.code,
  });
}

class LocationServiceDisabledFailure extends LocationFailure {
  const LocationServiceDisabledFailure()
      : super(message: 'Location services are disabled');
}

class LocationNotFoundFailure extends LocationFailure {
  const LocationNotFoundFailure()
      : super(message: 'Unable to determine current location');
}
