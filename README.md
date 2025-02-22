# AI Travel Planner

A Flutter application that helps users plan their trips using AI assistance. The app provides personalized travel itineraries, recommendations, and trip management features.

## Features

- **AI-Powered Trip Planning**: Get intelligent suggestions and personalized itineraries for your trips
- **Firebase Authentication**: Secure user authentication system
- **Smart Recommendations**: Receive suggestions for attractions, restaurants, and activities
- **Budget Management**: Plan trips according to different budget types (Budget, Moderate, Luxury)
- **Cross-Platform Support**: Works on Android, iOS, and Web platforms

## Technical Stack

- **Frontend**: Flutter
- **Backend**: Firebase
- **AI Integration**: Google Generative AI (Gemini)
- **Authentication**: Firebase Auth
- **Database**: Cloud Firestore
- **State Management**: Native Flutter State Management

## Dependencies

- firebase_core: ^2.27.1
- firebase_auth: ^4.17.9
- cloud_firestore: ^4.15.9
- google_generative_ai: ^0.2.2
- http: ^1.2.1
- table_calendar: ^3.0.9
- intl: ^0.19.0
- cached_network_image: ^3.3.1
- url_launcher: ^6.2.5
- shared_preferences: ^2.2.2
- lottie: ^3.1.0

## Getting Started

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Configure Firebase:
   - Add your `google-services.json` to `android/app`
   - Add your `GoogleService-Info.plist` to `ios/Runner`

4. Run the app:
   ```bash
   flutter run
   ```

## Project Structure

- `lib/`
  - `screens/`
    - `auth/`: Authentication related screens
    - `create_trip/`: Trip creation and planning screens
    - `home_screen.dart`: Main dashboard
    - `onboarding/`: Onboarding screens
  - `main.dart`: Application entry point

## Platform Support

- Android
- iOS
- Web
- Linux
- macOS
- Windows

## Environment Requirements

- Flutter SDK: ^3.5.4
- Dart: Latest stable version
- Android SDK: 21 or higher
- iOS: 11.0 or higher

## License

This project is proprietary and confidential. Unauthorized copying or distribution of this project's files, via any medium, is strictly prohibited.
