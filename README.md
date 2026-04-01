# AI Campus Guide - Setup Instructions

## Project Overview
A Flutter mobile app for Faculty of Science, Ain Shams University campus navigation with AI assistant.

## Features
- Search campus locations
- Browse by category
- Google Maps integration
- AI Assistant for campus queries
- 10 seeded campus locations

## Prerequisites
1. Flutter SDK (3.0+)
2. Dart SDK (3.0+)
3. Firebase Account
4. Google Maps API Key

## Step 1: Firebase Setup

### 1.1 Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project: "AI Campus Guide"
3. Enable Firestore Database

### 1.2 Add Android App
1. In Firebase Console, add Android app
2. Package name: `com.example.ai_campus_guide`
3. Download `google-services.json`
4. Place in: `android/app/google-services.json`

### 1.3 Add iOS App (Optional)
1. In Firebase Console, add iOS app
2. Bundle ID: `com.example.aiCampusGuide`
3. Download `GoogleService-Info.plist`
4. Place in: `ios/Runner/GoogleService-Info.plist`

### 1.4 Firestore Setup
Create collections:
- `locations` - 10 documents (auto-seeded)
- `categories` - 5 documents (auto-seeded)

## Step 2: Google Maps API

### 2.1 Get API Key
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Enable Maps SDK for Android
3. Create API Key

### 2.2 Configure Android
Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_API_KEY"/>
```

### 2.3 Update .env File
```
GOOGLE_MAPS_API_KEY=your_google_maps_api_key
FIREBASE_API_KEY=your_firebase_api_key
FIREBASE_PROJECT_ID=your_project_id
```

## Step 3: Install Dependencies

```bash
cd ai_campus_guide
flutter pub get
```

## Step 4: Build & Run

### Android
```bash
flutter build apk --debug
flutter run
```

### iOS
```bash
flutter build ios --debug
flutter run
```

## Project Structure

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── theme/
│   │   └── app_theme.dart
│   └── utils/
│       └── constants.dart
├── models/
│   ├── location_model.dart
│   ├── category_model.dart
│   ├── chat_message_model.dart
│   └── ai_response.dart
├── services/
│   ├── firebase_service.dart
│   ├── locations_service.dart
│   ├── categories_service.dart
│   ├── ai_service.dart
│   └── maps_service.dart
├── providers/
│   ├── locations_provider.dart
│   ├── categories_provider.dart
│   ├── filters_provider.dart
│   └── chat_provider.dart
└── ui/
    ├── widgets/
    │   ├── search_bar.dart
    │   ├── category_chip.dart
    │   ├── location_card.dart
    │   ├── primary_button.dart
    │   ├── chat_bubble.dart
    │   ├── map_location_preview.dart
    │   └── bottom_nav.dart
    └── screens/
        ├── splash_screen.dart
        ├── home_screen.dart
        ├── services_screen.dart
        ├── map_screen.dart
        ├── search_results_screen.dart
        ├── location_details_screen.dart
        └── ai_assistant_screen.dart
```

## Sample Data (Auto-seeded)

### Locations (10)
1. Student Affairs Office - Main Building, Ground Floor
2. Main Library - Library Building, All Floors
3. Chemistry Department - Science Building A, 1st & 2nd Floor
4. Physics Department - Science Building B, 1st & 2nd Floor
5. Computer Lab - IT Center, 2nd Floor
6. Registration Office - Main Building, 1st Floor
7. Administration Building - Administration Building, All Floors
8. Cafeteria - Student Center, Ground Floor
9. Auditorium - Conference Center, Ground Floor
10. IT Support Office - IT Center, Ground Floor

### Categories (5)
1. Student Services
2. Departments
3. Labs
4. Administration
5. Facilities

## AI Assistant

The AI Assistant uses keyword matching to find relevant locations. It can:
- Answer questions about campus locations
- Provide directions
- Suggest locations based on queries
- Open suggested locations on map or details

To enable OpenAI integration, add your API key to .env:
```
OPENAI_API_KEY=sk-...
```

## Navigation Flow

```
App → Splash (1.5s) → Home
                      ├── Search → SearchResultsScreen
                      ├── Category → ServicesScreen (filtered)
                      └── Open Map → MapScreen

ServicesScreen → LocationDetailsScreen

MapScreen → Marker tap → Preview Bottom Sheet → LocationDetailsScreen

AIAssistantScreen → Chat → Suggestion → Open Details / Open on Map
```

