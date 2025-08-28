# Habesha Dating App - Technical Specification

## Project Overview

**Name**: Habesha Dating App  
**Mission**: Be the #1 dating app globally by blending world-class UX with Habesha culture, safety-by-design, and rigorous subscription enforcement.

### Goals
- High retention, high trust, low spam
- Frictionless onboarding and profile creation
- Fast, reliable realtime chat and calls
- Clear upgrade path with strict server-side paywalls

### Non-Goals
- Building custom media CDN (use managed storage/CDN)
- Hosting our own auth server (use Supabase Auth)

### Target Users
- Habesha diaspora worldwide
- Ethiopia-based users in major cities and regions
- Serious daters first; casual daters supported but de-prioritized

### KPIs
- **North Star**: Weekly Active Chats per User
- **Guardrails**: Report rate < 1.5%, Verified-profile rate > 65%, Premium conversion > 4% monthly, Message delivery p95 < 300ms

## Technical Architecture

### Platforms
- **Mobile**: iOS, Android
- **Frontend**: Flutter
- **Backend**: Supabase (Postgres + Realtime + Storage + Auth)
- **Notifications**: Firebase Cloud Messaging (FCM/APNs via Firebase)

### Frontend (Flutter)
- **Pattern**: Clean Architecture + Feature Modules
- **State Management**: Riverpod or BLoC (choose one consistently)
- **Navigation**: go_router with typed routes and deep links
- **Design System**: Material 3, light/dark themes
- **Tokens**: colors, typography, spacings, elevations, radii
- **Components**: AppBar, BottomNav, Cards, Chips, Badges, Shimmer placeholders

### i18n/l10n
- **Default Locale**: en
- **Supported**: en, am, om, ti
- **RTL Ready**: true

### Accessibility
- Sufficient contrast
- Large text support
- TalkBack/VoiceOver labels
- Haptic feedback

### Backend (Supabase)
- **Auth**: Email/password, Phone OTP, Google, Apple, Facebook
- **Database**: Postgres (row-level security mandatory)
- **Realtime**: Postgres subscriptions for chat, presence, typing
- **Storage**: Supabase Storage (images/audio), optional Cloudinary for heavy processing
- **Edge Functions**: Subscription enforcement, anti-spam, risk scoring, receipts validation

### CI/CD
- **Pipeline**: static analysis (dart analyze), tests (unit/widget/integration), build flavors dev/stage/prod, beta via Firebase App Distribution/TestFlight
- **Crash Reporting**: Firebase Crashlytics
- **Analytics**: Firebase Analytics + custom events to Supabase

## Data Model

### Tables

#### profiles
- id (uuid, pk)
- handle
- name
- dob
- gender
- photos (jsonb)
- bio
- religion
- ethnicity
- languages (jsonb)
- education
- occupation
- location (geom or point)
- is_verified
- created_at
- updated_at

#### preferences
- user_id (pk, fk)
- age_min
- age_max
- distance_km
- religions (jsonb)
- ethnicities (jsonb)
- education_levels (jsonb)
- intent (enum: serious, casual)
- diaspora_local (enum)
- updated_at

#### likes
- id (pk)
- from_id
- to_id
- type (enum: like, super_like)
- created_at
- retracted_at

#### matches
- id (pk)
- user1_id
- user2_id
- created_at
- last_message_at
- is_blocked_user1
- is_blocked_user2
- archived_user1
- archived_user2

#### messages
- id (pk)
- match_id (fk)
- sender_id
- text
- media_url
- media_type (enum: image, audio, none)
- seen_by (jsonb)
- created_at

#### presence
- user_id (pk)
- is_online
- last_seen_at
- device (platform)

#### subscriptions
- user_id (pk)
- tier (enum: free, premium, elite)
- status (enum: active, grace, past_due, canceled)
- renew_at
- platform (enum: ios, android, web, local)
- country
- created_at
- updated_at

#### entitlements
- user_id (pk)
- swipes_remaining (int)
- super_likes_remaining (int)
- boosts_remaining (int)
- resets_at (timestamp)

#### blocks_reports
- id (pk)
- reporter_id
- reported_id
- match_id
- reason (text|enum)
- evidence (jsonb)
- status (enum: open, actioned, dismissed)
- created_at

#### boosts
- id (pk)
- user_id
- starts_at
- ends_at
- status

#### payments
- id (pk)
- user_id
- provider
- plan_id
- amount
- currency
- receipt
- status
- created_at

#### audit_logs
- id (pk)
- actor_id
- action
- target_table
- target_id
- meta (jsonb)
- created_at

### RLS Policies

#### profiles
- SELECT: public but limited fields; full self-access
- UPDATE: user can update own profile; admins via role

#### preferences
- owner-only read/write

#### likes
- INSERT: owner-only; SELECT: owner and recipient

#### matches
- SELECT: only user1_id or user2_id; INSERT via server fn on mutual like

#### messages
- SELECT/INSERT: only members of the match
- Block read/write if either user blocked the other

#### subscriptions
- owner read, server/edge writes

#### payments
- owner read, server writes

#### blocks_reports
- reporter can insert; moderators read/update

## Features

### Onboarding
**Steps**:
1. Phone/email/social auth with age gate (>=18)
2. Phone OTP verification (high trust regions)
3. Photo upload with live selfie check
4. Quick prefs: distance, age range, intent
5. Optional culture fields: religion, ethnicity, languages

**Friction Control**: progress save, skip non-critical, smart defaults

### Profile
**Must Have**:
- Photo gallery (min 1, max 9), reorder, crop
- Prompts (e.g., 'Two truths and a lie', 'Faith matters to me…')
- Badges: Verified, Recently Active, Top Picks
- Instagram-style highlights for culture/events
- Privacy controls (hide distance/age toggle)

**Verification**: selfie video check, ID optional (premium+), liveness detection hint

### Discovery
**Modes**:
- Swipe stack (like, pass, super-like)
- Explore grid (filters + infinite scroll)
- Top Picks (curated daily)
- Recently Online

**Ranking**: Distance, recency, mutual prefs, profile quality score, boost priority, safety score, diversity constraints to avoid repetition

**Filters**:
- Basic: age, distance
- Advanced (Premium): religion, ethnicity, languages, education, diaspora/local toggle, intent

**Limits**:
- Free: 20 daily swipes, 0 super likes
- Premium: unlimited swipes, 5 super likes

### Matching
- Logic: Mutual like creates match via server RPC
- Features: Undo last swipe (premium), Like notes on send (premium), Auto-message prompts to break ice

### Chat
- **Backend**: Supabase Realtime
- **Capabilities**: Text, image, voice notes (AMR/MP3), typing, read receipts, presence (online/last seen), message reactions, quote/reply, delete for me, report message, rate limits (messages/min) to reduce spam
- **Media**: Upload to Supabase Storage; generate signed URLs; client-side compression
- **Localization**: auto translate prompt (premium+), transliteration hints
- **Enforcement**: 
  - Free: text only, 1 photo/day, no voice notes
  - Premium: images/voice unlimited within fair use

### Calls
- **Video/Audio**: Integrate Agora or WebRTC provider
- **Gating**: Premium and above only
- **Safety**: blur option by default, tap-to-unblur, quick report/end, block on exit
- **Network**: adaptive bitrate, switch to audio if poor connection

### Boosts and Discovery Perks
- **Boost**: 30 minutes priority ranking (1/week premium, purchasable add-on)
- **Super Like**: Stand out in stack; adds Like Note
- **Top Picks**: Daily curated list; more slots for premium

### Social Layers
- **Events**: Local/diaspora events discovery (read-only v1), RSVP (v2)
- **Interests**: Tag-based matching and community prompts
- **Icebreakers**: Daily cultural questions

### Trust and Safety
- **Report/Block**: one-tap report with categories, auto-mute offender pending review
- **Photo AI**: NSFW detection before publish
- **Scam Shields**: link detection, payment/crypto solicitation filter
- **Moderation Tools**: shadow-ban flag, message rate throttling, risk scoring

## Monetization

### Tiers

#### Free
- 20 swipes per day
- 3 matches per day max
- Text-only chat
- Basic filters
- Optional ads

#### Premium ($19.99/month)
- Unlimited swipes
- See who liked you
- Advanced filters
- 5 super likes monthly
- 1 boost weekly
- Undo last swipe
- Media in chat (images + voice)
- Video calls
- Ad-free

#### Elite ($39.99/month)
- All Premium features
- Priority ranking
- Double top picks
- Human profile reviews monthly
- ID verification badge

### Payments
**Providers**:
- Global: Google Play Billing, Apple IAP, Stripe (web fallback)
- Ethiopia Local: Telebirr, CBE Birr, HelloCash (via aggregator)

**Plans**:
- Premium Monthly: $19.99, 3-day intro trial
- Premium Yearly: $99.99 (best value)
- Elite Monthly: $39.99

**Anti-Fraud**: server-side receipt validation, entitlements from server only, cooldown on trial retries

### Strict Enforcement
- **Server Authority**: All premium gates validated by Edge Functions
- **Rate Limits**: 20 swipes/day free, 12 likes/minute, 10 messages/minute free
- **Fail Closed**: If validation fails, treat as free
- **Grace Period**: 3 days
- **Auto Renewal**: true
- **Entitlements Reset**: Nightly cron job resets daily quotas

## Performance SLAs
- App launch (cold) p95: 1800ms
- Feed first card: 700ms
- Message delivery p95: 300ms
- Image load p95: 1200ms
- Crash-free users: 99.5%

## Analytics & Experiments
**Events**: onboard_complete, profile_verified, swipe_like, swipe_pass, match_created, message_sent, call_started, paywall_viewed, purchase_completed, report_submitted

**A/B Testing**: swipe_limit_variants, paywall_copy, top_picks_size, like_note_nudge

**Dashboards**: activation funnel, match rate by cohort, report rate by segment, subscription conversion by locale

## Testing Strategy
- **Unit**: match creation logic, subscription gates, rate limiters
- **Widget**: SwipeCard gestures, Chat composer states, Paywall modal
- **Integration**: auth + onboarding, purchase flow, telebirr webhook to entitlement
- **Security**: RLS negative tests, media URL expiry, receipt replay attack

## Legal & Policy
- **Age Gate**: 18+ only
- **Terms/Privacy**: region-specific, GDPR compliant
- **Data Export/Delete**: in-app controls
- **Content Rules**: No nudity, hate, harassment, scams, or requests for money; automatic action on repeated offenses

## Implementation Notes

### Flutter Packages
- go_router
- flutter_riverpod or flutter_bloc
- intl
- cached_network_image
- image_picker
- just_audio (voice notes playback)
- permission_handler
- in_app_purchase or revenuecat (optional wrapper)
- firebase_messaging
- camera (verification)
- flutter_webrtc or agora_rtc_engine

### Optimizations
- Preload next 3 profile cards
- Thumbnails + progressive image loading
- Debounced filter queries
- Paginate chat by time windows

### Security Hardening
- Signed URLs for media with short TTL
- All writes via RLS or Edge Functions
- Device-based abuse limits
- Suspicious login alerts

## RPCs and Edge Functions

### RPCs
- create_like(from_id, to_id)
- create_match_if_mutual(from_id, to_id) -> match_id
- get_discovery_feed(user_id, limit, cursor)
- consume_swipe(user_id) -> remaining
- record_message(match_id, sender_id, payload)
- mark_seen(match_id, message_id, user_id)
- get_entitlements(user_id)

### Edge Functions
- validate_subscription_and_issue_entitlements
- receipt_validate_ios
- receipt_validate_android
- telebirr_webhook_handler
- risk_score_message
- moderation_photo_scan
