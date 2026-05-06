# TourMate App - Complete Development Documentation
## For Viva Presentation

---

## 1. PROJECT OVERVIEW

**Project Name:** TourMate  
**Description:** A comprehensive Flutter-based travel companion application designed to help travelers discover destinations, plan trips, utilize AI-powered tools, and manage travel expenses.

**Target Audience:** Travel enthusiasts, backpackers, and casual tourists in Pakistan and beyond  
**Platform:** Mobile (Android & iOS via Flutter)  
**Backend:** Firebase (Authentication + Cloud Firestore)

---

## 2. TECHNOLOGY STACK

### **Frontend Technologies**
- **Framework:** Flutter 3.10.1+
- **Language:** Dart 3.10.1+
- **State Management:** Riverpod 3.3.1
- **Navigation:** Go Router 17.2.2
- **UI Components:** Material Design 3

### **Backend Services**
- **Authentication:** Firebase Authentication v6.4.0
- **Database:** Cloud Firestore v6.3.0
- **Real-time Updates:** Firestore Streams
- **Local Storage:** SharedPreferences 2.3.3

### **Additional Libraries**
- `image_picker: ^1.1.2` — For user profile picture selection
- `flutter_launcher_icons: ^0.14.3` — App icon management
- `cupertino_icons: ^1.0.8` — iOS-style icons

### **Development Tools**
- Flutter SDK
- Firebase CLI
- Android Studio / Xcode
- VS Code / Android Studio IDE

---

## 3. ARCHITECTURE & DESIGN PATTERNS

### **3.1 Architectural Approach: Feature-based Clean Architecture**

```
lib/
├── core/                      # Shared code
│   ├── theme/                # Design system & colors
│   ├── widgets/              # Reusable UI components
│   ├── shell/                # Navigation shell (bottom nav)
│   └── router/               # Go Router configuration
├── features/                  # Feature modules (modular)
│   ├── auth/                 # Authentication module
│   ├── splash/               # Splash screen
│   ├── home/                 # Home/Discovery screen
│   ├── discovery/            # Trip discovery system
│   ├── ai_tools/             # AI tools module
│   ├── trips/                # My Trips module
│   └── profile/              # User profile module
└── main.dart                 # App entry point
```

**Why this structure?**
- **Modularity:** Each feature is self-contained with its own models, screens, providers, and business logic
- **Scalability:** Easy to add new features without affecting existing code
- **Maintainability:** Clear separation of concerns — each developer can work on different features independently
- **Testability:** Each module can be tested in isolation

### **3.2 Design Patterns Used**

#### **a) Provider Pattern (Riverpod)**
- Manages global state without BuildContext
- Enables reactive programming
- Supports async data fetching (StreamProvider, FutureProvider)

**Example:**
```dart
// Stream of real-time data from Firestore
final destinationsStreamProvider = StreamProvider<List<Destination>>((ref) {
  return FirebaseFirestore.instance.collection('destinations').snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => Destination.fromFirestore(doc)).toList());
});

// Single async fetch with parameter
final destinationByIdProvider = FutureProvider.family<Destination?, String>((ref, destId) async {
  final doc = await FirebaseFirestore.instance.collection('destinations').doc(destId).get();
  return doc.exists ? Destination.fromFirestore(doc) : null;
});
```

#### **b) ConsumerWidget & ConsumerStatefulWidget**
- Widgets that can access providers
- `ConsumerWidget` for stateless UI
- `ConsumerStatefulWidget` for stateful UI (animations, user interactions)

#### **c) Repository Pattern**
- Data access abstraction layer
- Single source of truth for data operations

#### **d) Model/DTO Pattern**
- `Destination`, `Place`, `UserProfile` models
- `fromFirestore()` — parse Firestore documents
- `toFirestore()` — serialize to Firestore format

---

## 4. CORE DESIGN SYSTEM

### **4.1 Color Palette (`AppColors`)**

```dart
Primary Green:     #7A958F  (sophisticated, trustworthy)
Green Soft:        #D9E4E1  (light, approachable)
Background:        #FFFFFF  (clean, minimal)
Text Primary:      #000000  (high contrast)
Text Muted:        #555555  (secondary info)
Danger/Error:      #D9534F  (warnings, errors)
```

**Design Philosophy:** Green symbolizes nature, travel, and exploration. Soft variations prevent eye strain and create a calming interface.

### **4.2 Theme System (`AppTheme`)**

- **Material Design 3** — Modern, responsive components
- **Custom TextTheme:**
  - `headlineLarge` — 28px, Bold (page titles)
  - `headlineMedium` — 22px, Bold (section titles)
  - `titleLarge` — 18px, Semi-Bold (card titles)
  - `bodyMedium` — 14px, Regular (body text)

- **Rounded Corners:** 16-24px radius (friendly, modern aesthetic)
- **Shadows:** Subtle box shadows with green tint (depth without heaviness)

### **4.3 Reusable UI Component: `SoftCard`**

```dart
class SoftCard extends StatelessWidget {
  const SoftCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),  // Default 16px
    this.color,                                // Optional custom color
    this.onTap,                                // Optional tap handler
    this.borderRadius = 20,                    // Default 20px radius
  });
}
```

**Usage Examples:**
- Destination cards in discovery grid
- Place list items with images
- Category tiles with icons
- Generic content containers

**Benefits:**
- **Consistency:** All cards share the same shadow, radius, and padding
- **Reusability:** Used 20+ times across the app
- **Easy theming:** Color and padding can be customized per usage

---

## 5. NAVIGATION ARCHITECTURE (`Go Router`)

### **5.1 Route Structure**

```
/splash                          — Splash screen (entry point)
/auth                            — Login/signup screen
/home                            — Home/dashboard
/discovery                       — Destination discovery
  └── destination/:destId        — Destination detail
        └── places/:category     — Places list filtered by category
/ai-tools                        — AI tools hub
  ├── chatbot                    — Travel chatbot
  ├── translator                 — Language translator
  ├── packing                    — Packing list generator
  ├── expenses                   — Expense tracker
  ├── currency                   — Currency converter
  └── planner                    — Trip planner
/trips                           — My trips/itineraries
/profile                         — User profile
```

### **5.2 Route Configuration Pattern**

```dart
GoRoute(
  path: '/discovery',
  builder: (context, state) => const DiscoveryScreen(),
  routes: [
    GoRoute(
      path: 'destination/:destId',
      builder: (context, state) => DestinationDetailScreen(
        destId: state.pathParameters['destId']!,
      ),
      routes: [
        GoRoute(
          path: 'places/:category',
          builder: (context, state) => PlacesListScreen(
            destId: state.pathParameters['destId']!,
            category: state.pathParameters['category']!,
          ),
        ),
      ],
    ),
  ],
),
```

**Key Features:**
- **Deep Linking:** Each route is a unique URL (e.g., `/discovery/destination/abc123/places/attraction`)
- **Type-Safe:** Path parameters validated at compile time
- **Redirect Logic:** Unauthenticated users redirected to `/auth`
- **Splash Screen:** Entry point while authentication status loads

### **5.3 Bottom Navigation Shell**

- **5 main tabs:** Home, Discover, AI Tools, Trips, Profile
- **StatefulNavigationShell:** Preserves state when switching tabs
- **Custom styling:** Green accent, white background, subtle shadow

---

## 6. MODULES & FEATURES BREAKDOWN

### **MODULE 1: AUTHENTICATION (`features/auth`)**

**Purpose:** User login, signup, email verification, and session management

#### **Key Files:**
- `auth_controller.dart` — Provider managing auth state
- `auth_screen.dart` — Login/signup UI

#### **Features:**
- ✅ Email/password authentication (Firebase)
- ✅ Real-time auth state monitoring
- ✅ Email verification requirement
- ✅ Auto-logout on invalid token
- ✅ Persistent user session (via Riverpod)

#### **Flow:**
1. User lands on `/splash` screen
2. App checks `authStateChangesProvider` (listens to Firebase auth stream)
3. If unverified or logged out → redirect to `/auth`
4. If verified → redirect to `/home` (dashboard)

#### **Backend Integration:**
```dart
final authStateChangesProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});
```

---

### **MODULE 2: DISCOVERY (`features/discovery`)**

**Purpose:** Browse, search, and explore destinations with hierarchical categorization

#### **Hierarchy (3 Levels):**

```
Level 1: Discovery Screen (Province/Search)
  ↓ Shows grid of all destinations
  ↓ Filter by: search text, category chips (Mountains, Beach, etc.)

Level 2: Destination Detail Screen
  ↓ Shows destination hero image, description, tags
  ↓ Shows 5-category tile grid (Attractions, Hotels, Restaurants, Banks, Shopping)

Level 3: Places List Screen
  ↓ Shows filtered places for selected category
  ↓ Each place is a card with image, name, tags, description
  ↓ Tap place → bottom sheet detail view
```

#### **Key Components:**

**a) Models**
```dart
// Destination model
class Destination {
  final String id, name, province, type;  // type: city|valley|region
  final List<String> tags;                 // ['Mountains', 'Adventure']
  final String imageUrl, description;
  
  // Firestore serialization
  factory Destination.fromFirestore(DocumentSnapshot doc) { ... }
  Map<String, dynamic> toFirestore() { ... }
}

// Place model (inside destination sub-collection)
class Place {
  final String id, name, category;        // category: attraction|hotel|restaurant|bank|shopping
  final List<String> tags;
  final String imageUrl, description, funFact, contact;
  final PlaceCoordinates? coordinates;    // {lat, lng}
}

class PlaceCoordinates {
  final double lat, lng;
}
```

**b) Data Structure (Firestore)**

```
FirebaseFirestore
├── destinations/ (collection)
│   ├── doc1 {
│   │   name: "Islamabad"
│   │   province: "Islamabad Capital Territory"
│   │   type: "city"
│   │   tags: ["Cultural", "Cities", "Heritage"]
│   │   imageUrl: "https://..."
│   │   description: "The modern capital of Pakistan..."
│   │
│   │   places/ (sub-collection)
│   │   ├── place1 { name: "Faisal Mosque", category: "attraction", ... }
│   │   ├── place2 { name: "Daman-e-Koh", category: "attraction", ... }
│   │   └── ...
│   │
│   └── doc2 { ... (Lahore) }
│
└── (14 destinations × 2-8 places each)
```

**c) Providers (State Management)**

```dart
// Real-time stream of all destinations
final destinationsStreamProvider = StreamProvider<List<Destination>>((ref) async* {
  yield* FirebaseFirestore.instance
      .collection('destinations')
      .snapshots()
      .map((snap) => snap.docs.map(Destination.fromFirestore).toList());
});

// Single destination by ID
final destinationByIdProvider = FutureProvider.family<Destination?, String>((ref, destId) async {
  final doc = await FirebaseFirestore.instance
      .collection('destinations')
      .doc(destId)
      .get();
  return doc.exists ? Destination.fromFirestore(doc) : null;
});

// Places filtered by destination + category
final placesProvider = FutureProvider.family<List<Place>, ({String destId, String category})>(
  (ref, params) async {
    final snap = await FirebaseFirestore.instance
        .collection('destinations')
        .doc(params.destId)
        .collection('places')
        .get();
    
    var places = snap.docs.map(Place.fromFirestore).toList();
    
    if (params.category.isNotEmpty) {
      places = places.where((p) => p.category == params.category).toList();
    }
    
    return places;
  },
);

// Helper function for search filtering (in-memory, no Firestore queries)
SearchResult filterDestinations(List<Destination> all, String search) {
  if (search.isEmpty) return SearchResult(destinations: all, matchedProvince: null);
  
  final lower = search.toLowerCase();
  
  // Check if search matches a province
  final matching = all.where((d) => d.province.toLowerCase().contains(lower)).toList();
  if (matching.isNotEmpty) {
    return SearchResult(
      destinations: matching,
      matchedProvince: matching.first.province,  // Return province name
    );
  }
  
  // Check if search matches destination name
  final byName = all.where((d) => d.name.toLowerCase().contains(lower)).toList();
  return SearchResult(destinations: byName, matchedProvince: null);
}
```

**d) Screens & UI**

**Discovery Screen:**
- Grid view of destination cards (2 columns)
- Search bar with "Find your next destination" placeholder
- 8 category chips: All, Mountains, Heritage, Adventure, Nature, Cultural, Beach, Cities
- Shimmer loading skeleton (6 cards while loading)
- Error state with retry button
- **"Seed Data" FAB** — One-time button to populate Firestore from hardcoded data

**Destination Detail Screen:**
- `SliverAppBar(expandedHeight: 260)` with hero image
- Gradient overlay (black at bottom for text readability)
- Destination name + province as title
- Tags row (green soft chips with rounded corners)
- Description text
- **5-category tile grid** (3 columns):
  1. Attraction Points (red: #FFE8EE)
  2. Hotels (blue: #E3F2FD)
  3. Restaurants (orange: #FFF3E0)
  4. Banks (green: #E8F5E9)
  5. Shopping (cyan: #E0F7FA)

**Places List Screen:**
- App bar showing "Hotels in Islamabad" (destination name + category)
- `SliverList.separated` of place cards
- Each card: 100×100 image (left) + name + tags (max 3) + description (2 lines)
- Loading shimmer (4 placeholder cards)
- Error state with retry
- Empty state if no places in category

**Place Detail Bottom Sheet:**
- `DraggableScrollableSheet(initialChildSize: 0.75, maxChildSize: 0.95)`
- Drag handle at top
- Hero image (200px height)
- Name + province below image
- Tags wrap
- **About section** — Multi-line description
- **Fun Fact section** — Green soft card with lightbulb icon
- **Action buttons:**
  - "Get Directions" → Copies maps URL to clipboard, shows snackbar "Maps link copied!"
  - "Contact" → Copies phone number (only shown if contact available)

#### **Key Data: 14 Destinations × ~40 Places**

**Provinces:**
1. **Islamabad Capital Territory** (1 destination: Islamabad — 7 places)
2. **Punjab** (2 destinations: Lahore — 8 places, Murree — 5 places)
3. **KPK** (3 destinations: Swat Valley — 5 places, Kaghan Valley — 2, Chitral — 1)
4. **Gilgit-Baltistan** (3 destinations: Hunza — 5 places, Skardu — 4, Diamer — 1)
5. **Azad Jammu & Kashmir** (2 destinations: Neelum Valley — 3 places, Muzaffarabad — 1)
6. **Sindh** (2 destinations: Karachi — 5 places, Thatta — 1)
7. **Balochistan** (2 destinations: Gwadar — 2 places, Hingol — 1)

**Example: Islamabad Attraction Points**
1. Faisal Mosque — One of world's largest, 300,000 capacity
2. Daman-e-Koh — Scenic mountain viewpoint
3. Pakistan Monument — Petal-shaped heritage museum
4. Margalla Hills — Hiking trails, 20+ km
5. Lok Virsa Museum — Folk traditions, crafts
6. Rawal Lake — Boating, water sports, scenic walks
7. Saidpur Village — 16th-century traditional village

#### **Seeding Strategy**

```dart
class DiscoverySeeder {
  Future<bool> isSeeded() async {
    // Check if destinations collection has data
    final snap = await _db.collection('destinations').limit(1).get();
    return snap.docs.isNotEmpty;
  }

  Future<void> seed() async {
    // Single batch with ~54 operations (14 destinations + ~40 places)
    // Each destination.set() + 2-8 place.set() = within 500 operation limit
    final batch = _db.batch();
    
    for (final destData in _seedData) {
      final destRef = _db.collection('destinations').doc();
      batch.set(destRef, Destination(...).toFirestore());
      
      for (final placeData in destData['places']) {
        final placeRef = destRef.collection('places').doc();
        batch.set(placeRef, Place(...).toFirestore());
      }
    }
    
    await batch.commit();  // Single round-trip to Firestore
  }
}
```

**Why this approach?**
- **No hardcoding in UI** — Data is fetched from Firestore in real-time
- **Flexible seeding** — If user deletes data, they can re-seed
- **Scalability** — Easy to add more destinations/places later
- **Offline-ready** — Can implement Firestore offline persistence

---

### **MODULE 3: AI TOOLS (`features/ai_tools`)**

**Purpose:** Suite of AI-powered travel assistance features

#### **Sub-modules (6 AI Tools):**

1. **Chatbot** — Travel advice, Q&A
2. **Translator** — Real-time language translation
3. **Packing List Generator** — Smart packing suggestions
4. **Expense Tracker** — Trip budget management
5. **Currency Converter** — Real-time exchange rates
6. **Trip Planner** — Itinerary builder

#### **Architecture Pattern:**
- Each tool is a separate screen
- Shared AI backend (future: Gemini API, LLMs)
- Offline-first UI (cache responses locally)
- Real-time error handling and retry logic

#### **UI Components:**
- Hub screen with 6 tools in grid/list
- Individual tool screens with custom UIs
- Input forms with validation
- Result display with formatting (markdown, tables, etc.)
- Share/export functionality

---

### **MODULE 4: MY TRIPS (`features/trips`)**

**Purpose:** Create, manage, and track travel itineraries

#### **Features:**
- ✅ Create new trip with start/end dates
- ✅ Add destinations to itinerary
- ✅ Organize by days/timeline
- ✅ Add activities, notes, bookings
- ✅ Share itinerary (future)
- ✅ Offline access (cached trips)

#### **Data Model:**
```dart
class Trip {
  final String id, name, description;
  final DateTime startDate, endDate;
  final List<TripDay> days;      // Organized by calendar day
  final List<DestinationRef> destinations;
}

class TripDay {
  final DateTime date;
  final List<Activity> activities;  // Timed events
  final String notes;
}

class Activity {
  final String id, title, description;
  final DateTime time;
  final String location;
  final String? image;
}
```

---

### **MODULE 5: PROFILE (`features/profile`)**

**Purpose:** User account management and preferences

#### **Features:**
- ✅ Edit profile (name, email, phone)
- ✅ Profile picture upload/change
- ✅ Preferences (language, currency, theme)
- ✅ View bookmarks (saved destinations)
- ✅ Trip history
- ✅ Logout

#### **Data Model:**
```dart
class UserProfile {
  final String id;              // From Firebase auth UID
  final String email;
  final String? displayName;
  final String? profilePictureUrl;
  final String? phone;
  final String preferredCurrency;  // Default: PKR
  final String preferredLanguage;  // Default: English
  final List<String> bookmarkedDestinations;
}
```

#### **UI Components:**
- Circular profile avatar (image picker fallback to initials)
- Editable fields with validation
- Image upload with progress indicator
- Settings switches (notifications, offline mode, etc.)
- Logout button with confirmation dialog

---

### **MODULE 6: HOME (`features/home`)**

**Purpose:** Dashboard/main entry point after login

#### **Content:**
- ✅ Personalized greeting ("Welcome, [Name]!")
- ✅ Quick stats (trips planned, destinations visited, saved favorites)
- ✅ Recent trips carousel
- ✅ Recommended destinations (based on browsing history)
- ✅ Quick action buttons (new trip, quick view, browse all)
- ✅ Inspirational travel quotes/tips carousel

#### **UI Pattern:**
- `CustomScrollView` with `SliverAppBar` and `SliverList`
- Multiple `SliverToBoxAdapter` sections
- Horizontal scrolling carousels with `ListView.builder`
- SoftCard components for each section

---

### **MODULE 7: SPLASH (`features/splash`)**

**Purpose:** Splash screen shown during app startup

#### **Features:**
- ✅ Logo + brand name animation (fade-in)
- ✅ Loading indicator while checking auth state
- ✅ Auto-redirect to `/auth` or `/home` based on auth status
- ✅ Smooth transition (no black screen flicker)

---

## 7. UI/UX COMPONENTS & PATTERNS

### **7.1 Card Components**

#### **SoftCard** (Base reusable card)
```dart
SoftCard(
  color: Colors.white,
  padding: EdgeInsets.all(16),
  borderRadius: 20,
  onTap: () => { /* Handle tap */ },
  child: Column(children: [ /* Content */ ])
)
```
**Uses:**
- Destination cards in discovery grid
- Place list items
- Category tiles
- Generic content containers

**Styling:**
- Rounded corners: 20px
- Shadow: Green-tinted, Y-offset +8, blur 22
- Padding: Customizable (default 16px)
- Tap effect: Ripple animation

#### **CategoryTile** (Grid items)
```dart
_CategoryTileWidget(
  label: 'Attraction Points',
  icon: Icons.attractions_rounded,
  bgColor: Color(0xFFFFEBEE),  // Red soft
  iconColor: Color(0xFFD32F2F),  // Red
  onTap: () => context.push('/discovery/destination/$destId/places/attraction'),
)
```

#### **PlaceListCard** (List items)
```dart
_PlaceListCard(
  place: place,
  onTap: () => showPlaceDetailSheet(context, place),
)
// Image (100×100) left | Name + tags + description right
```

### **7.2 Form Components**

#### **Text Input**
```dart
TextField(
  decoration: InputDecoration(
    hintText: 'Search regions, cities...',
    prefixIcon: Icon(Icons.search),
    filled: true,
    fillColor: AppColors.inputFill,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
  ),
)
```

**Styling:**
- Fill color: Light gray (#F7F7F7)
- Border radius: 16px
- Icon color: Green
- Focus state: Green border (1.4px width)
- Error state: Red border + red error text (12px)

#### **Chip/Tag**
```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
  decoration: BoxDecoration(
    color: AppColors.greenSoft,
    borderRadius: BorderRadius.circular(16),
  ),
  child: Text('Cultural', style: TextStyle(color: AppColors.green, fontSize: 12)),
)
```

### **7.3 Buttons**

#### **Primary Button (ElevatedButton)**
```dart
ElevatedButton(
  onPressed: () => { /* Action */ },
  child: Text('Save Changes'),
)
```
**Styling:** Green background, white text, 16px radius, 24px horizontal padding

#### **Secondary Button (OutlinedButton)**
```dart
OutlinedButton(
  onPressed: () => { /* Action */ },
  child: Text('Cancel'),
)
```
**Styling:** Green border, green text, 16px radius

#### **Floating Action Button (FAB)**
```dart
FloatingActionButton.extended(
  onPressed: _seed,
  backgroundColor: AppColors.green,
  icon: Icon(Icons.upload_rounded, color: Colors.white),
  label: Text('Seed Data', style: TextStyle(color: Colors.white)),
)
```

### **7.4 Loading States**

#### **Shimmer Skeleton**
```dart
SoftCard(
  color: AppColors.greenSoft.withValues(alpha: 0.3),
  child: Container(height: 100),
)
```
Placeholder cards shown while data loads

#### **Spinner**
```dart
CircularProgressIndicator(
  color: AppColors.green,
  strokeWidth: 2,
)
```

### **7.5 Error States**

#### **Error Screen**
```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Icon(Icons.error_outline_rounded, size: 48, color: AppColors.textMuted),
    SizedBox(height: 16),
    Text('Failed to load destinations'),
    SizedBox(height: 16),
    ElevatedButton(onPressed: () => ref.refresh(provider), child: Text('Retry')),
  ],
)
```

### **7.6 Empty States**

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Icon(Icons.location_off_rounded, size: 48, color: AppColors.textMuted),
    SizedBox(height: 16),
    Text('No destinations found'),
  ],
)
```

---

## 8. STATE MANAGEMENT DEEP DIVE (Riverpod)

### **8.1 Provider Types Used**

#### **1. StreamProvider** (Real-time data)
```dart
// Listens to Firestore collection changes
final destinationsStreamProvider = StreamProvider<List<Destination>>((ref) {
  return FirebaseFirestore.instance
      .collection('destinations')
      .snapshots()
      .map((snap) => snap.docs.map(Destination.fromFirestore).toList());
});

// Usage in widget
final destinationsAsync = ref.watch(destinationsStreamProvider);
destAsync.when(
  loading: () => Shimmer(),
  error: (err, stack) => ErrorScreen(),
  data: (destinations) => DestinationGrid(destinations),
);
```

#### **2. FutureProvider.family** (Parameterized async fetch)
```dart
// Get single destination by ID
final destinationByIdProvider = FutureProvider.family<Destination?, String>((ref, destId) async {
  final doc = await FirebaseFirestore.instance
      .collection('destinations')
      .doc(destId)
      .get();
  return doc.exists ? Destination.fromFirestore(doc) : null;
});

// Usage
final destAsync = ref.watch(destinationByIdProvider('abc123'));
destAsync.when(
  loading: () => CircularProgressIndicator(),
  error: (err, stack) => ErrorWidget(),
  data: (destination) => DestinationDetail(destination!),
);
```

#### **3. StateProvider** (Mutable client-side state)
```dart
final searchProvider = StateProvider<String>((ref) => '');
final chipIndexProvider = StateProvider<int>((ref) => 0);

// Update in widget
ref.read(searchProvider.notifier).state = 'Islamabad';

// Watch changes
final search = ref.watch(searchProvider);
```

#### **4. Provider** (Computed/derived state)
```dart
final searchResultProvider = Provider<SearchResult>((ref) {
  final allDest = ref.watch(destinationsStreamProvider);
  final search = ref.watch(searchProvider);
  final chipIndex = ref.watch(chipIndexProvider);

  return allDest.when(
    loading: () => AsyncValue.loading(),
    error: (err, stack) => AsyncValue.error(err, stack),
    data: (destinations) {
      final filtered = filterDestinations(destinations, search);
      // Apply chip filtering
      return SearchResult(destinations: filtered, ...);
    },
  );
});
```

### **8.2 Advantages of Riverpod**

| Feature | Benefit |
|---------|---------|
| **No BuildContext needed** | Providers accessible anywhere (even outside widgets) |
| **Automatic caching** | Results cached until dependencies change |
| **Reactive** | UI automatically updates when data changes |
| **Family parameters** | Parameterized providers (destId-specific data) |
| **Error handling** | AsyncValue.when handles loading/error/data states |
| **Testing-friendly** | Providers can be overridden in tests |

---

## 9. BACKEND INTEGRATION (Firebase)

### **9.1 Firebase Services Used**

#### **1. Firebase Authentication**
```dart
// Check auth state
FirebaseAuth.instance.authStateChanges()

// Sign up
await FirebaseAuth.instance.createUserWithEmailAndPassword(
  email: email,
  password: password,
);
await FirebaseAuth.instance.currentUser?.sendEmailVerification();

// Sign in
await FirebaseAuth.instance.signInWithEmailAndPassword(
  email: email,
  password: password,
);

// Check email verified
final isVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;

// Sign out
await FirebaseAuth.instance.signOut();
```

#### **2. Cloud Firestore**

**Database Structure:**
```
destinations/ (collection)
├── {destId}
│   ├── name: String
│   ├── province: String
│   ├── type: String (city|valley|region)
│   ├── tags: List<String>
│   ├── imageUrl: String
│   ├── description: String
│   │
│   └── places/ (sub-collection)
│       ├── {placeId}
│       │   ├── name: String
│       │   ├── category: String
│       │   ├── tags: List<String>
│       │   ├── imageUrl: String
│       │   ├── description: String
│       │   ├── funFact: String
│       │   ├── contact: String
│       │   └── coordinates: { lat: Double, lng: Double }
│       └── ...
└── ...

users/ (collection)
├── {userId}
│   ├── email: String
│   ├── displayName: String
│   ├── profilePictureUrl: String
│   ├── phone: String
│   ├── preferredCurrency: String
│   ├── preferredLanguage: String
│   └── bookmarkedDestinations: List<String>
```

**Firestore Queries:**
```dart
// Get all destinations
FirebaseFirestore.instance.collection('destinations').snapshots()

// Get single destination
FirebaseFirestore.instance.collection('destinations').doc(destId).get()

// Get places in destination
FirebaseFirestore.instance
    .collection('destinations')
    .doc(destId)
    .collection('places')
    .get()

// Filter by category (optional, done in-memory)
places.where((p) => p.category == 'attraction').toList()
```

### **9.2 Firestore Rules (Security)**

```firestore rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Destinations: readable by all, writable by admins only
    match /destinations/{document=**} {
      allow read: if true;
      allow write: if request.auth.uid in get(/databases/$(database)/documents/admins/list).data.uids;
    }
    
    // Users: readable/writable only by themselves
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
  }
}
```

### **9.3 Data Fetching Strategy**

| Scenario | Method | Why |
|----------|--------|-----|
| **All destinations** | StreamProvider | Real-time updates, reactive |
| **Single destination** | FutureProvider.family | Single fetch, parameterized |
| **Places in destination** | FutureProvider.family | Nested collection, parameterized |
| **Search filtering** | In-memory (after Stream) | No Firestore queries needed (small dataset) |
| **User profile** | FutureProvider | One-time fetch on profile load |

---

## 10. KEY DEVELOPMENT DECISIONS & RATIONALES

### **10.1 Why Feature-Based Architecture?**

**Decision:** Split code by feature (auth, discovery, ai_tools) rather than by type (models, screens, providers).

**Rationale:**
- ✅ **Scalability:** Easy to add/remove features without touching existing code
- ✅ **Team collaboration:** Multiple developers can work on features independently
- ✅ **Maintainability:** All code for a feature is in one folder
- ✅ **Testability:** Each feature can be tested in isolation

### **10.2 Why Riverpod over Provider?**

**Decision:** Use Riverpod 3.3.1 instead of traditional Provider pattern.

**Rationale:**
- ✅ **No BuildContext needed** — Can call providers from anywhere (including middleware)
- ✅ **Better async handling** — AsyncValue.when elegantly handles loading/error/data
- ✅ **Automatic caching** — No manual cache invalidation
- ✅ **Family support** — Parameterized providers with structural equality (records)
- ✅ **Testing-friendly** — Easy to override providers in tests

### **10.3 Why Go Router over Navigator 1.0?**

**Decision:** Use Go Router 17.2.2 instead of traditional Navigator/Routes.

**Rationale:**
- ✅ **Deep linking support** — Each route has a URL
- ✅ **Declarative routing** — Routes defined in one place
- ✅ **Type-safe parameters** — Compile-time checking
- ✅ **Redirect logic** — Built-in authentication guard
- ✅ **Nested routes** — Support for hierarchical navigation (e.g., discovery → destination → places)

### **10.4 Why Firestore over SQL?**

**Decision:** Use Cloud Firestore instead of traditional SQL database.

**Rationale:**
- ✅ **Real-time streams** — Data changes pushed to clients automatically
- ✅ **Offline support** — Built-in offline persistence
- ✅ **Scalability** — Handles millions of concurrent connections
- ✅ **No backend infrastructure** — Firebase handles servers, scaling, backups
- ✅ **Sub-collections** — Hierarchical data structure (destinations + places)

### **10.5 Why SoftCard Widget?**

**Decision:** Create custom reusable SoftCard component.

**Rationale:**
- ✅ **Consistency** — All cards have identical styling (shadow, radius, padding)
- ✅ **Reusability** — Used 20+ times across app (DRY principle)
- ✅ **Easy updates** — Change styling once, updates everywhere
- ✅ **Reduced code** — No need to repeat BoxDecoration, shadow, etc.

### **10.6 Why In-Memory Filtering?**

**Decision:** Filter destinations in Dart code, not with Firestore `.where()` queries.

**Rationale:**
- ✅ **Cost-effective** — Firestore charges per query; 1 stream + in-memory filter = fewer charges
- ✅ **Fast search** — 14 destinations fit in RAM; no latency from network round-trip
- ✅ **Simpler code** — No need for complex query builders
- ✅ **Flexible filtering** — Combine multiple filters (search + chips) easily

---

## 11. FEATURES NOT YET IMPLEMENTED (Future Scope)

- [ ] AI integration (Gemini API for chatbot, translator, packing list)
- [ ] Trip bookings (flights, hotels, activities)
- [ ] Offline maps (downloaded local maps)
- [ ] Social features (share itineraries, collaborative planning)
- [ ] Push notifications (trip reminders, weather alerts)
- [ ] Payment gateway (subscription, booking payments)
- [ ] Advanced analytics (popular destinations, seasonal trends)
- [ ] Multi-language support (currently English-only)

---

## 12. TESTING STRATEGY

### **12.1 Unit Tests (Dart/Flutter)**
```dart
test('Destination.fromFirestore parses data correctly', () {
  final doc = MockDocumentSnapshot({'name': 'Islamabad', ...});
  final dest = Destination.fromFirestore(doc);
  expect(dest.name, 'Islamabad');
});
```

### **12.2 Widget Tests**
```dart
testWidgets('SoftCard onTap calls callback', (WidgetTester tester) async {
  var tapped = false;
  await tester.pumpWidget(
    SoftCard(
      onTap: () => tapped = true,
      child: Text('Tap me'),
    ),
  );
  await tester.tap(find.text('Tap me'));
  expect(tapped, true);
});
```

### **12.3 Integration Tests**
- End-to-end user flows (login → browse destinations → view details)
- Firebase integration testing with emulator
- Deep linking navigation

---

## 13. PERFORMANCE OPTIMIZATIONS

### **13.1 Image Loading**
- **Lazy loading:** Images only load when visible (ListView/GridView)
- **Caching:** Flutter caches network images automatically
- **Placeholder:** Shimmer skeleton or colored container during load

### **13.2 Provider Caching**
- **Automatic:** Riverpod caches results until dependencies change
- **Manual refresh:** `ref.refresh(provider)` for force refresh
- **Selective:** Only rebuild widgets watching the changed provider

### **13.3 Database Queries**
- **Stream vs Future:** Stream used for lists (real-time), Future for single items
- **Pagination:** Large lists can be paginated (future feature)
- **Indexes:** Firestore indexes on `province`, `category` for faster queries

---

## 14. DEPLOYMENT & BUILD CONFIGURATION

### **14.1 Android Build**
```bash
flutter build apk --release
flutter build appbundle --release  # Google Play
```

**Configuration:**
- Min SDK: 21 (Android 5.0)
- Target SDK: Latest stable
- App signing: SHA-256 fingerprint required

### **14.2 iOS Build**
```bash
flutter build ios --release
```

**Configuration:**
- iOS version: 11.0+
- Code signing: Developer certificate + provisioning profile
- App Store Connect submission

### **14.3 Firebase Configuration**
- `google-services.json` (Android)
- `GoogleService-Info.plist` (iOS)
- Firebase Console project setup (auth, Firestore, storage)

---

## 15. CODE QUALITY & STANDARDS

### **15.1 Linting**
```bash
flutter analyze
```
- 0 errors, 12 info warnings (acceptable underscore patterns)
- Follows Dart Style Guide

### **15.2 Code Style**
- **Naming:** camelCase for variables/functions, PascalCase for classes
- **Imports:** Organized (dart, flutter, packages, relative)
- **Formatting:** `dart format .`
- **Comments:** Only when WHY is non-obvious (no comments on WHAT code does)

### **15.3 Git Workflow**
- Feature branches: `feature/module-name`
- Commit messages: Descriptive, present tense
- PR reviews: Code quality check before merging

---

## 16. TROUBLESHOOTING & COMMON ISSUES

### **16.1 Duplicate Destinations in Grid**
**Problem:** Old seed data in Firestore appears duplicated  
**Solution:** Delete all documents in Firestore "destinations" collection via Firebase Console, then tap "Seed Data" FAB again

### **16.2 Images Not Loading**
**Problem:** Network images showing error icon  
**Solution:** Check internet connection, verify imageUrl is valid HTTPS, add error builder with fallback

### **16.3 Provider Not Updating**
**Problem:** Widget doesn't rebuild when data changes  
**Solution:** Ensure using `ref.watch()` not `ref.read()`; check provider dependencies

### **16.4 Deep Link Not Working**
**Problem:** Tapping notification/external link doesn't navigate correctly  
**Solution:** Verify route path matches in `app_router.dart`; check if redirect logic interferes

---

## 17. SUMMARY TABLE

| Aspect | Technology | Why Chosen |
|--------|-----------|-----------|
| **Language** | Dart | Flutter requirement, clean syntax |
| **Framework** | Flutter 3.10+ | Cross-platform (Android/iOS), fast development |
| **State Mgmt** | Riverpod 3.3.1 | Reactive, async-friendly, no BuildContext |
| **Navigation** | Go Router 17.2 | Deep linking, type-safe, declarative |
| **Database** | Cloud Firestore | Real-time, scalable, Firebase integration |
| **Auth** | Firebase Auth | Email/password, email verification, free tier |
| **UI Design** | Material Design 3 | Modern, accessible, consistent |
| **Color Scheme** | Green + Soft Green | Nature (travel), professional, accessible |
| **Card Component** | Custom SoftCard | Consistency, reusability, reduced code |
| **Architecture** | Feature-based Clean | Scalable, maintainable, team-friendly |

---

## CONCLUSION

TourMate is built with modern Flutter best practices, focusing on **scalability**, **maintainability**, and **user experience**. The feature-based architecture allows independent development of modules. Riverpod provides reactive, type-safe state management. Firebase backend eliminates infrastructure overhead. The custom SoftCard design system ensures visual consistency across the app.

**Key strengths:**
- ✅ Clean, modular code architecture
- ✅ Real-time data with Firestore streams
- ✅ Responsive, intuitive UI
- ✅ Robust error handling and loading states
- ✅ Ready for scaling (more features, more users)

---

**Document Version:** 1.0  
**Last Updated:** May 6, 2026  
**For Viva Presentation**
