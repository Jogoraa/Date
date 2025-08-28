# Habesha Dating App

> Be the #1 dating app globally by blending world-class UX with Habesha culture, safety-by-design, and rigorous subscription enforcement.

## 🎯 Mission

Create a premium dating experience that connects the global Habesha diaspora with Ethiopia-based users, prioritizing trust, safety, and meaningful connections through culturally-aware features and world-class user experience.

## 🌟 Key Goals

- **High retention, high trust, low spam** - Focus on quality over quantity
- **Frictionless onboarding** - Get users to their first meaningful interaction quickly
- **Fast, reliable realtime chat and calls** - Sub-300ms message delivery
- **Clear upgrade path** - Server-side subscription enforcement with strict paywalls

## 🏗️ Tech Stack

- **Frontend**: Flutter (iOS + Android)
- **Backend**: Supabase (Postgres + Realtime + Storage + Auth)
- **Notifications**: Firebase Cloud Messaging
- **Architecture**: Clean Architecture + Feature Modules
- **State Management**: Riverpod (TBD) or BLoC
- **Navigation**: go_router with typed routes and deep links

## 📊 Key Metrics

- **North Star**: Weekly Active Chats per User
- **Guardrails**: 
  - Report rate < 1.5%
  - Verified-profile rate > 65%
  - Premium conversion > 4% monthly
  - Message delivery p95 < 300ms

## 🎯 Target Users

1. **Habesha diaspora worldwide** - Primary focus
2. **Ethiopia-based users** - Major cities and regions
3. **Serious daters first** - Casual daters supported but de-prioritized

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (latest stable)
- Dart SDK
- iOS: Xcode 14+
- Android: Android Studio with SDK 21+
- Supabase account and project

### Installation

```bash
# Clone the repository
git clone <repository-url>
cd habesha-dating-app

# Install dependencies
flutter pub get

# Run code generation (if needed)
flutter packages pub run build_runner build

# Run the app
flutter run
```

### Environment Setup

1. Copy `.env.example` to `.env`
2. Add your Supabase project URL and anon key
3. Add Firebase configuration files:
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`

## 📁 Project Structure

```
lib/
├── core/                 # Core utilities, constants, themes
├── features/            # Feature modules (clean architecture)
│   ├── auth/           # Authentication & onboarding
│   ├── discovery/      # Swipe, explore, filters
│   ├── matching/       # Likes, matches
│   ├── chat/           # Messaging & calls
│   ├── profile/        # User profiles
│   └── subscription/   # Premium features & payments
├── shared/             # Shared widgets, services
└── main.dart          # App entry point
```

## 🌍 Localization

Supported languages:
- English (default)
- Amharic (አማርኛ)
- Oromiffa (Afaan Oromoo)
- Tigrinya (ትግርኛ)

## 💎 Premium Features

### Free Tier
- 20 swipes per day
- Text-only chat
- Basic filters (age, distance)

### Premium Tier ($19.99/month)
- Unlimited swipes
- See who liked you
- Advanced filters (religion, ethnicity, etc.)
- Media in chat (images, voice notes)
- Video calls
- Weekly boost

### Elite Tier ($39.99/month)
- All Premium features
- Priority ranking
- Human profile reviews
- ID verification badge

## 🔐 Privacy & Safety

- Age gate: 18+ only
- Phone verification in high-trust regions
- Live selfie check for verification
- AI-powered NSFW detection
- One-tap report/block system
- GDPR compliant data handling

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Follow the existing code style and architecture
4. Write tests for new features
5. Submit a pull request

## 📄 License

[License details to be added]

---

For detailed technical specifications, see [PROJECT_SPEC.md](PROJECT_SPEC.md).
