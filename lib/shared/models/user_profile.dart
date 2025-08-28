import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

@JsonSerializable()
class UserProfile extends Equatable {
  const UserProfile({
    required this.id,
    required this.handle,
    required this.name,
    required this.dateOfBirth,
    required this.gender,
    required this.photos,
    this.bio,
    this.religion,
    this.ethnicity,
    this.languages = const [],
    this.education,
    this.occupation,
    this.location,
    this.isVerified = false,
    this.isOnline = false,
    this.lastSeenAt,
    this.createdAt,
    this.updatedAt,
    this.distance,
    this.age,
  });

  final String id;
  final String handle;
  final String name;
  
  @JsonKey(name: 'date_of_birth')
  final DateTime dateOfBirth;
  
  final Gender gender;
  final List<ProfilePhoto> photos;
  final String? bio;
  final Religion? religion;
  final Ethnicity? ethnicity;
  final List<Language> languages;
  final EducationLevel? education;
  final String? occupation;
  final ProfileLocation? location;
  
  @JsonKey(name: 'is_verified')
  final bool isVerified;
  
  @JsonKey(name: 'is_online')
  final bool isOnline;
  
  @JsonKey(name: 'last_seen_at')
  final DateTime? lastSeenAt;
  
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  // Computed fields (not stored in DB)
  final double? distance; // Distance from current user in km
  final int? age; // Computed from dateOfBirth

  /// Get user's age
  int get computedAge {
    if (age != null) return age!;
    
    final now = DateTime.now();
    int userAge = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month || 
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      userAge--;
    }
    return userAge;
  }

  /// Get primary photo URL
  String? get primaryPhotoUrl {
    if (photos.isEmpty) return null;
    final primaryPhoto = photos.firstWhere(
      (photo) => photo.isPrimary,
      orElse: () => photos.first,
    );
    return primaryPhoto.url;
  }

  /// Check if profile is complete for discovery
  bool get isProfileComplete {
    return photos.isNotEmpty &&
           bio != null &&
           bio!.trim().isNotEmpty &&
           religion != null &&
           ethnicity != null &&
           languages.isNotEmpty;
  }

  /// Get verification status text
  String get verificationStatus {
    if (isVerified) return 'Verified';
    return 'Unverified';
  }

  /// Get online status text
  String get onlineStatus {
    if (isOnline) return 'Online';
    if (lastSeenAt != null) {
      final duration = DateTime.now().difference(lastSeenAt!);
      if (duration.inMinutes < 60) {
        return 'Active ${duration.inMinutes}m ago';
      } else if (duration.inHours < 24) {
        return 'Active ${duration.inHours}h ago';
      } else {
        return 'Active ${duration.inDays}d ago';
      }
    }
    return 'Offline';
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) => 
      _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  @override
  List<Object?> get props => [
    id, handle, name, dateOfBirth, gender, photos, bio, religion,
    ethnicity, languages, education, occupation, location, isVerified,
    isOnline, lastSeenAt, createdAt, updatedAt, distance, age,
  ];

  UserProfile copyWith({
    String? id,
    String? handle,
    String? name,
    DateTime? dateOfBirth,
    Gender? gender,
    List<ProfilePhoto>? photos,
    String? bio,
    Religion? religion,
    Ethnicity? ethnicity,
    List<Language>? languages,
    EducationLevel? education,
    String? occupation,
    ProfileLocation? location,
    bool? isVerified,
    bool? isOnline,
    DateTime? lastSeenAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? distance,
    int? age,
  }) {
    return UserProfile(
      id: id ?? this.id,
      handle: handle ?? this.handle,
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      photos: photos ?? this.photos,
      bio: bio ?? this.bio,
      religion: religion ?? this.religion,
      ethnicity: ethnicity ?? this.ethnicity,
      languages: languages ?? this.languages,
      education: education ?? this.education,
      occupation: occupation ?? this.occupation,
      location: location ?? this.location,
      isVerified: isVerified ?? this.isVerified,
      isOnline: isOnline ?? this.isOnline,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      distance: distance ?? this.distance,
      age: age ?? this.age,
    );
  }
}

@JsonSerializable()
class ProfilePhoto extends Equatable {
  const ProfilePhoto({
    required this.id,
    required this.url,
    required this.order,
    this.isPrimary = false,
    this.isVerified = false,
    this.createdAt,
  });

  final String id;
  final String url;
  final int order;
  
  @JsonKey(name: 'is_primary')
  final bool isPrimary;
  
  @JsonKey(name: 'is_verified')
  final bool isVerified;
  
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  factory ProfilePhoto.fromJson(Map<String, dynamic> json) => 
      _$ProfilePhotoFromJson(json);

  Map<String, dynamic> toJson() => _$ProfilePhotoToJson(this);

  @override
  List<Object?> get props => [id, url, order, isPrimary, isVerified, createdAt];

  ProfilePhoto copyWith({
    String? id,
    String? url,
    int? order,
    bool? isPrimary,
    bool? isVerified,
    DateTime? createdAt,
  }) {
    return ProfilePhoto(
      id: id ?? this.id,
      url: url ?? this.url,
      order: order ?? this.order,
      isPrimary: isPrimary ?? this.isPrimary,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

@JsonSerializable()
class ProfileLocation extends Equatable {
  const ProfileLocation({
    required this.latitude,
    required this.longitude,
    this.city,
    this.country,
    this.countryCode,
  });

  final double latitude;
  final double longitude;
  final String? city;
  final String? country;
  
  @JsonKey(name: 'country_code')
  final String? countryCode;

  factory ProfileLocation.fromJson(Map<String, dynamic> json) => 
      _$ProfileLocationFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileLocationToJson(this);

  @override
  List<Object?> get props => [latitude, longitude, city, country, countryCode];

  ProfileLocation copyWith({
    double? latitude,
    double? longitude,
    String? city,
    String? country,
    String? countryCode,
  }) {
    return ProfileLocation(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      city: city ?? this.city,
      country: country ?? this.country,
      countryCode: countryCode ?? this.countryCode,
    );
  }
}

enum Gender {
  @JsonValue('male')
  male,
  @JsonValue('female')
  female,
  @JsonValue('non_binary')
  nonBinary,
}

enum Religion {
  @JsonValue('orthodox')
  orthodox,
  @JsonValue('protestant')
  protestant,
  @JsonValue('catholic')
  catholic,
  @JsonValue('muslim')
  muslim,
  @JsonValue('jewish')
  jewish,
  @JsonValue('other')
  other,
  @JsonValue('spiritual')
  spiritual,
  @JsonValue('agnostic')
  agnostic,
  @JsonValue('atheist')
  atheist,
}

enum Ethnicity {
  @JsonValue('amhara')
  amhara,
  @JsonValue('oromo')
  oromo,
  @JsonValue('tigray')
  tigray,
  @JsonValue('somali')
  somali,
  @JsonValue('sidama')
  sidama,
  @JsonValue('wolayita')
  wolayita,
  @JsonValue('hadiya')
  hadiya,
  @JsonValue('gurage')
  gurage,
  @JsonValue('afar')
  afar,
  @JsonValue('gamo')
  gamo,
  @JsonValue('eritrean_tigrinya')
  eritreanTigrinya,
  @JsonValue('eritrean_tigre')
  eritreanTigre,
  @JsonValue('eritrean_saho')
  eritreanSaho,
  @JsonValue('mixed')
  mixed,
  @JsonValue('other')
  other,
}

enum Language {
  @JsonValue('amharic')
  amharic,
  @JsonValue('oromiffa')
  oromiffa,
  @JsonValue('tigrinya')
  tigrinya,
  @JsonValue('somali')
  somali,
  @JsonValue('sidamic')
  sidamic,
  @JsonValue('wolayitadonato')
  wolayitadonato,
  @JsonValue('arabic')
  arabic,
  @JsonValue('english')
  english,
  @JsonValue('french')
  french,
  @JsonValue('italian')
  italian,
  @JsonValue('portuguese')
  portuguese,
  @JsonValue('spanish')
  spanish,
  @JsonValue('german')
  german,
  @JsonValue('swedish')
  swedish,
  @JsonValue('norwegian')
  norwegian,
  @JsonValue('other')
  other,
}

enum EducationLevel {
  @JsonValue('high_school')
  highSchool,
  @JsonValue('some_college')
  someCollege,
  @JsonValue('bachelors')
  bachelors,
  @JsonValue('masters')
  masters,
  @JsonValue('phd')
  phd,
  @JsonValue('trade_school')
  tradeSchool,
  @JsonValue('other')
  other,
}

// Extension methods for enum display values
extension GenderExtension on Gender {
  String get displayName {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      case Gender.nonBinary:
        return 'Non-binary';
    }
  }
}

extension ReligionExtension on Religion {
  String get displayName {
    switch (this) {
      case Religion.orthodox:
        return 'Orthodox Christian';
      case Religion.protestant:
        return 'Protestant';
      case Religion.catholic:
        return 'Catholic';
      case Religion.muslim:
        return 'Muslim';
      case Religion.jewish:
        return 'Jewish';
      case Religion.other:
        return 'Other';
      case Religion.spiritual:
        return 'Spiritual';
      case Religion.agnostic:
        return 'Agnostic';
      case Religion.atheist:
        return 'Atheist';
    }
  }
}

extension EthnicityExtension on Ethnicity {
  String get displayName {
    switch (this) {
      case Ethnicity.amhara:
        return 'Amhara';
      case Ethnicity.oromo:
        return 'Oromo';
      case Ethnicity.tigray:
        return 'Tigray';
      case Ethnicity.somali:
        return 'Somali';
      case Ethnicity.sidama:
        return 'Sidama';
      case Ethnicity.wolayita:
        return 'Wolayita';
      case Ethnicity.hadiya:
        return 'Hadiya';
      case Ethnicity.gurage:
        return 'Gurage';
      case Ethnicity.afar:
        return 'Afar';
      case Ethnicity.gamo:
        return 'Gamo';
      case Ethnicity.eritreanTigrinya:
        return 'Eritrean Tigrinya';
      case Ethnicity.eritreanTigre:
        return 'Eritrean Tigre';
      case Ethnicity.eritreanSaho:
        return 'Eritrean Saho';
      case Ethnicity.mixed:
        return 'Mixed';
      case Ethnicity.other:
        return 'Other';
    }
  }
}

extension LanguageExtension on Language {
  String get displayName {
    switch (this) {
      case Language.amharic:
        return 'Amharic (አማርኛ)';
      case Language.oromiffa:
        return 'Oromiffa (Afaan Oromoo)';
      case Language.tigrinya:
        return 'Tigrinya (ትግርኛ)';
      case Language.somali:
        return 'Somali';
      case Language.sidamic:
        return 'Sidamic';
      case Language.wolayitadonato:
        return 'Wolayitadonato';
      case Language.arabic:
        return 'Arabic';
      case Language.english:
        return 'English';
      case Language.french:
        return 'French';
      case Language.italian:
        return 'Italian';
      case Language.portuguese:
        return 'Portuguese';
      case Language.spanish:
        return 'Spanish';
      case Language.german:
        return 'German';
      case Language.swedish:
        return 'Swedish';
      case Language.norwegian:
        return 'Norwegian';
      case Language.other:
        return 'Other';
    }
  }
}

extension EducationLevelExtension on EducationLevel {
  String get displayName {
    switch (this) {
      case EducationLevel.highSchool:
        return 'High School';
      case EducationLevel.someCollege:
        return 'Some College';
      case EducationLevel.bachelors:
        return 'Bachelor\'s Degree';
      case EducationLevel.masters:
        return 'Master\'s Degree';
      case EducationLevel.phd:
        return 'PhD/Doctorate';
      case EducationLevel.tradeSchool:
        return 'Trade School';
      case EducationLevel.other:
        return 'Other';
    }
  }
}
