/// Base exception class for the app
abstract class AppException implements Exception {
  const AppException(this.message, [this.code]);

  final String message;
  final String? code;

  @override
  String toString() => 'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Network related exceptions
class NetworkException extends AppException {
  const NetworkException(super.message, [super.code]);
}

class NoInternetException extends NetworkException {
  const NoInternetException() : super('No internet connection available');
}

class ServerException extends NetworkException {
  const ServerException([String message = 'Server error occurred', String? code])
      : super(message, code);
}

class TimeoutException extends NetworkException {
  const TimeoutException([String message = 'Request timeout', String? code])
      : super(message, code);
}

/// Authentication related exceptions
class AuthException extends AppException {
  const AuthException(super.message, [super.code]);
}

class UnauthorizedException extends AuthException {
  const UnauthorizedException() : super('User is not authorized');
}

class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException() : super('Invalid email or password');
}

class UserNotVerifiedException extends AuthException {
  const UserNotVerifiedException() : super('User email is not verified');
}

class WeakPasswordException extends AuthException {
  const WeakPasswordException() : super('Password is too weak');
}

class EmailAlreadyInUseException extends AuthException {
  const EmailAlreadyInUseException() : super('Email is already registered');
}

class UserDisabledException extends AuthException {
  const UserDisabledException() : super('User account has been disabled');
}

class TooManyRequestsException extends AuthException {
  const TooManyRequestsException() : super('Too many requests. Please try again later');
}

/// Profile related exceptions
class ProfileException extends AppException {
  const ProfileException(super.message, [super.code]);
}

class IncompleteProfileException extends ProfileException {
  const IncompleteProfileException() : super('Profile is incomplete');
}

class PhotoUploadException extends ProfileException {
  const PhotoUploadException([String message = 'Failed to upload photo'])
      : super(message);
}

class InvalidPhotoException extends ProfileException {
  const InvalidPhotoException([String message = 'Invalid photo format or size'])
      : super(message);
}

class PhotoModerationException extends ProfileException {
  const PhotoModerationException() : super('Photo did not pass moderation review');
}

/// Discovery and matching exceptions
class DiscoveryException extends AppException {
  const DiscoveryException(super.message, [super.code]);
}

class SwipeLimitExceededException extends DiscoveryException {
  const SwipeLimitExceededException() : super('Daily swipe limit reached');
}

class NoMoreProfilesException extends DiscoveryException {
  const NoMoreProfilesException() : super('No more profiles to show');
}

class InvalidLikeException extends DiscoveryException {
  const InvalidLikeException() : super('Cannot like this profile');
}

/// Chat related exceptions
class ChatException extends AppException {
  const ChatException(super.message, [super.code]);
}

class MessageTooLongException extends ChatException {
  const MessageTooLongException() : super('Message is too long');
}

class MediaUploadException extends ChatException {
  const MediaUploadException([String message = 'Failed to upload media'])
      : super(message);
}

class RateLimitException extends ChatException {
  const RateLimitException() : super('Sending messages too fast. Please slow down');
}

class BlockedUserException extends ChatException {
  const BlockedUserException() : super('Cannot message blocked user');
}

/// Subscription related exceptions
class SubscriptionException extends AppException {
  const SubscriptionException(super.message, [super.code]);
}

class SubscriptionExpiredException extends SubscriptionException {
  const SubscriptionExpiredException() : super('Subscription has expired');
}

class PaymentFailedException extends SubscriptionException {
  const PaymentFailedException([String message = 'Payment failed'])
      : super(message);
}

class InvalidReceiptException extends SubscriptionException {
  const InvalidReceiptException() : super('Invalid payment receipt');
}

class SubscriptionNotActiveException extends SubscriptionException {
  const SubscriptionNotActiveException() : super('Premium subscription required');
}

/// Verification related exceptions
class VerificationException extends AppException {
  const VerificationException(super.message, [super.code]);
}

class InvalidOTPException extends VerificationException {
  const InvalidOTPException() : super('Invalid or expired OTP code');
}

class VerificationFailedException extends VerificationException {
  const VerificationFailedException([String message = 'Verification failed'])
      : super(message);
}

class TooManyVerificationAttemptsException extends VerificationException {
  const TooManyVerificationAttemptsException()
      : super('Too many verification attempts. Please try again later');
}

/// Safety and moderation exceptions
class SafetyException extends AppException {
  const SafetyException(super.message, [super.code]);
}

class UserReportedException extends SafetyException {
  const UserReportedException() : super('User has been reported and restricted');
}

class ContentViolationException extends SafetyException {
  const ContentViolationException([String message = 'Content violates community guidelines'])
      : super(message);
}

class BannedUserException extends SafetyException {
  const BannedUserException() : super('User account has been banned');
}

/// Local storage exceptions
class LocalStorageException extends AppException {
  const LocalStorageException(super.message, [super.code]);
}

class CacheException extends LocalStorageException {
  const CacheException([String message = 'Cache operation failed'])
      : super(message);
}

/// Validation exceptions
class ValidationException extends AppException {
  const ValidationException(super.message, [super.code]);
}

class InvalidEmailException extends ValidationException {
  const InvalidEmailException() : super('Please enter a valid email address');
}

class InvalidPhoneException extends ValidationException {
  const InvalidPhoneException() : super('Please enter a valid phone number');
}

class InvalidAgeException extends ValidationException {
  const InvalidAgeException() : super('You must be 18 or older to use this app');
}

class InvalidNameException extends ValidationException {
  const InvalidNameException() : super('Please enter a valid name');
}

/// Permission related exceptions
class PermissionException extends AppException {
  const PermissionException(super.message, [super.code]);
}

class CameraPermissionException extends PermissionException {
  const CameraPermissionException() : super('Camera permission is required');
}

class LocationPermissionException extends PermissionException {
  const LocationPermissionException() : super('Location permission is required');
}

class StoragePermissionException extends PermissionException {
  const StoragePermissionException() : super('Storage permission is required');
}

class MicrophonePermissionException extends PermissionException {
  const MicrophonePermissionException() : super('Microphone permission is required');
}

class NotificationPermissionException extends PermissionException {
  const NotificationPermissionException() : super('Notification permission is required');
}

/// Location related exceptions
class LocationException extends AppException {
  const LocationException(super.message, [super.code]);
}

class LocationServiceDisabledException extends LocationException {
  const LocationServiceDisabledException() : super('Location services are disabled');
}

class LocationNotFoundException extends LocationException {
  const LocationNotFoundException() : super('Unable to determine current location');
}
