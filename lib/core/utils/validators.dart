/// Collection of validation utilities for user input
class Validators {
  Validators._();

  // Email validation regex - comprehensive RFC 5322 compliant
  static final RegExp _emailRegex = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
  );

  // Phone validation regex - international format
  static final RegExp _phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');

  // Ethiopian phone number regex
  static final RegExp _ethiopianPhoneRegex = RegExp(r'^(\+251|0)(9|7)\d{8}$');

  // Eritrean phone number regex
  static final RegExp _eritreanPhoneRegex = RegExp(r'^(\+291|0)[1-9]\d{6}$');

  // Name validation - allows letters, spaces, hyphens, apostrophes
  static final RegExp _nameRegex = RegExp(r'^[a-zA-Z\u1200-\u137F\s\-\'\.]+$');

  // Password strength validation
  static final RegExp _upperCaseRegex = RegExp(r'[A-Z]');
  static final RegExp _lowerCaseRegex = RegExp(r'[a-z]');
  static final RegExp _digitRegex = RegExp(r'[0-9]');
  static final RegExp _specialCharRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

  /// Validates email address
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    return _emailRegex.hasMatch(email.trim());
  }

  /// Validates password strength
  /// Returns null if valid, error message if invalid
  static String? validatePassword(String password) {
    if (password.isEmpty) return 'Password is required';
    if (password.length < 8) return 'Password must be at least 8 characters';
    if (password.length > 128) return 'Password must be less than 128 characters';
    
    int strengthScore = 0;
    List<String> missing = [];

    if (_upperCaseRegex.hasMatch(password)) {
      strengthScore++;
    } else {
      missing.add('uppercase letter');
    }

    if (_lowerCaseRegex.hasMatch(password)) {
      strengthScore++;
    } else {
      missing.add('lowercase letter');
    }

    if (_digitRegex.hasMatch(password)) {
      strengthScore++;
    } else {
      missing.add('number');
    }

    if (_specialCharRegex.hasMatch(password)) {
      strengthScore++;
    } else {
      missing.add('special character');
    }

    // Require at least 3 out of 4 criteria
    if (strengthScore < 3) {
      return 'Password must contain at least 3 of: ${missing.join(', ')}';
    }

    // Check for common weak passwords
    if (_isCommonPassword(password)) {
      return 'Password is too common, please choose a stronger password';
    }

    return null; // Valid password
  }

  /// Validates phone number
  static bool isValidPhone(String phone) {
    if (phone.isEmpty) return false;
    String cleanPhone = phone.replaceAll(RegExp(r'\s|-|\(|\)'), '');
    return _phoneRegex.hasMatch(cleanPhone);
  }

  /// Validates Ethiopian phone number specifically
  static bool isValidEthiopianPhone(String phone) {
    if (phone.isEmpty) return false;
    String cleanPhone = phone.replaceAll(RegExp(r'\s|-|\(|\)'), '');
    return _ethiopianPhoneRegex.hasMatch(cleanPhone);
  }

  /// Validates Eritrean phone number specifically
  static bool isValidEritreanPhone(String phone) {
    if (phone.isEmpty) return false;
    String cleanPhone = phone.replaceAll(RegExp(r'\s|-|\(|\)'), '');
    return _eritreanPhoneRegex.hasMatch(cleanPhone);
  }

  /// Validates name (supports Amharic, Tigrinya, Oromo characters)
  static String? validateName(String name) {
    if (name.trim().isEmpty) return 'Name is required';
    if (name.trim().length < 2) return 'Name must be at least 2 characters';
    if (name.trim().length > 50) return 'Name must be less than 50 characters';
    if (!_nameRegex.hasMatch(name.trim())) {
      return 'Name can only contain letters, spaces, hyphens, and apostrophes';
    }
    return null;
  }

  /// Validates age for dating app (18+)
  static String? validateAge(String ageString) {
    if (ageString.trim().isEmpty) return 'Age is required';
    
    int? age = int.tryParse(ageString.trim());
    if (age == null) return 'Please enter a valid age';
    if (age < 18) return 'You must be 18 or older to use this app';
    if (age > 100) return 'Please enter a valid age';
    
    return null;
  }

  /// Validates date of birth
  static String? validateDateOfBirth(DateTime? dateOfBirth) {
    if (dateOfBirth == null) return 'Date of birth is required';
    
    DateTime now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month || 
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    
    if (age < 18) return 'You must be 18 or older to use this app';
    if (age > 100) return 'Please enter a valid date of birth';
    if (dateOfBirth.isAfter(now)) return 'Date of birth cannot be in the future';
    
    return null;
  }

  /// Validates bio text
  static String? validateBio(String bio) {
    if (bio.trim().length > 500) return 'Bio must be less than 500 characters';
    
    // Check for inappropriate content (basic check)
    List<String> inappropriate = [
      'instagram', '@', 'snap', 'whatsapp', 'telegram', 'tiktok',
      'follow me', 'dm me', 'cash', 'venmo', 'paypal', 'bitcoin',
    ];
    
    String lowerBio = bio.toLowerCase();
    for (String word in inappropriate) {
      if (lowerBio.contains(word)) {
        return 'Bio cannot contain social media handles or payment references';
      }
    }
    
    return null;
  }

  /// Validates handle/username
  static String? validateHandle(String handle) {
    if (handle.trim().isEmpty) return 'Handle is required';
    if (handle.trim().length < 3) return 'Handle must be at least 3 characters';
    if (handle.trim().length > 20) return 'Handle must be less than 20 characters';
    
    // Only letters, numbers, underscores, hyphens
    RegExp handleRegex = RegExp(r'^[a-zA-Z0-9_-]+$');
    if (!handleRegex.hasMatch(handle.trim())) {
      return 'Handle can only contain letters, numbers, underscores, and hyphens';
    }
    
    // Cannot start or end with special characters
    if (handle.trim().startsWith('_') || 
        handle.trim().startsWith('-') ||
        handle.trim().endsWith('_') || 
        handle.trim().endsWith('-')) {
      return 'Handle cannot start or end with underscore or hyphen';
    }
    
    return null;
  }

  /// Validates distance (for search preferences)
  static String? validateDistance(String distanceString) {
    if (distanceString.trim().isEmpty) return 'Distance is required';
    
    int? distance = int.tryParse(distanceString.trim());
    if (distance == null) return 'Please enter a valid distance';
    if (distance < 5) return 'Distance must be at least 5 km';
    if (distance > 200) return 'Distance must be less than 200 km';
    
    return null;
  }

  /// Validates message content
  static String? validateMessage(String message) {
    if (message.trim().isEmpty) return 'Message cannot be empty';
    if (message.trim().length > 1000) return 'Message must be less than 1000 characters';
    
    // Basic spam detection
    if (_isSpamMessage(message)) {
      return 'Message appears to be spam';
    }
    
    return null;
  }

  /// Validates OTP code
  static String? validateOTP(String otp) {
    if (otp.trim().isEmpty) return 'OTP code is required';
    if (otp.trim().length != 6) return 'OTP code must be 6 digits';
    if (!RegExp(r'^\d{6}$').hasMatch(otp.trim())) {
      return 'OTP code must contain only numbers';
    }
    return null;
  }

  /// Validates height (optional profile field)
  static String? validateHeight(String? heightString) {
    if (heightString == null || heightString.trim().isEmpty) return null;
    
    int? height = int.tryParse(heightString.trim());
    if (height == null) return 'Please enter a valid height';
    if (height < 100) return 'Height must be at least 100 cm';
    if (height > 250) return 'Height must be less than 250 cm';
    
    return null;
  }

  /// Check if password is in common passwords list
  static bool _isCommonPassword(String password) {
    List<String> commonPasswords = [
      'password', '123456', '123456789', 'qwerty', 'abc123',
      'password123', 'admin', 'letmein', 'welcome', '1234567890',
      'password1', '123123', 'admin123', 'qwerty123', '000000',
    ];
    
    return commonPasswords.contains(password.toLowerCase());
  }

  /// Basic spam detection for messages
  static bool _isSpamMessage(String message) {
    String lowerMessage = message.toLowerCase();
    
    // Check for repeated characters (more than 4 in a row)
    RegExp repeatedChars = RegExp(r'(.)\1{4,}');
    if (repeatedChars.hasMatch(message)) return true;
    
    // Check for excessive capitalization
    int capitals = message.replaceAll(RegExp(r'[^A-Z]'), '').length;
    if (capitals > message.length * 0.7 && message.length > 10) return true;
    
    // Check for spam keywords
    List<String> spamKeywords = [
      'click here', 'free money', 'make money', 'earn cash',
      'get rich', 'investment opportunity', 'limited time',
      'act now', 'urgent', 'congratulations you won',
    ];
    
    for (String keyword in spamKeywords) {
      if (lowerMessage.contains(keyword)) return true;
    }
    
    return false;
  }

  /// Get password strength level (0-4)
  static int getPasswordStrength(String password) {
    int strength = 0;
    
    if (password.length >= 8) strength++;
    if (_upperCaseRegex.hasMatch(password)) strength++;
    if (_lowerCaseRegex.hasMatch(password)) strength++;
    if (_digitRegex.hasMatch(password)) strength++;
    if (_specialCharRegex.hasMatch(password)) strength++;
    
    return strength;
  }

  /// Get password strength description
  static String getPasswordStrengthDescription(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return 'Very Weak';
      case 2:
        return 'Weak';
      case 3:
        return 'Fair';
      case 4:
        return 'Good';
      case 5:
        return 'Strong';
      default:
        return 'Unknown';
    }
  }
}
