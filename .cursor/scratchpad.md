# Background and Motivation

User asked for a full, plain-language understanding of the entire project. This document captures a planner-grade analysis of the current codebase so implementation can proceed in small, verifiable steps.

# Key Challenges and Analysis

- Need a complete project map first (architecture, routes, features, data flow, backend state, and tests) before making changes.
- The app is feature-rich in UI but appears partially productionized: several areas are placeholder/demo style.
- Backend support exists structurally (`functions/`) but currently lacks implemented server logic.
- Automated test coverage is currently minimal, so confidence in behavior is low for future refactors.

# High-level Task Breakdown

1. Baseline architecture and runtime flow
   - Success criteria: entrypoint, routing, auth gates, and shell navigation are documented with file references.
2. Feature-by-feature functional inventory
   - Success criteria: each major `lib/features/*` module has purpose, maturity level, and key files identified.
3. Data and backend integration assessment
   - Success criteria: Firebase/Auth/Firestore/function usage is documented; missing integration points are explicit.
4. Quality and risk assessment
   - Success criteria: tests, technical debt, and production risks are listed with prioritized quick wins.
5. Create execution-ready milestones
   - Success criteria: a stepwise, low-risk roadmap is prepared for executor mode (one task at a time).

# Project Status Board

- [x] Discover top-level project structure and stack
- [x] Inspect app entrypoint, auth flow, and routing
- [x] Inventory feature modules in `lib/features`
- [x] Inspect data layer and Firebase usage
- [x] Inspect `functions/` backend state
- [x] Assess tests and major quality gaps
- [ ] Prepare executor-ready implementation milestones (pending user confirmation)

# Executor's Feedback or Assistance Requests

- Planner analysis is complete and ready for user review.
- If approved, executor should begin with the first milestone: establish meaningful tests around routing/auth guards before new feature work.
- **2026-05-06:** Discovery catalogue is now **version-controlled JSON** at `assets/data/places_seed.json` (44 places, 12 destinations—user’s final list: Skardu fixes, Karachi shrine removed, no Thatta/Gwadar/Hingol). Seeder loads this file at runtime. Regenerate JSON with `python scripts/build_places_seed.py`. **If supervisors already ran the old seed**, clear Firestore `destinations` (and subcollections) in Firebase Console once, then tap **Seed** again on Discovery so the new catalogue loads.

# Lessons

- Workspace access may appear empty under restricted mode; when path validation fails unexpectedly, verify with full filesystem permissions once before proceeding.
- Read-before-edit rule followed: project analyzed first, then planning notes recorded.

# Planner Analysis Snapshot (Current State)

## 1) Top-Level Architecture and Tech Stack

- Flutter app with feature-first modules and shared `core` layer.
- State management: Riverpod providers/notifiers.
- Routing/navigation: `go_router` with guarded redirects and tab shell.
- Backend/data: Firebase Auth + Cloud Firestore.
- Multi-platform targets present (`android`, `ios`, `web`, `windows`, `macos`, `linux`).

Primary references:
- `lib/main.dart`
- `lib/core/router/app_router.dart`
- `lib/core/shell/main_shell.dart`
- `lib/core/theme/app_theme.dart`
- `pubspec.yaml`

## 2) Entrypoint and Navigation Flow

- `main()` initializes Firebase then runs `ProviderScope` app.
- Router begins at `/splash`, then redirects by auth + verification state.
- Unauthorized users go to `/auth`; authorized users are routed into `/home`.
- Main app shell uses indexed stack with branches for Home, Discovery, AI Tools, Trips, and Profile.

Primary references:
- `lib/main.dart`
- `lib/features/splash/splash_screen.dart`
- `lib/core/router/app_router.dart`
- `lib/core/shell/main_shell.dart`

## 3) Feature Inventory (`lib/features`)

- `auth`: signup/login, validation, username reservation, profile write/read.
- `splash`: startup transition to proper route.
- `home`: curated cards/promotional UI (mostly static/demo content).
- `discovery`: Firestore-powered destinations/places, details, filtering, seeding utility.
- `ai_tools`: multiple tools (chatbot/translator/packing/expenses/currency/planner), largely client-side and demo-like.
- `trips`: trip UI with placeholder interactions.
- `profile`: Firestore profile display, logout, local profile photo persistence, SOS settings UI.

## 4) Data Layer and Services

- Auth logic is centralized in `AuthController` (Riverpod) using Firebase Auth and Firestore.
- Discovery uses Firestore providers/streams and typed models for destinations/places.
- Local persistence via `shared_preferences` (profile photo path).
- Media selection via `image_picker`.
- No dedicated API layer or cloud function client usage observed in app code.

Primary references:
- `lib/features/auth/controllers/auth_controller.dart`
- `lib/features/discovery/providers/discovery_providers.dart`
- `lib/features/discovery/models/destination.dart`
- `lib/features/discovery/models/place.dart`
- `lib/features/profile/profile_screen.dart`

## 5) Backend (`functions/`) State

- Firebase Functions project scaffold exists with dependencies/config.
- `functions/index.js` currently contains template/commented examples, with no active exported business handlers.
- No app-side callable/HTTP function integration found.

Primary references:
- `functions/package.json`
- `functions/index.js`
- `firebase.json`

## 6) Dependencies (Key)

- `flutter_riverpod`, `go_router`, `firebase_core`, `firebase_auth`, `cloud_firestore`, `image_picker`, `shared_preferences`.
- Dev deps include `flutter_test`, `flutter_lints`, `flutter_launcher_icons`.

Reference:
- `pubspec.yaml`

## 7) Tests and Coverage

- Only placeholder test exists (`test/widget_test.dart`) with trivial assertion.
- No meaningful tests for routing guards, auth controller behavior, discovery providers/models, or profile persistence.
- Effective behavioral coverage is near zero.

## 8) Risks and Quick Wins

Risks:
- Significant UI appears demo/placeholder; behavior may not match product intent.
- Backend functions are not implemented yet.
- Client writes/seeding patterns require strict Firestore rules (not reviewed here).

Quick wins:
- Add focused tests first (routing/auth/discovery).
- Implement one real backend function and wire it from app.
- Replace no-op UI taps with real navigation/actions.
- Wrap AI/demo logic behind service interfaces for future API substitution.

## 9) Proposed Next Milestone (for Executor Mode)

Milestone 1 (recommended): **Routing/Auth Test Foundation**
- Add tests for splash-to-auth/home redirect behavior.
- Add unit tests for `AuthController` critical paths (signup/signin/signout + username reservation failure handling).
- Success criteria: repeatable test suite that validates auth gates before further feature work.
