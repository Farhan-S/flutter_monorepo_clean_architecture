# Splash Screen Feature Integration Guide

## ✅ Feature Created Successfully

The `features_splash` package has been created following the same Clean Architecture structure as other features.

## 📦 Package Structure

```
packages/features_splash/
├── lib/
│   ├── features_splash.dart                      # Barrel export
│   ├── domain/                                   # Business Logic
│   │   ├── entities/
│   │   │   └── app_init_entity.dart             # App initialization entity
│   │   ├── repositories/
│   │   │   └── app_initialization_repository.dart # Repository interface
│   │   └── usecases/
│   │       ├── initialize_app_usecase.dart      # Initialize app use case
│   │       └── check_auth_status_usecase.dart   # Check auth status
│   ├── data/                                     # Data Layer
│   │   ├── models/
│   │   │   └── app_init_model.dart              # App init model (DTO)
│   │   ├── datasources/
│   │   │   └── app_init_datasource.dart         # Data source
│   │   └── repositories/
│   │       └── app_initialization_repository_impl.dart # Repository impl
│   └── presentation/                             # UI Layer
│       ├── bloc/
│       │   ├── splash_bloc.dart                 # Splash BLoC
│       │   ├── splash_event.dart                # Events
│       │   └── splash_state.dart                # States
│       └── pages/
│           └── splash_page.dart                 # Splash page UI
├── pubspec.yaml
└── README.md
```

## 🎯 Features Implemented

- ✅ App initialization logic with 2-second delay
- ✅ Token validation and authentication check
- ✅ Automatic navigation based on auth status
- ✅ Smooth fade-in animations
- ✅ Error handling with user feedback
- ✅ Beautiful splash screen UI
- ✅ Complete Clean Architecture implementation
- ✅ BLoC state management

## 🔧 Changes Made

### 1. Core Package Updates

**File**: `packages/core/lib/src/routes/app_routes.dart`

Added splash route:

```dart
static const String splash = '/splash';
```

Updated navigation helpers to use `pushNamedAndRemoveUntil` for proper navigation:

```dart
static Future<void> navigateToSplash(BuildContext context) {
  return Navigator.pushNamedAndRemoveUntil(context, splash, (route) => false);
}

static Future<void> navigateToHome(BuildContext context) {
  return Navigator.pushNamedAndRemoveUntil(context, home, (route) => false);
}

static Future<void> navigateToLogin(BuildContext context) {
  return Navigator.pushNamedAndRemoveUntil(context, login, (route) => false);
}
```

### 2. App Package Updates

**File**: `packages/app/pubspec.yaml`

Added splash feature dependency:

```yaml
features_splash:
  path: ../features_splash
```

**File**: `packages/app/lib/injection_container.dart`

Added splash feature DI registration:

```dart
import 'package:features_splash/features_splash.dart';

// Splash feature registrations
getIt.registerLazySingleton<AppInitDataSource>(
  () => AppInitDataSource(getIt<TokenStorage>()),
);

getIt.registerLazySingleton<AppInitializationRepository>(
  () => AppInitializationRepositoryImpl(getIt<AppInitDataSource>()),
);

getIt.registerLazySingleton<InitializeAppUseCase>(
  () => InitializeAppUseCase(getIt<AppInitializationRepository>()),
);

getIt.registerLazySingleton<CheckAuthStatusUseCase>(
  () => CheckAuthStatusUseCase(getIt<AppInitializationRepository>()),
);

getIt.registerFactory<SplashBloc>(
  () => SplashBloc(
    initializeAppUseCase: getIt<InitializeAppUseCase>(),
    checkAuthStatusUseCase: getIt<CheckAuthStatusUseCase>(),
  ),
);
```

**File**: `packages/app/lib/routes/app_route_generator.dart`

Added splash route registration:

```dart
import 'package:features_splash/features_splash.dart';

// In registerAllRoutes()
AppRouteRegistry.registerRoute(
  AppRoutes.splash,
  (settings) => MaterialPageRoute(
    builder: (_) => BlocProvider(
      create: (_) => getIt<SplashBloc>(),
      child: const SplashPage(),
    ),
    settings: settings,
  ),
);
```

**File**: `packages/app/lib/main.dart`

Changed initial route to splash:

```dart
initialRoute: AppRoutes.splash, // Changed from AppRoutes.home
```

## 🚀 How It Works

### Navigation Flow

```
App Start
    ↓
SplashPage (shows for ~2 seconds)
    ↓
Initialize App (check tokens)
    ↓
    ├─→ Authenticated → Navigate to Home (/)
    │                   (removes splash from stack)
    │
    └─→ Not Authenticated → Navigate to Login (/login)
                           (removes splash from stack)
```

### States

- **SplashInitial**: Starting state
- **SplashLoading**: App initialization in progress
- **SplashAuthenticated**: User has valid token → go to home
- **SplashUnauthenticated**: No valid token → go to login
- **SplashError**: Initialization failed → show error, then go to login

### Events

- **InitializeAppEvent**: Triggers app initialization
- **CheckAuthStatusEvent**: Checks authentication status only

## 🎨 UI Features

- Animated fade-in effect (1.5 seconds)
- App icon with shadow effect
- App name and tagline
- Loading spinner during initialization
- Error display with icon
- Version number
- Blue gradient background

## ⚙️ Customization

### Change Splash Duration

Edit `packages/features_splash/lib/data/datasources/app_init_datasource.dart`:

```dart
// Line 13: Change duration
await Future.delayed(const Duration(seconds: 2)); // Change to your preference
```

### Customize Appearance

Edit `packages/features_splash/lib/presentation/pages/splash_page.dart`:

- Change colors
- Update app icon/logo
- Modify text and styling
- Adjust animations

### Add Backend Token Validation

In `app_init_datasource.dart`, implement `verifyTokenWithBackend()`:

```dart
Future<bool> verifyTokenWithBackend(String token) async {
  try {
    final dioClient = DioClient();
    await dioClient.get(ApiRoutes.validateToken);
    return true;
  } catch (e) {
    return false;
  }
}
```

Then call it in `initializeApp()`.

## 📊 Testing

To test the splash screen:

```bash
cd packages/app
flutter run
```

The app will now:

1. Show splash screen first
2. Check authentication
3. Navigate to appropriate screen

## ✅ Verification

Run these commands to verify everything is working:

```bash
# Check for errors
cd packages/features_splash
flutter analyze

cd ../app
flutter analyze

# Get dependencies
cd packages/features_splash
flutter pub get

cd ../app
flutter pub get

# Run the app
cd packages/app
flutter run
```

## 🎯 Next Steps

1. **Customize the splash UI** to match your brand
2. **Adjust the duration** as needed
3. **Add backend validation** if required
4. **Test on different devices** to ensure smooth experience
5. **Update app icon** in splash_page.dart

## 📝 Notes

- Splash screen uses `pushNamedAndRemoveUntil` to prevent back navigation
- Token check is done during initialization (no extra API call)
- Error states automatically redirect to login after 2 seconds
- All navigation clears the back stack properly
- BLoC pattern ensures clean separation of logic

## 🆘 Troubleshooting

**Issue**: Splash screen not showing

- Check `main.dart` has `initialRoute: AppRoutes.splash`
- Verify route is registered in `app_route_generator.dart`

**Issue**: Navigation not working

- Ensure `AppRoutes` navigation helpers are updated
- Check that routes use `pushNamedAndRemoveUntil`

**Issue**: Token check failing

- Verify `TokenStorage` is properly injected
- Check `SecureTokenStorage` is registered in DI

---

✅ **Status**: Splash feature fully integrated and ready to use!
